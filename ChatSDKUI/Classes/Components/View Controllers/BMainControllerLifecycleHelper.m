//
//  BMainControllerLifecycleHelper.m
//  AFNetworking
//
//  Created by Ben on 11/8/17.
//

#import "BMainControllerLifecycleHelper.h"
#import <ChatSDK/Core.h>

@implementation BMainControllerLifecycleHelper

@synthesize loginViewController = _loginViewController;
@synthesize mainViewController = _viewController;

-(void) viewDidLoad: (UIViewController *) controller {
    
    _viewController = controller;
    
    [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showLoginScreen];
        });
    }] withName:bHookDidLogout];
    
}

-(void) showLoginScreen {
    if (!BChatSDK.auth.userAuthenticated) {
        if (!_loginViewController) {
            _loginViewController = BChatSDK.auth.challengeViewController;
        }
        [_viewController presentViewController:_loginViewController
                                      animated:YES
                                    completion:Nil];
    }
}

-(RXPromise *) viewDidAppear {
    return [BChatSDK.auth authenticateWithCachedToken].thenOnMain(^id(id<PUser> user) {
        if (!user) {
            [self showLoginScreen];
        }
        return Nil;
    },^id(NSError * error) {
        [self showLoginScreen];
        return Nil;
    });

}

     


@end
