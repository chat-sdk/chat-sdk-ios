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
    
    // Listen to see if the user logs out
    [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationLogout
                                                      object:Nil
                                                       queue:Nil
                                                  usingBlock:^(NSNotification * sender) {
                                                      
                                                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                          [self showLoginScreen];
                                                      });
                                                  }];
    
}

-(void) showLoginScreen {
    if (!NM.auth.userAuthenticated) {
        if (!_loginViewController) {
            _loginViewController = NM.auth.challengeViewController;
        }
        [_viewController presentViewController:_loginViewController
                                      animated:YES
                                    completion:Nil];
    }
    else {
        // Once we are authenticated then start updating the users location
        if(NM.nearbyUsers) {
            [NM.nearbyUsers startUpdatingUserLocation];
        }
    }
}

-(RXPromise *) viewDidAppear {
    return [NM.auth authenticateWithCachedToken].thenOnMain(^id(id<PUser> user) {
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
