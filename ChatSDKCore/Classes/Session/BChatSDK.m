//
//  BChatSDK.m
//  AFNetworking
//
//  Created by Ben on 11/7/17.
//

#import "BChatSDK.h"
#import "BConfiguration.h"
#import <ChatSDK/Core.h>

#define bRootPathKey @"chat_sdk_root_path"
#define bDatabaseVersionKey @"chat_sdk_database_version"

@implementation BChatSDK

@synthesize configuration = _configuration;
@synthesize interfaceAdapter = _interfaceAdapter;
@synthesize storageAdapter = _storageAdapter;
@synthesize networkAdapter = _networkAdapter;

static BChatSDK * instance;

+(BChatSDK *) shared {
    
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
                                                 selector:@selector(appDidResignActive)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:Nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appDidBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:Nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(saveData)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:Nil];
        _moduleHelper = [BModuleHelper new];
    }
    return self;
}

+(void) initialize: (BConfiguration *) config app:(UIApplication *)application options:(NSDictionary *)launchOptions interfaceAdapter: (id<PInterfaceAdapter>) adapter {
    [self.shared initialize:config app:application options:launchOptions interfaceAdapter: adapter];
    [self application:application didFinishLaunchingWithOptions:launchOptions];
}

-(void) initialize: (BConfiguration *) config app:(UIApplication *)application options:(NSDictionary *)launchOptions interfaceAdapter: (id<PInterfaceAdapter>) adapter {
    _configuration = config;
    
    [_moduleHelper activateCoreModules];
    if(adapter) {
        _interfaceAdapter = adapter;
    }
    [_moduleHelper activateModules];
    
    [self clearDataIfNecessary];
}

+(void) initialize: (BConfiguration *) config app:(UIApplication *)application options:(NSDictionary *)launchOptions {
    [self initialize:config app:application options:launchOptions interfaceAdapter:Nil];
}

-(void) appDidResignActive {
    if(self.networkAdapter) {
        [self.networkAdapter.core save];
        [self.networkAdapter.core goOffline];
    }
}

-(void) appDidBecomeActive {
    if(self.networkAdapter) {
        // TODO: Check this
        [self.networkAdapter.core goOnline];
    }
}

-(void) saveData {
    if (self.networkAdapter) {
        [self.networkAdapter.core save];
    }
}

-(BOOL) activateModuleForName: (NSString *) name {
    return [_moduleHelper activateModuleForName:name];
}

-(void) activateModules {
    [_moduleHelper activateModules];
}

-(void) activateModulesForFirebase {
    [_moduleHelper activateModulesForFirebase];
}

-(void) activateModulesForXMPP {
    [_moduleHelper activateModulesForXMPP];
}

// If the configuration isn't set, return a default value
-(BConfiguration *) configuration {
    if(!_configuration) {
        _configuration = [BConfiguration configuration];
    }
    return _configuration;
}

// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
+(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if (BChatSDK.socialLogin) {
        return [BChatSDK.socialLogin application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    return NO;
}

+(BOOL) application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if (BChatSDK.socialLogin) {
        return [BChatSDK.socialLogin application: app openURL: url options: options];
    }
    return NO;
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
    if(BChatSDK.socialLogin) {
        [BChatSDK.socialLogin application:application didFinishLaunchingWithOptions:launchOptions];
    }
    return YES;
}

-(void) preventAutomaticActivationForModule: (NSString *) moduleName {
    [_moduleHelper excludeModules:@[moduleName]];
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

+(BConfiguration *) config {
    return self.shared.configuration;
}

-(void) clearDataIfNecessary {
    NSString * rootPath = [[NSUserDefaults standardUserDefaults] stringForKey:bRootPathKey];
    NSString * newRootPath = _configuration.rootPath;

    NSString * databaseVersion = [[NSUserDefaults standardUserDefaults] stringForKey:bDatabaseVersionKey];
    NSString * newDatabaseVersion = _configuration.databaseVersion;
    
    if (BChatSDK.config.clearDataWhenRootPathChanges && rootPath && newRootPath && ![rootPath isEqualToString:newRootPath]) {
        [BChatSDK.db deleteAllData];
        [BChatSDK.db saveToStore];
    }
    else if (BChatSDK.config.clearDatabaseWhenDataVersionChanges && ![databaseVersion isEqual:newDatabaseVersion]) {
        [BChatSDK.db deleteAllData];
        [BChatSDK.db saveToStore];
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

+(id<PSocialLoginHandler>) socialLogin {
    return self.a.socialLogin;
}

+(id<PUsersHandler>) users {
    return self.a.users;
}

+(id<PUser>) currentUser {
    return BChatSDK.core.currentUserModel;
}

+(NSString *) currentUserID {
    return self.currentUser.entityID;
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

+(id<PFileMessageHandler>) fileMessage {
    return self.a.fileMessage;
}

+(id<PEncryptionHandler>) encryption {
    return self.a.encryption;
}

+(id<PEventHandler>) event {
    return self.a.event;
}

+(id<PInternetConnectivityHandler>) connectivity {
    return self.a.connectivity;
}

@end
