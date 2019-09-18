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

@protocol PInterfaceAdapter;
@protocol PUser;
@protocol PStorageAdapter;

@interface BChatSDK : NSObject {
    BConfiguration * _configuration;
    id<PInterfaceAdapter> _interfaceAdapter;
    id<PStorageAdapter> _storageAdapter;
    id<PNetworkAdapter> _networkAdapter;
    BBackgroundPushNotificationQueue * _pushQueue;
    BModuleHelper * _moduleHelper;
}

@property (nonatomic, readonly) BConfiguration * configuration;
@property (nonatomic, readwrite) id<PInterfaceAdapter> interfaceAdapter;
@property (nonatomic, readwrite) id<PStorageAdapter> storageAdapter;
@property (nonatomic, readwrite) id<PNetworkAdapter> networkAdapter;

+(BChatSDK *) shared;
+(BConfiguration *) config;

// Application lifecycle methods - should be called from App Delegate
+(void) initialize: (BConfiguration *) config app:(UIApplication *)application options:(NSDictionary *)launchOptions;
+(void) initialize: (BConfiguration *) config app:(UIApplication *)application options:(NSDictionary *)launchOptions interfaceAdapter: (id<PInterfaceAdapter>) adapter;

+(BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
+(BOOL) application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;
+(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
+(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;
-(void) initialize: (BConfiguration *) config app:(UIApplication *)application options:(NSDictionary *)launchOptions interfaceAdapter: (id<PInterfaceAdapter>) adapter;

// Integration helper methods

// Authenticate using a Firebase token
+(RXPromise *) authenticateWithToken: (NSString *) token;

// Update the username image and image url safely i.e. this method will wait until
// the user has been authenticated correctly by using the post auth hook
+(void) updateUserWithName: (NSString *) name image: (UIImage *) image url: (NSString *) url;

-(void) preventAutomaticActivationForModule: (NSString *) moduleName;
-(BOOL) activateModuleForName: (NSString *) name;

// Logout
+(RXPromise *) logout;

// This is used if we get a push notification while the user isn't authenticated. We add it to the
// queue then check the queue when we launch the main activity and trigger the push handling
-(BBackgroundPushNotificationQueue *) pushQueue;

// API Methods
+(id<PCoreHandler>) core;
+(id<PAuthenticationHandler>) auth;
+(id<PUploadHandler>) upload;
+(id<PVideoMessageHandler>) videoMessage;
+(id<PAudioMessageHandler>) audioMessage;
+(id<PImageMessageHandler>) imageMessage;
+(id<PLocationMessageHandler>) locationMessage;
+(id<PPushHandler>) push;
+(id<PContactHandler>) contact;
+(id<PTypingIndicatorHandler>) typingIndicator;
+(id<PModerationHandler>) moderation;
+(id<PSearchHandler>) search;
+(id<PPublicThreadHandler>) publicThread;
+(id<PBlockingHandler>) blocking;
+(id<PLastOnlineHandler>) lastOnline;
+(id<PNearbyUsersHandler>) nearbyUsers;
+(id<PReadReceiptHandler>) readReceipt;
+(id<PStickerMessageHandler>) stickerMessage;
+(id<PSocialLoginHandler>) socialLogin;
+(id<PUser>) currentUser;
+(NSString *) currentUserID;
+(id) handler: (NSString *) name;
+(id<PHookHandler>) hook;
+(id<PUsersHandler>) users;
//+(BOOL) isMe: (id<PUser>) user;
+(id<PInterfaceAdapter>) ui;
+(id<PStorageAdapter>) db;
+(id<PNetworkAdapter>) a;
+(id<PFileMessageHandler>) fileMessage;
+(id<PEncryptionHandler>) encryption;
+(id<PEventHandler>) event;
+(id<PInternetConnectivityHandler>) connectivity;

@end
