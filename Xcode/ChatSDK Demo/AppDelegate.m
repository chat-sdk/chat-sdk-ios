//
//  AppDelegate.m
//  ChatSDK Demo
//
//  Created by Benjamin Smiley-andrews on 19/12/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import "AppDelegate.h"


#import <ChatSDKCore/ChatCore.h>
#import <ChatSDKUI/ChatUI.h>
#import <ChatSDKFirebaseAdapter/ChatFirebaseAdapter.h>
#import <ChatSDKCoreData/ChatCoreData.h>


//#import <ChatSDKFirebase/NearbyUsers.h>
//#import <ChatSDKFirebase/AudioMessages.h>
//#import <ChatSDKFirebase/NearbyUsers.h>
//#import <ChatSDKFirebase/ReadReceipts.h>
//#import <ChatSDKFirebase/TypingIndicator.h>
//#import <ChatSDKFirebase/VideoMessages.h>
//#import <ChatSDKFirebase/ContactBook.h>
//
//#import <ChatSDKModules/KeyboardOverlayOptions.h>
//#import <ChatSDKModules/StickerMessages.h>

//#import "BBackendlessPushHandler.h"
//#import "BBackendlessUploadHandler.h"

//#import "BFirebaseSocialLoginHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Create a network adapter to communicate with Firebase
    // The network adapter handles network traffic
    [BNetworkManager sharedManager].a = [[BFirebaseNetworkAdapter alloc] init];
    
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
    //[BNetworkManager sharedManager].a.socialLogin = [[BFirebaseSocialLoginHandler alloc] init];
    //[[BNetworkManager sharedManager].a.socialLogin application: application didFinishLaunchingWithOptions:launchOptions];

    /* Two Factor Authentication */
    //_verifyViewController = [[BVerifyViewController alloc] initWithNibName:nil bundle:nil];;
    //_verifyViewController.delegate = self;
    //[BNetworkManager sharedManager].a.auth.challengeViewController = _verifyViewController;

    // This is the main view that contains the tab bar
    UIViewController * mainViewController = [[BAppTabBarController alloc] initWithNibName:Nil bundle:Nil];

    // Set the login screen
    [BNetworkManager sharedManager].a.auth.challengeViewController = [[BLoginViewController alloc] initWithNibName:Nil bundle:Nil];
    
    /* Backendless Push handler */
    //BBackendlessPushHandler * pushHandler = [[BBackendlessPushHandler alloc] initWithAppKey:[BSettingsManager backendlessAppId] secretKey:[BSettingsManager backendlessSecretKey] versionKey:[BSettingsManager backendlessVersionKey]];
    //[[BNetworkManager sharedManager].a setPush:pushHandler];
    //[[BNetworkManager sharedManager].a.push registerForPushNotificationsWithApplication:application launchOptions:launchOptions];

    // Set the root view controller
    [self.window setRootViewController:mainViewController];
    
    return YES;
}

/* Two Factor Authentication Code */

//-(void) numberVerifiedWithToken:(NSString *)token {
//    [[BNetworkManager sharedManager].a.auth authenticateWithDictionary:@{bLoginTypeKey: @(bAccountTypeCustom),
//                                                                         bLoginCustomToken: token}].thenOnMain(^id(id<PUser> user) {
//        [self authenticationFinishedWithUser:user];
//        return Nil;
//    }, ^id(NSError * error) {
//        [BTwoFactorAuthUtils alertWithError: error.localizedDescription];
//        
//        // Still need to remove the HUD else we get stuck
//        
//        [self authenticationFinishedWithUser:nil];
//        return Nil;
//    });
//}
//
//-(void) authenticationFinishedWithUser: (id<PUser>) user {
//    if (user) {
//        [_verifyViewController dismissViewControllerAnimated:YES completion:^{
//            _verifyViewController.phoneNumber.text = @"";
//        }];
//    }
//    [_verifyViewController hideHUD];
//}

/* End Two Factor Authentication Code */

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
