//
//  BChatSDK.h
//  AFNetworking
//
//  Created by Ben on 11/7/17.
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PNetworkAdapter.h>


@class BConfiguration;
@class RXPromise;
@class BBackgroundPushNotificationQueue;
@class BInternetConnectivity;
@class BModuleHelper;
@class Settings;

@class Colors;
@class Icons;

@protocol PInterfaceAdapter;
@protocol PUser;
@protocol PStorageAdapter;
@protocol PLogger;
@protocol PModule;

@interface BChatSDK : NSObject {
    BConfiguration * _configuration;
    id<PInterfaceAdapter> _interfaceAdapter;
    id<PStorageAdapter> _storageAdapter;
    id<PNetworkAdapter> _networkAdapter;
    BBackgroundPushNotificationQueue * _pushQueue;
    BModuleHelper * _moduleHelper;
    id<PLogger> _logger;
    Settings * _settings;
    NSMutableArray<PModule> * _modules;
    NSArray * _identifier;
}

@property (nonatomic, readonly) BConfiguration * configuration;
@property (nonatomic, readwrite) id<PInterfaceAdapter> interfaceAdapter;
@property (nonatomic, readwrite) id<PStorageAdapter> storageAdapter;
@property (nonatomic, readwrite) id<PNetworkAdapter> networkAdapter;
@property (nonatomic, readwrite) NSBundle * colorsBundle;
@property (nonatomic, readwrite) NSBundle * bundle;
@property (nonatomic, readwrite) NSBundle * iconsBundle;
@property (nonatomic, readwrite) id<PLogger> logger;
@property (nonatomic, readwrite) Settings * settings;
@property (nonatomic, readwrite) NSMutableArray<PModule> * modules;
@property (nonatomic, readonly) NSArray * identifier;


+(nonnull BChatSDK *) shared;

// Application lifecycle methods - should be called from App Delegate
+(void) initialize: (BConfiguration *) config app:(UIApplication *)application options:(NSDictionary *)launchOptions modules: (NSArray<PModule> *) modules;
+(void) initialize: (BConfiguration *) config app:(UIApplication *)application options:(NSDictionary *)launchOptions  modules: (NSArray<PModule> *) modules networkAdapter:(nullable id<PNetworkAdapter>)networkAdapter interfaceAdapter:(nullable id<PInterfaceAdapter>)interfaceAdapter;

+(BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
+(BOOL) application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;

+(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
+(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

-(void) initialize: (BConfiguration *) config app:(UIApplication *)application options:(NSDictionary *)launchOptions  modules: (NSArray<PModule> *) modules networkAdapter:(id<PNetworkAdapter>)networkAdapter interfaceAdapter:(id<PInterfaceAdapter>)adapter;

// Integration helper methods

// Authenticate using a Firebase token
+(RXPromise *) authenticateWithToken: (NSString *) token;

// Update the username image and image url safely i.e. this method will wait until
// the user has been authenticated correctly by using the post auth hook
+(void) updateUserWithName: (NSString *) name image: (UIImage *) image url: (NSString *) url;

// Logout
+(RXPromise *) logout;

// This is used if we get a push notification while the user isn't authenticated. We add it to the
// queue then check the queue when we launch the main activity and trigger the push handling
-(BBackgroundPushNotificationQueue *) pushQueue;

// API Methods
+(nonnull id<PCoreHandler>) core;
+(nonnull id<PAuthenticationHandler>) auth;
+(nullable id<PUploadHandler>) upload;
+(nullable id<PVideoMessageHandler>) videoMessage;
+(nullable id<PAudioMessageHandler>) audioMessage;
+(nullable id<PImageMessageHandler>) imageMessage;
+(nullable id<PLocationMessageHandler>) locationMessage;
+(nullable id<PPushHandler>) push;
+(nonnull id<PContactHandler>) contact;
+(nullable id<PTypingIndicatorHandler>) typingIndicator;
+(nullable id<PModerationHandler>) moderation;
+(nonnull id<PSearchHandler>) search;
+(nullable id<PPublicThreadHandler>) publicThread;
+(nullable id<PBlockingHandler>) blocking;
+(nullable id<PLastOnlineHandler>) lastOnline;
+(nullable id<PNearbyUsersHandler>) nearbyUsers;
+(nullable id<PReadReceiptHandler>) readReceipt;
+(nullable id<PStickerMessageHandler>) stickerMessage;
+(id<PUser>) currentUser;
+(NSString *) currentUserID;
+(id) handler: (NSString *) name;
+(nonnull id<PHookHandler>) hook;
+(nonnull id<PUsersHandler>) users;

+(nonnull id<PInterfaceAdapter>) ui;
+(nonnull id<PStorageAdapter>) db;
+(nonnull id<PNetworkAdapter>) a;
+(nullable id<PFileMessageHandler>) fileMessage;
+(nullable id<PEncryptionHandler>) encryption;
+(nonnull id<PEventHandler>) event;
+(nonnull id<PThreadHandler>) thread;
+(nullable id<PInternetConnectivityHandler>) connectivity;
+(nullable id<CallHandler>) call;

+(nonnull BConfiguration *) config;

+(void) activateLicenseWithEmail: (NSString *) email;
+(void) activateLicenseWithPatreon: (NSString *) patreonId;
+(void) activateLicenseWithGithub: (NSString *) githubId;

@end
