//
//  BGoogleLoginHelper.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 21/12/2016.
//
//

#import "BGoogleLoginHelper.h"

#import <ChatSDK/ChatCore.h>
#import <ChatSDK/ChatFirebaseAdapter.h>

@implementation BGoogleLoginHelper

-(id) init {
    if((self = [super init])) {
        [GIDSignIn sharedInstance].delegate = self;
        [GIDSignIn sharedInstance].uiDelegate = self;
        
        //[GIDSignIn sharedInstance].uiDelegate = [BNetworkManager sharedManager].a.auth.challengeViewController;
        
        [GIDSignIn sharedInstance].clientID = [BSettingsManager googleClientKey]; //@"530766463312-set738214thf1ma67mckei7u5hp2nr2m.apps.googleusercontent.com";
        
        [[GIDSignIn sharedInstance] setScopes:@[@"https://www.googleapis.com/auth/plus.login", @"https://www.googleapis.com/auth/plus.me"]];

    }
    return self;
}

-(RXPromise *) login {
    if(!_promise) {
        _promise = [RXPromise new];
        
        //[GIDSignIn sharedInstance].uiDelegate = [BNetworkManager sharedManager].a.auth.challengeViewController;
        
        
        
        [[GIDSignIn sharedInstance] signIn];
    }
    return _promise;
}

// Implement the required GIDSignInDelegate methods
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if(error) {
        [_promise rejectWithReason: error];
    }
    else {
        [_promise resolveWithResult: Nil];
    }
    _promise = Nil;
}

- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
    
//    BFirebaseNetworkAdapter * adapter = [[BFirebaseNetworkAdapter alloc] init];
//    [adapter.auth.challengeViewController presentViewController:viewController animated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    
//    BFirebaseNetworkAdapter * adapter = [[BFirebaseNetworkAdapter alloc] init];
//    [adapter.auth.challengeViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
