//
//  BChatSDK.h
//  AFNetworking
//
//  Created by Ben on 11/7/17.
//

#import <Foundation/Foundation.h>

@class BConfiguration;
@class RXPromise;
@protocol PInterfaceFacade;

@interface BChatSDK : NSObject {
    BConfiguration * _configuration;
}

@property (nonatomic, readonly) BConfiguration * configuration;

+(BChatSDK *) shared;
+(BConfiguration *) config;

// Application lifecycle methods - should be called from App Delegate
+(void) initialize: (BConfiguration *) config app:(UIApplication *)application options:(NSDictionary *)launchOptions;
+(void) initialize: (BConfiguration *) config app:(UIApplication *)application options:(NSDictionary *)launchOptions interfaceAdapter: (id<PInterfaceFacade>) adapter;

+(BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
+(BOOL) application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;
+(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
+(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

// Integration helper methods

// Authenticate using a Firebase token
+(RXPromise *) authenticateWithToken: (NSString *) token;

// Update the username image and image url safely i.e. this method will wait until
// the user has been authenticated correctly by using the post auth hook
+(void) updateUserWithName: (NSString *) name image: (UIImage *) image url: (NSString *) url;

// Logout
+(RXPromise *) logout;

@end
