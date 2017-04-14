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

#import "BFirebaseSocialLoginHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Create a network adapter to communicate with Firebase
    // The network adapter handles network traffic
    [BNetworkManager sharedManager].a = [[BFirebaseNetworkAdapter alloc] init];
    
    // Set the default interface manager
    [BInterfaceManager sharedManager].a = [[BDefaultInterfaceAdapter alloc] init];
    
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
    //[[BNetworkManager sharedManager].a.socialLogin = [[BFirebaseSocialLoginHandler alloc] init];
    //[[BNetworkManager sharedManager].a.socialLogin application: application didFinishLaunchingWithOptions:launchOptions];

    /* Two Factor Authentication */
    //_verifyViewController = [[BVerifyViewController alloc] initWithNibName:nil bundle:nil];;
    //_verifyViewController.delegate = self;
    //[BNetworkManager sharedManager].a.auth.challengeViewController = _verifyViewController;

    // This is the main view that contains the tab bar
    UIViewController * mainViewController = [[BAppTabBarController alloc] initWithNibName:Nil bundle:Nil];

    // Set the login screen
    [BNetworkManager sharedManager].a.auth.challengeViewController = [[BLoginViewController alloc] initWithNibName:Nil bundle:Nil];
    
    // Set the data handler
    // The data handler is responsible for persisting data on the device
    [BStorageManager sharedManager].a = [[BCoreDataManager alloc] init];

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
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
