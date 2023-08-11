//
//  AppDelegate.m
//  ChatSDK Demo
//
//  Created by Benjamin Smiley-andrews on 19/12/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import "AppDelegate.h"

#import <ChatSDK/UI.h>
#import <ChatSDKFirebase/FirebaseAdapter.h>
#import <ChatSDKFirebase/ChatSDKFirebase-Swift.h>
#import <ChatKit/ChatKit-Swift.h>
#import <ChatSDKFirebase/FirebaseUIModule.h>
#import <FirebaseEmailAuthUI/FirebaseEmailAuthUI.h>

#import <FirebaseModules/FirebaseModules-umbrella.h>
#import <MessageModules/MessageModules-umbrella.h>
#import <ContactBook/ContactBook-umbrella.h>
#import <Encryption/Encryption-umbrella.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Create a network adapter to communicate with Firebase
    // The network adapter handles network traffic

    BConfiguration * config = [BConfiguration configuration];
    config.rootPath = @"pre_1";
    config.allowUsersToCreatePublicChats = NO;
    config.showEmptyChats = NO;
    config.googleMapsApiKey = @"AIzaSyCwwtZrlY9Rl8paM0R6iDNBEit_iexQ1aE";
    config.clearDataWhenRootPathChanges = YES;
    config.loginUsernamePlaceholder = @"Email";
    config.logoImage = [UIImage imageNamed:@"AppIcon"];
    
    
    NSMutableArray<PModule> * modules = [NSMutableArray arrayWithArray: @[
        [FirebaseNetworkAdapterModule shared],
        [FirebaseUploadModule shared],
        [FirebasePushModule shared],
        [ChatKitModule shared],
        [FirebaseUIModule new],
        
        [BBlockingModule new],
        [BReadReceiptsModule new],
        [BTypingIndicatorModule new],
        [BLastOnlineModule new],

        [StickerMessageModule shared],
        [BVideoMessageModule new],
        [FileMessageModule new],
        [BAudioMessageModule new],
        [BContactBookModule new],
        
        [EncryptionModule new]
    ]];
    
    
    FirebaseUIModule * firebaseUI = [FirebaseUIModule new];
    [firebaseUI setProviders:@[
        [FUIEmailAuth new]
    ]];

    [modules addObject:firebaseUI];
    
    [BChatSDK initialize:config app:application options:launchOptions modules:modules];
    

    UIViewController * rootViewController = BChatSDK.ui.splashScreenNavigationController;
    
    // Set the root view controller
    [self.window setRootViewController:rootViewController];
    [self.window makeKeyAndVisible];
    
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
