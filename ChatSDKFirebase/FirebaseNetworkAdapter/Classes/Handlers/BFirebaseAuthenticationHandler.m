//
//  BFirebaseAuthenticationHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BFirebaseAuthenticationHandler.h"

#import <ChatSDKFirebase/FirebaseAdapter.h>
#import <ChatSDK/Core.h>

@implementation BFirebaseAuthenticationHandler

// Note: this method gets called often
// Each time the main tab bar appears the app check that
// the user is authenticated
-(RXPromise *) authenticate {

    [BChatSDK.core goOnline];
    
    BOOL authenticated = [self isAuthenticated];
    if (authenticated) {
        
//        [[FIRAuth auth] signOut:Nil];
        
        // If the user listeners have been added then authenticate completed successfully
        if(_isAuthenticatedThisSession) {
            return [RXPromise resolveWithResult:BChatSDK.currentUser];
        }
        else {
            return [self loginWithFirebaseUser:[FIRAuth auth].currentUser];
        }
    }
    else {
        return [RXPromise rejectWithReason:Nil];
    }
}

-(BOOL) isAuthenticated {
    
    // Return if there is a current user authenticated
    return [FIRAuth auth].currentUser != Nil;
    //  return ref.authData != Nil && self.currentUserModel != Nil;
}


-(RXPromise *) logout {
    RXPromise * promise = [RXPromise new];
    
    id<PUser> user = BChatSDK.currentUser;
    
    // Stop observing the user
    if(user) {
        [BHookNotification notificationWillLogout:user];
        [BChatSDK.event currentUserOff: user.entityID];
    }
    
    NSError * error = Nil;
    if([[FIRAuth auth] signOut:&error]) {

        _isAuthenticatedThisSession = NO;
        [self setLoginInfo:Nil];
        [BChatSDK.core goOffline];
        
        [[NSNotificationCenter  defaultCenter] postNotificationName:bNotificationBadgeUpdated object:Nil];
        
        if (user) {
            [BHookNotification notificationDidLogout:user];
        }
        
        [promise resolveWithResult:Nil];
    }
    else {
        [promise rejectWithReason:error];
    }
    return promise;
}

-(RXPromise *) authenticate: (BAccountDetails *) details {
    
    [BChatSDK.core goOnline];
    
    RXPromise * promise = [RXPromise new];
    
    // Create a completion block to handle the login result
    void(^handleResult)(FIRAuthDataResult * result, NSError * error) = ^(FIRAuthDataResult * result, NSError * error) {
        if (!error) {
            [promise resolveWithResult:result.user];
        }
        else {
            [promise rejectWithReason:error];
        }
    };
    
    promise = promise.thenOnMain(^id(FIRUser * firebaseUser) {
        return [self loginWithFirebaseUser: firebaseUser accountDetails:details];
    }, Nil);
    
    // Depending on the login method we need to authenticate with Firebase
    switch (details.type)
    {
        case bAccountTypeFacebook: {
            if (BChatSDK.socialLogin) {
                [BChatSDK.socialLogin loginWithFacebook].thenOnMain(^id(NSString * token) {
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
            if (BChatSDK.socialLogin) {
                [BChatSDK.socialLogin loginWithTwitter].thenOnMain(^id(NSArray * array) {
                    FIRAuthCredential * credential = [FIRTwitterAuthProvider credentialWithToken:array.firstObject
                                                                                          secret:array.lastObject];
                    [[FIRAuth auth] signInWithCredential:credential completion:handleResult];
                    return Nil;
                    
                }, ^id (NSError * error) {
                    handleResult(Nil, error);
                    return Nil;
                });
            }
        }
            break;
        case bAccountTypeGoogle:
        {
            if (BChatSDK.socialLogin) {
                [BChatSDK.socialLogin loginWithGoogle].thenOnMain(^id(NSArray * array) {
                    FIRAuthCredential * credential = [FIRGoogleAuthProvider credentialWithIDToken:array.firstObject
                                                                                      accessToken:array.lastObject];
                    [[FIRAuth auth] signInWithCredential:credential completion:handleResult];
                    return Nil;
                    
                }, ^id (NSError * error) {
                    handleResult(Nil, error);
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
    return [self loginWithFirebaseUser:firebaseUser accountDetails:Nil];
}

-(RXPromise *) loginWithFirebaseUser: (FIRUser *) firebaseUser accountDetails: (BAccountDetails *) details {
    
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
    
    __weak __typeof__(self) weakSelf = self;
    return tokenPromise.thenOnMain(^id(NSString * token) {
        __typeof__(self) strongSelf = weakSelf;

        NSString * uid = firebaseUser.uid;
        
        // Save the authentication ID for the current user
        // Set the current user
        [strongSelf setLoginInfo:@{bAuthenticationIDKey: uid,
                             bTokenKey: [NSString safe: token]}];
        
        CCUserWrapper * user = [CCUserWrapper userWithAuthUserData:firebaseUser];
        if (details.name && !user.model.name) {
            [user.model setName:details.name];
        }
        
        if (!strongSelf->_isAuthenticatedThisSession) {
            strongSelf->_isAuthenticatedThisSession = YES;
            // Update the user from the remote server
            return [user once].thenOnMain(^id(id<PUserWrapper> user_) {

                // If the user was authenticated automatically
                if (!details) {
                    [BHookNotification notificationDidAuthenticate:user.model type:bHook_AuthenticationTypeCached];
                }
                else if (details.type == bAccountTypeRegister) {
                    [BHookNotification notificationDidAuthenticate:user.model type:bHook_AuthenticationTypeSignUp];
                }
                else {
                    [BHookNotification notificationDidAuthenticate:user.model type:bHook_AuthenticationTypeLogin];
                }
                
                [BChatSDK.core save];
                
//                NSLog(@"User On: %@", user.entityID);
                
                // Add listeners here
                [BChatSDK.event currentUserOn:user.entityID];
                
                [BChatSDK.core setUserOnline];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationAuthenticationComplete object:Nil];
                
                strongSelf->_authenticatedThisSession = true;
                
                [user push];
                
                return user.model;
                
            }, Nil);
        }
        else {
            [BHookNotification notificationDidAuthenticate:user.model type:bHook_AuthenticationTypeCached];
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
