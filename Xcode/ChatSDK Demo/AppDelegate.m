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
#import <ChatSDK/ChatCoreData.h>
#import "ChatFirebaseAdapter.h"

#import "BFirebaseSocialLoginModule.h"
#import "BFirebasePushModule.h"
#import "BFirebaseFileStorageModule.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Create a network adapter to communicate with Firebase
    // The network adapter handles network traffic
    [BNetworkManager sharedManager].a = [[BFirebaseNetworkAdapter alloc] init];
    
    BConfiguration * config = [BConfiguration configuration];
    config.rootPath = @"test";
    [BChatSDK initialize:config];
    
    // Set the default interface manager
    [BInterfaceManager sharedManager].a = [[BDefaultInterfaceAdapter alloc] init];

    [BStorageManager sharedManager].a = [[BCoreDataManager alloc] init];

    /*
     * Module Setup - http://chatsdk.co/modules-2
     */
    
    //[[[BTypingIndicatorModule alloc] init] activate];
    //[[[BVideoMessageModule alloc] init] activate];
    //[[[BAudioMessageModule alloc] init] activate];
    //[[[BReadReceiptsModule alloc] init] activate];
    //[[[BContactBookModule alloc] init] activate];
    //[[[BNearbyUsersModule alloc] init] activate];
    //[[[BStickerMessageModule alloc] init] activate];
    //[[[BKeyboardOverlayOptionsModule alloc] init] activate];
    
    /* Social Login */
    [[[BFirebaseSocialLoginModule alloc] init] activateWithApplication:application withOptions:launchOptions];
    
    [[[BFirebasePushModule alloc] init] activateForFirebaseWithApplication:application withOptions:launchOptions];
    
    [[[BFirebaseFileStorageModule alloc] init] activateForFirebase];


    // This is the main view that contains the tab bar
    UIViewController * mainViewController = [[BAppTabBarController alloc] initWithNibName:Nil bundle:Nil];

    // Set the login screen
    [BNetworkManager sharedManager].a.auth.challengeViewController = [[BLoginViewController alloc] initWithNibName:Nil bundle:Nil];
    

    // Set the root view controller
    [self.window setRootViewController:mainViewController];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if ([BNetworkManager sharedManager].a.socialLogin) {
        [[BNetworkManager sharedManager].a.socialLogin applicationDidBecomeActive:application];
    }
}

// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([BNetworkManager sharedManager].a.socialLogin) {
        return [[BNetworkManager sharedManager].a.socialLogin application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    return NO;
}

-(BOOL) application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([BNetworkManager sharedManager].a.socialLogin) {
        return [[BNetworkManager sharedManager].a.socialLogin application: app openURL: url options: options];
    }
    return NO;
}

-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[BNetworkManager sharedManager].a.push application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[BNetworkManager sharedManager].a.push application:application didReceiveRemoteNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationWillEnterForeground:(UIApplication *)application {}
- (void)applicationWillTerminate:(UIApplication *)application {}


@end
