//
//  AppDelegate.m
//  ChatSDK Demo
//
//  Created by Benjamin Smiley-andrews on 19/12/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import "AppDelegate.h"

#import <ChatSDK/ChatCore.h>
#import <ChatSDK/ChatUI.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Create a network adapter to communicate with Firebase
    // The network adapter handles network traffic
    
    BConfiguration * config = [BConfiguration configuration];
    config.rootPath = @"test";
    config.allowUsersToCreatePublicChats = YES;
    config.showEmptyChats = YES;
    config.googleMapsApiKey = @"AIzaSyCwwtZrlY9Rl8paM0R6iDNBEit_iexQ1aE";
    [BChatSDK initialize:config app:application options:launchOptions];
 
    UIViewController * rootViewController = [BInterfaceManager sharedManager].a.appTabBarViewController;
    
    // Set the root view controller
    [self.window setRootViewController:rootViewController];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [BChatSDK application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

-(BOOL) application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [BChatSDK application: app openURL: url options: options];
}

-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [BChatSDK application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [BChatSDK application:application didReceiveRemoteNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationWillEnterForeground:(UIApplication *)application {}
- (void)applicationWillTerminate:(UIApplication *)application {}


@end
