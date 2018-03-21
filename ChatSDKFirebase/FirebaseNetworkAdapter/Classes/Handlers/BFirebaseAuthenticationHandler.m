//
//  BFirebaseAuthenticationHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BFirebaseAuthenticationHandler.h"

#import <ChatSDK/ChatCore.h>
#import "ChatFirebaseAdapter.h"

@implementation BFirebaseAuthenticationHandler


// Note: this method gets called often
// Each time the main tab bar appears the app check that
// the user is authenticated
-(RXPromise *) authenticateWithCachedToken {
    
    BOOL authenticated = [self userAuthenticated];
    if (authenticated) {
        // If the user listeners have been added then authenticate completed successfully
        if(_userAuthenticatedThisSession) {
            return [RXPromise resolveWithResult:NM.currentUser];
        }
        else {
            return [self loginWithFirebaseUser:[FIRAuth auth].currentUser];
        }
    }
    else {
        return [RXPromise rejectWithReason:Nil];
    }
}

-(BOOL) userAuthenticated {
    // Return if there is a current user authenticated
    return [FIRAuth auth].currentUser != Nil;
    //  return ref.authData != Nil && self.currentUserModel != Nil;
}

-(void) registerFirebaseUserForChat {
    FIRUser * firebaseUser = [FIRAuth auth].currentUser;
    
    NSString * uid = firebaseUser.uid;
    
    
    // Save the authentication ID for the current user
    // Set the current user
    [self setLoginInfo:@{bAuthenticationIDKey: uid}];
    
    CCUserWrapper * user = [CCUserWrapper userWithAuthUserData:firebaseUser];
    
    [NM.hook executeHookWithName:bHookUserAuthFinished data:@{bHookUserAuthFinished_PUser: user.model}];
    
    [NM.core save];
    
    // Add listeners here
    [BStateManager userOn: user.entityID];
    
    [NM.core setUserOnline];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationAuthenticationComplete object:Nil];
    
    [user push];
    
}


-(RXPromise *) logout {
    RXPromise * promise = [RXPromise new];
    
    // Stop observing the user
    if(self.currentUserEntityID) {
        [BStateManager userOff: self.currentUserEntityID];
    }
    
    NSError * error = Nil;
    if([[FIRAuth auth] signOut:&error]) {
        
        [NM.core goOffline];

        _userAuthenticatedThisSession = NO;
        
        // Post a notification
        [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationLogout object:Nil];
        
        [self setLoginInfo:Nil];
        
        [[NSNotificationCenter  defaultCenter] postNotificationName:bNotificationBadgeUpdated object:Nil];
                
        [promise resolveWithResult:Nil];
    }
    else {
        [promise rejectWithReason:error];
    }
    return promise;
}

-(RXPromise *) authenticate: (BAccountDetails *) details {
    
    RXPromise * promise = [RXPromise new];
    
    // Create a completion block to handle the login result
    void(^handleResult)(FIRUser * firebaseUser, NSError * error) = ^(FIRUser * firebaseUser, NSError * error) {
        if (!error) {
            [promise resolveWithResult:firebaseUser];
        }
        else {
            [promise rejectWithReason:error];
        }
    };
    
    promise = promise.thenOnMain(^id(FIRUser * firebaseUser) {
        return [self loginWithFirebaseUser: firebaseUser];
    }, Nil);
    
    // Depending on the login method we need to authenticate with Firebase
    switch (details.type) {
        case bAccountTypeFacebook: {
            if (NM.socialLogin) {
                [NM.socialLogin loginWithFacebook].thenOnMain(^id(NSString * token) {
                    FIRAuthCredential * credential = [FIRFacebookAuthProvider credentialWithAccessToken:token];
                    //[promise resolveWithResult:credential];
                    [[FIRAuth auth] signInWithCredential:credential completion:handleResult];

                    return Nil;
                }, ^id (NSError * error) {
                    handleResult(Nil, error);
                    return Nil;
                });
            }
        }
            break;
        case bAccountTypeTwitter:
        {
            if (NM.socialLogin) {
                [NM.socialLogin loginWithTwitter].thenOnMain(^id(NSArray * array) {
                    FIRAuthCredential * credential = [FIRTwitterAuthProvider credentialWithToken:array.firstObject
                                                                                          secret:array.lastObject];
                    [[FIRAuth auth] signInWithCredential:credential completion:handleResult];
                    return Nil;
                    
                }, ^id (NSError * error) {
                    handleResult(error, Nil);
                    return Nil;
                });
            }
            
        }
            break;
        // TODO: Test this
        case bAccountTypeGoogle:
        {
            if (NM.socialLogin) {
                [NM.socialLogin loginWithGoogle].thenOnMain(^id(NSArray * array) {
                    FIRAuthCredential * credential = [FIRGoogleAuthProvider credentialWithIDToken:array.firstObject
                                                                                      accessToken:array.lastObject];
                    [[FIRAuth auth] signInWithCredential:credential completion:handleResult];
                    return Nil;
                    
                }, ^id (NSError * error) {
                    handleResult(error, Nil);
                    return Nil;
                });
            }
        }
            break;
        case bAccountTypeUsername:
        {
            [[FIRAuth auth] signInWithEmail:details.username password:details.password completion:handleResult];
        }
            break;
        case bAccountTypeCustom:
            [[FIRAuth auth] signInWithCustomToken:details.token completion:handleResult];
            break;
        case bAccountTypeRegister:
        {
            [[FIRAuth auth] createUserWithEmail:details.username password:details.password completion:handleResult];
        }
            break;
        case bAccountTypeAnonymous: {
            [[FIRAuth auth] signInAnonymouslyWithCompletion:handleResult];
        }
            break;
        default:
            break;
    }
    
    return promise;
}

-(RXPromise *) loginWithFirebaseUser: (FIRUser *) firebaseUser {
    
    // If the user isn't authenticated they'll need to login
    if (!firebaseUser) {
        return [RXPromise resolveWithResult:Nil];
    }
    
    // Get the token
    RXPromise * tokenPromise = [RXPromise new];
    [firebaseUser getIDTokenWithCompletion:^(NSString * token, NSError * error) {
        if (!error) {
            [tokenPromise resolveWithResult:token];
        }
        else {
            [tokenPromise rejectWithReason:error];
        }
    }];
    
    return tokenPromise.thenOnMain(^id(NSString * token) {
        NSString * uid = firebaseUser.uid;
        
        // Save the authentication ID for the current user
        // Set the current user
        [self setLoginInfo:@{bAuthenticationIDKey: uid,
                             bTokenKey: token ? token : @""}];
        
        CCUserWrapper * user = [CCUserWrapper userWithAuthUserData:firebaseUser];
        
        if (!_userAuthenticatedThisSession) {
            _userAuthenticatedThisSession = YES;
            // Update the user from the remote server
            return [user once].thenOnMain(^id(id<PUserWrapper> user_) {
            
                [NM.hook executeHookWithName:bHookUserAuthFinished data:@{bHookUserAuthFinished_PUser: user.model}];
                
                [NM.core save];
                
                // Add listeners here
                [BStateManager userOn: user.entityID];
                
                [NM.core setUserOnline];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationAuthenticationComplete object:Nil];
                
                [user push];
                
                return user.model;
                
            }, Nil);
        }
        else {
            return user.model;
        }
        
    }, Nil);
    
}

-(RXPromise *) resetPasswordWithCredential: (NSString *) credential {
    RXPromise * promise = [RXPromise new];
    [[FIRAuth auth] sendPasswordResetWithEmail:credential completion:^(NSError *_Nullable error) {
        if(!error) {
            [promise resolveWithResult:Nil];
        }
        else {
            [promise rejectWithReason:error];
        }
    }];
    return promise;
}


@end
