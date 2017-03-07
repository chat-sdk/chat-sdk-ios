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

@implementation BGoogleLoginHelper

-(id) init {
    if((self = [super init])) {
        [GIDSignIn sharedInstance].delegate = self;
        [GIDSignIn sharedInstance].uiDelegate = self;
        [GIDSignIn sharedInstance].clientID = [BSettingsManager googleClientKey]; //@"530766463312-set738214thf1ma67mckei7u5hp2nr2m.apps.googleusercontent.com";
        
        [[GIDSignIn sharedInstance] setScopes:@[@"https://www.googleapis.com/auth/plus.login", @"https://www.googleapis.com/auth/plus.me"]];

    }
    return self;
}

-(RXPromise *) login {
    if(!_promise) {
        _promise = [RXPromise new];
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

@end
