//
//  BChatSDK.m
//  AFNetworking
//
//  Created by Ben on 11/7/17.
//

#import "BChatSDK.h"
#import "BConfiguration.h"
#import <ChatSDK/Core.h>
#import <ChatSDK/ChatSDK-Swift.h>

#define bRootPathKey @"chat_sdk_root_path"
#define bDatabaseVersionKey @"chat_sdk_database_version"

@implementation BChatSDK

@synthesize configuration = _configuration;
@synthesize interfaceAdapter = _interfaceAdapter;
@synthesize storageAdapter = _storageAdapter;
@synthesize networkAdapter = _networkAdapter;
@synthesize logger = _logger;
@synthesize settings = _settings;
@synthesize modules = _modules;

static BChatSDK * instance;

+(nonnull BChatSDK *) shared {
    
    @synchronized(self) {
        
        // If the sharedSoundManager var is nil then we need to allocate it.
        if(instance == nil) {
            // Allocate and initialize an instance of this class
            instance = [[self alloc] init];
        }
    }
    return instance;
}

-(instancetype) init {
    if((self = [super init])) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:Nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:Nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(saveData)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:Nil];
        _moduleHelper = [BModuleHelper new];
        _logger = [BLogger new];
    }
    return self;
}

+(void) initialize: (BConfiguration *) config app:(UIApplication *)application options:(NSDictionary *)launchOptions modules: (NSArray<PModule> *) modules {
    [self.shared initialize:config app:application options:launchOptions modules: modules networkAdapter: nil interfaceAdapter: nil];
    [self application:application didFinishLaunchingWithOptions:launchOptions];
}

+(void) initialize: (BConfiguration *) config app:(UIApplication *)application options:(NSDictionary *)launchOptions  modules: (NSArray<PModule> *) modules networkAdapter:(id<PNetworkAdapter>)networkAdapter interfaceAdapter:(id<PInterfaceAdapter>)interfaceAdapter {
    [self.shared initialize:config app:application options:launchOptions modules: modules networkAdapter: networkAdapter interfaceAdapter: interfaceAdapter];
    [self application:application didFinishLaunchingWithOptions:launchOptions];
}

-(void) initialize: (BConfiguration *) config app:(UIApplication *)application options:(NSDictionary *)launchOptions  modules: (NSArray<PModule> *) modules networkAdapter:(id<PNetworkAdapter>)networkAdapter interfaceAdapter:(id<PInterfaceAdapter>)interfaceAdapter {

    _configuration = config;
    
    [_moduleHelper activateCoreModules];
    for (id<PModule> module in modules) {
        [module activate];
    }
    
    if(interfaceAdapter) {
        _interfaceAdapter = interfaceAdapter;
    }
    if(networkAdapter) {
        _networkAdapter = networkAdapter;
    }
//    [_moduleHelper activateModules];
    
    _settings = [Settings new];
    
    [self clearDataIfNecessary];
}

-(void) appWillResignActive: (NSNotification *) notification {
    if(self.networkAdapter && BChatSDK.auth.isAuthenticated) {
        [self.networkAdapter.core goOffline];
    }
}

-(void) appDidBecomeActive: (NSNotification *) notification {
    if(self.networkAdapter) {
//        [BHookNotification notificationDidBecomeActive: notification.object];

        // TODO: Check this
        [self.networkAdapter.core goOnline];
    }
}

-(void) saveData {
    if (self.networkAdapter) {
        [self.networkAdapter.core save];
    }
}



// If the configuration isn't set, return a default value
-(BConfiguration *) config {
    if(!_configuration) {
        _configuration = [BConfiguration configuration];
    }
    return _configuration;
}

+(BConfiguration *) config {
    return instance.config;
}

+(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    if(BChatSDK.push) {
        [BChatSDK.push application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    }
}

+(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if(BChatSDK.push) {
        [BChatSDK.push application:application didReceiveRemoteNotification:userInfo];
    }
}

+(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    if(BChatSDK.push && BChatSDK.config.shouldAskForNotificationsPermission) {
        [BChatSDK.push registerForPushNotificationsWithApplication:application launchOptions:launchOptions];
    }
    return YES;
}

// Authenticate using a Firebase token
+(RXPromise *) authenticateWithToken: (NSString *) token {
    return [BIntegrationHelper authenticateWithToken:token];
}

// Update the username image and image url safely i.e. this method will wait until
// the user has been authenticated correctly by using the post auth hook
+(void) updateUserWithName: (NSString *) name image: (UIImage *) image url: (NSString *) url {
    [BIntegrationHelper updateUserWithName:name image:image url:url];
}

// Logout
+(RXPromise *) logout {
    return [BIntegrationHelper logout];
}

-(void) clearDataIfNecessary {
    NSString * rootPath = [[NSUserDefaults standardUserDefaults] stringForKey:bRootPathKey];
    NSString * newRootPath = _configuration.rootPath;

    NSString * databaseVersion = [[NSUserDefaults standardUserDefaults] stringForKey:bDatabaseVersionKey];
    NSString * newDatabaseVersion = _configuration.databaseVersion;
    
    if (BChatSDK.config.clearDataWhenRootPathChanges && rootPath && newRootPath && ![rootPath isEqualToString:newRootPath]) {
        [BChatSDK.db deleteAllData];
    }
    else if (BChatSDK.config.clearDatabaseWhenDataVersionChanges && ![databaseVersion isEqual:newDatabaseVersion]) {
        [BChatSDK.db deleteAllData];
    }

    if (newRootPath) {
        [[NSUserDefaults standardUserDefaults] setObject:newRootPath forKey:bRootPathKey];
    }
    if (newDatabaseVersion) {
        [[NSUserDefaults standardUserDefaults] setObject:newDatabaseVersion forKey:bDatabaseVersionKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BBackgroundPushNotificationQueue *) pushQueue {
    if (!_pushQueue) {
        _pushQueue = [BBackgroundPushNotificationQueue new];
    }
    return _pushQueue;
}

+(id<PCoreHandler>) core {
    return self.a.core;
}

+(id<PAuthenticationHandler>) auth {
    return self.a.auth;
}

+(id<PUploadHandler>) upload {
    return self.a.upload;
}

+(id<PVideoMessageHandler>) videoMessage {
    return self.a.videoMessage;
}

+(id<PAudioMessageHandler>) audioMessage {
    return self.a.audioMessage;
}

+(id<PImageMessageHandler>) imageMessage {
    return self.a.imageMessage;
}

+(id<PLocationMessageHandler>) locationMessage {
    return self.a.locationMessage;
}

+(id<PPushHandler>) push {
    return self.a.push;
}

+(id<PContactHandler>) contact {
    return self.a.contact;
}

+(id<PTypingIndicatorHandler>) typingIndicator {
    return self.a.typingIndicator;
}

+(id<PModerationHandler>) moderation {
    return self.a.moderation;
}

+(id<PSearchHandler>) search {
    return self.a.search;
}

+(id<PPublicThreadHandler>) publicThread {
    return self.a.publicThread;
}

+(id<PBlockingHandler>) blocking {
    return self.a.blocking;
}

+(id<PLastOnlineHandler>) lastOnline {
    return self.a.lastOnline;
}

+(id<PNearbyUsersHandler>) nearbyUsers {
    return self.a.nearbyUsers;
}

+(id<PReadReceiptHandler>) readReceipt {
    return self.a.readReceipt;
}

+(id<PStickerMessageHandler>) stickerMessage {
    return self.a.stickerMessage;
}

+(id<PUsersHandler>) users {
    return self.a.users;
}

+(id<PUser>) currentUser {
    return self.auth.currentUser;
}

+(NSString *) currentUserID {
    return self.auth.currentUserID;
}

+(BOOL) isMe: (id<PUser>) user {
    return [self.currentUser isEqualToEntity:user];
}

+(id) handler: (NSString *) name {
    return [self.a handlerWithName:name];
}

+(id<PHookHandler>) hook {
    return self.a.hook;
}

+(id<PNetworkAdapter>) a {
    return self.shared.networkAdapter;
}

+(id<PInterfaceAdapter>) ui {
    return self.shared.interfaceAdapter;
}

+(id<PStorageAdapter>) db {
    return self.shared.storageAdapter;
}

+(id<CallHandler>) call {
    return self.a.call;
}

+(id<PFileMessageHandler>) fileMessage {
    return self.a.fileMessage;
}

+(id<PEncryptionHandler>) encryption {
    return self.a.encryption;
}

+(id<PEventHandler>) event {
    return self.a.event;
}

+(id<PThreadHandler>) thread {
    return self.a.thread;
}

+(id<PInternetConnectivityHandler>) connectivity {
    return self.a.connectivity;
}

-(NSBundle *) bundle {
    if(!_bundle) {
        _bundle = [NSBundle bundleWithName:@"Frameworks/ChatSDK.framework/ChatUI"];
    }
    return _bundle;
}

-(NSBundle *) colorsBundle {
    if(!_colorsBundle) {
        _colorsBundle = self.bundle;
    }
    return _colorsBundle;
}

-(NSBundle *) iconsBundle {
    if(!_iconsBundle) {
        _iconsBundle = self.bundle;
    }
    return _iconsBundle;
}

@end
