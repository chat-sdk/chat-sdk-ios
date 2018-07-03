//
//  BGoogleHelper.m
//  Pods
//
//  Created by Simon Smiley-Andrews on 29/03/2017.
//
//

#import "BGoogleHelper.h"

#import <ChatSDK/SocialLogin.h>

@implementation BGoogleHelper

// Call this to login with Google
- (RXPromise *)loginWithGoogle {
    
    if (!_promise) {
        _promise = [RXPromise new];
        
        BGoogleLoginViewController * vc = [[BGoogleLoginViewController alloc] init];
        vc.delegate = self;
        
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        UIViewController * rootViewController = window.rootViewController;
        
        // Dismiss the login view
        [rootViewController dismissViewControllerAnimated:NO completion:^{
            [rootViewController presentViewController:vc animated:YES completion:nil];
        }];
    }
    else {
        return [RXPromise rejectWithReasonDomain:@"" code:0 description:@"Google login already in progress"];
    }
    
    return _promise;
}

-(void) loginWasSuccessful {
    if (_promise) {
        [_promise resolveWithResult:Nil];
        _promise = Nil;
    }
}

-(void) loginFailedWithError: (NSError *) error {
    if (_promise) {
        [_promise rejectWithReason:error];
        _promise = Nil;
    }
}

@end
