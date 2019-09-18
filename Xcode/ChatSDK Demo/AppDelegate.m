//
//  AppDelegate.m
//  ChatSDK Demo
//
//  Created by Benjamin Smiley-andrews on 19/12/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import "AppDelegate.h"
#import <ChatSDK/UI.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Create a network adapter to communicate with Firebase
    // The network adapter handles network traffic

    BConfiguration * config = [BConfiguration configuration];
    config.rootPath = @"live_19_08";
    config.allowUsersToCreatePublicChats = NO;
    config.showEmptyChats = NO;
    config.googleMapsApiKey = @"AIzaSyCwwtZrlY9Rl8paM0R6iDNBEit_iexQ1aE";
    config.clearDataWhenRootPathChanges = YES;
    config.loginUsernamePlaceholder = @"Email";
    config.allowUsersToCreatePublicChats = YES;
    
    // For the demo version of the client exire rooms after 24 hours
    config.publicChatRoomLifetimeMinutes = 60 * 24;
    
    
    // Twitter Setup
    config.twitterApiKey = @"Kqprq5b6bVeEfcMAGoHzUmB3I";
    config.twitterSecret = @"hPd9HCt3PLnifQFrGHJWi6pSZ5jF7kcHKXuoqB8GJpSDAlVcLq";
    
    // Facebook Setup
    config.facebookAppId = @"648056098576150";
    
    // Google Setup
    config.googleClientKey = @"1088435112418-4cm46hg39okkf0skj2h5roj1q62anmec.apps.googleusercontent.com";
    
    [BChatSDK initialize:config app:application options:launchOptions];
    
    // TODO: Fix Firebase UI!!!!!!!
    UIViewController * rootViewController = BChatSDK.ui.splashScreenNavigationController;
   

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
