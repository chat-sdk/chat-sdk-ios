//
//  BFirebaseAuthenticationHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BFirebaseAuthenticationHandler.h"

#import <ChatSDKCore/ChatCore.h>
#import <ChatSDKFirebaseAdapter/ChatFirebaseAdapter.h>

@implementation BFirebaseAuthenticationHandler


// Note: this method gets called often
// Each time the main tab bar appears the app check that
// the user is authenticated
-(RXPromise *) authenticateWithCachedToken {
    
    RXPromise * promise = [RXPromise new];
    
    BOOL authenticated = [self userAuthenticated];
    
    if (!authenticated) {
        // Do we have a token?
        NSDictionary * loginInfo = [self loginInfo];
        
        NSString * token = loginInfo ? loginInfo[bTokenKey] : Nil;
        
        if (token && token.length) {
            
            FIRUser * user = [FIRAuth auth].currentUser;
            if (user) {
                return [self handleFAUser:user].thenOnMain(Nil, ^id(NSError * error) {
                    return Nil;
                });
            }
        }
    }
    
    if (authenticated) {
        //        [promise resolveWithResult:self.currentUserModel];
        [promise resolveWithResult:[self handleFAUser:[FIRAuth auth].currentUser]];
    }
    else {
        [promise rejectWithReason:Nil];
    }
    
    return promise;
}

-(BOOL) userAuthenticated {
    
    // Return if there is a current user authenticated
    return [FIRAuth auth].currentUser != Nil;
    //  return ref.authData != Nil && self.currentUserModel != Nil;
}


-(RXPromise *) logout {
    RXPromise * promise = [RXPromise new];
    
    NSError * error = Nil;
    if([[FIRAuth auth] signOut:&error]) {
        
        // When a user logs out set their user offline
        FIRDatabaseReference * userOnlineRef = [FIRDatabaseReference userOnlineRef:self.currentUserEntityID];
        [userOnlineRef setValue:@NO];
        
        // Stop observing the user
        [BStateManager userOff: self.currentUserEntityID];
        _userListenersAdded = NO;
        
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

-(RXPromise *) authenticateWithDictionary: (NSDictionary *) details {
    
    RXPromise * promise = [RXPromise new];
    
    // Create a completion block to handle the login result
    void(^handleResult)() = ^(FIRUser * firebaseUser, NSError * error) {
        if (!error) {
            [promise resolveWithResult:firebaseUser];
        }
        else {
            [promise rejectWithReason:error];
        }
    };
    
    promise.thenOnMain(^id(FIRUser * firebaseUser) {
        return [self handleFAUser: firebaseUser];
    }, Nil);
    
    // Depending on the login method we need to authenticate with Firebase
    switch ([details[bLoginTypeKey] intValue]) {
        case bAccountTypeFacebook: {
            if ([BNetworkManager sharedManager].a.socialLogin) {
                [[BNetworkManager sharedManager].a.socialLogin loginWithFacebook].thenOnMain(^id(NSString * token) {
                    FIRAuthCredential * credential = [FIRFacebookAuthProvider credentialWithAccessToken:token];
                    //[promise resolveWithResult:credential];
                    [[FIRAuth auth] signInWithCredential:credential completion:handleResult];

                    return Nil;
                }, ^id (NSError * error) {
                    handleResult(error, Nil);
                    return Nil;
                });
            }
        }
            break;
        case bAccountTypeTwitter:
        {
         
            if ([BNetworkManager sharedManager].a.socialLogin) {
                [[BNetworkManager sharedManager].a.socialLogin loginWithTwitter].thenOnMain(^id(NSArray * array) {
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
            if ([BNetworkManager sharedManager].a.socialLogin) {
                [[BNetworkManager sharedManager].a.socialLogin loginWithGoogle].thenOnMain(^id(NSArray * array) {
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
        case bAccountTypePassword:
        {
            [[FIRAuth auth] signInWithEmail:details[bLoginEmailKey] password:details[bLoginPasswordKey] completion:handleResult];
        }
            break;
        case bAccountTypeCustom:
            
            [[FIRAuth auth] signInWithCustomToken:details[bLoginCustomToken] completion:handleResult];
            break;
        case bAccountTypeRegister:
        {
            RXPromise * p2 = [RXPromise new];
            
            [[FIRAuth auth] createUserWithEmail:details[bLoginEmailKey] password:details[bLoginPasswordKey] completion:handleResult];
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

-(RXPromise *) handleFAUser: (FIRUser *) firebaseUser {
    
    RXPromise * promise = [RXPromise new];
    
    // If the user isn't authenticated they'll need to login
    if (!firebaseUser) {
        [promise rejectWithReason:Nil];
        return promise;
    }
    
    // Get the token
    RXPromise * tokenPromise = [RXPromise new];
    [firebaseUser getTokenWithCompletion:^(NSString * token, NSError * error) {
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
        
        if (!_userListenersAdded) {
            // Update the user from the remote server
            return [user once].thenOnMain(^id(id<PUserWrapper> user_) {
                
                [[BNetworkManager sharedManager].a.core save];
                
                _userListenersAdded = YES;
                
                // Add listeners here
                [BStateManager userOn: user.entityID];
                
                [[BNetworkManager sharedManager].a.core setUserOnline];
                
                return [user push];
                
            }, Nil);
        }
        else {
            [promise resolveWithResult:user.model];
            return promise;
        }
        
    }, Nil);
    
}


@end
