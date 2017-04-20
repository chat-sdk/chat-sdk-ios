//
//  BGoogleLoginHelper.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 21/12/2016.
//
//

#import "BGoogleLoginHelper.h"

#import <ChatSDKCore/ChatCore.h>
#import <ChatSDKFirebaseAdapter/ChatFirebaseAdapter.h>

#import <ChatSDKUI/ChatUI.h>

@implementation BGoogleLoginHelper

@synthesize googlePromise;

-(id) init {
    
    if((self = [super init])) {
    }
    return self;
}

- (RXPromise *)loginWithGoogle {
    
    RXPromise * promise = [RXPromise new];
    
    BGoogleLoginViewController * vc = [[BGoogleLoginViewController alloc] init];
    vc.googleLoginPromise = promise;
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIViewController * rootViewController = window.rootViewController;
    
    UIViewController * loginView;
    
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        loginView = [(UINavigationController *)rootViewController topViewController];
    }
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        loginView = [(UITabBarController *)rootViewController selectedViewController];
    }
    if ([rootViewController presentedViewController]) {
        loginView = [rootViewController presentedViewController];
    }
    
//    If [viewController isKindOfClass:[UINavigationController class]], then proceed to [(UINavigationController *)viewController topViewController].
//    If [viewController isKindOfClass:[UITabBarController class]], then proceed to [(UITabBarController *)viewController selectedViewController].
//    If [viewController presentedViewController], then proceed to [viewController presentedViewController].
    
    //UIViewController * rootViewController = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    
    //window.rootViewController.navigationController.visibleViewController;
    
    //UIViewController * rootViewController = window.rootViewController;
    
    //UIViewController * vc = self.view.window.rootViewController;
    //[vc presentViewController: activityController animated: YES completion:nil];
    
    [loginView presentViewController:vc animated:YES completion:nil];
    
    return promise;
}

// If implemented, this method will be invoked when sign in needs to display a view controller.
// The view controller should be displayed modally (via UIViewController's |presentViewController|
// method, and not pushed unto a navigation controller's stack.
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
    
}

// If implemented, this method will be invoked when sign in needs to dismiss a view controller.
// Typically, this should be implemented by calling |dismissViewController| on the passed
// view controller.
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    
}

@end
