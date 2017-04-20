//
//  BGoogleHelper.m
//  Pods
//
//  Created by Simon Smiley-Andrews on 29/03/2017.
//
//

#import "BGoogleHelper.h"

@implementation BGoogleHelper

// Call this to login with Google
- (RXPromise *)loginWithGoogle {
    
    RXPromise * promise = [RXPromise new];
    
    BGoogleLoginViewController * vc = [[BGoogleLoginViewController alloc] init];
    vc.googleLoginPromise = promise;
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIViewController * rootViewController = window.rootViewController;
    
    [rootViewController presentViewController:vc animated:YES completion:nil];
    
    return promise;
}

// The helper implements the delegate


// Inside our login method
// Create a new promise
// Create a new instance of the google login view controller

// Make a GoogleLoginViewDelegate - loginWas successfull - loginFailedWitherror
// Google helper implements the Googledelegate
// Google viewController.delete = self
// return promise
// In the helper we have a class property wihich is the promise

// Self.promise = rxpromise new
// GoogleLoginViewController.promise = promise

// Inside the login was successful - resolve promise
// Inside the login was failed - resolve promise

// Google will tell us
// Have to add the delegate property to the view controller which then should notify it's delegate - the google helper\\\

// We just want to call a login method through our helper
// The helper

@end
