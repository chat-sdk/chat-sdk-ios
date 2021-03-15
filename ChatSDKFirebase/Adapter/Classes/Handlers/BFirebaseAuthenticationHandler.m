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

        [BChatSDK.core goOffline];
        
        [super logout];
        
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

-(RXPromise *) retrieveRemoteConfig {
    RXPromise * promise = [RXPromise new];
    
    if (BChatSDK.config.remoteConfigEnabled) {
        [[FIRDatabaseReference configRef] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
            if (![snapshot.value isEqual: [NSNull null]]) {
                [BChatSDK.config setRemoteConfig:snapshot.value];
            }
            [promise resolveWithResult:Nil];
        }];
    } else {
        [promise resolveWithResult:Nil];
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
    if (!firebaseUser || !firebaseUser.uid) {
        return [RXPromise resolveWithResult:Nil];
    }
    
    // Save the authentication ID for the current user
    [self setCurrentUserID:firebaseUser.uid];
    
    // Get the user
    id<PUser> cachedUser = [BChatSDK.db fetchEntityWithID:firebaseUser.uid withType:bUserEntity];
    
    // What we do now depends on whether the user exists and whether we are in development mode
    // If we are in development mode, we will always pull to check to see if the remote data
    // has been cleared down. If we are in prod mode, if the local user exists we won't
    // perform this check

    if (cachedUser && (!BChatSDK.config.developmentModeEnabled || _isAuthenticatedThisSession)) {
        return [self completeAuthentication:details withUser:cachedUser];
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

        CCUserWrapper * user = [CCUserWrapper userWithAuthUserData:firebaseUser];
        if (details.name && !user.model.name) {
            [user.model setName:details.name];
        }
        
        // Update the user from the remote server
        return [user dataOnce: token].thenOnMain(^id(NSDictionary * data) {
            
            if (data) {
                [user deserialize:data];
            }
            if (!data[bMetaPath] && !BChatSDK.config.disableProfileUpdateOnAuthentication) {
                [user push];
            }

            return [self completeAuthentication:details withUser:user.model];
            
        }, Nil);
        
    }, Nil);
    
}

-(RXPromise *) completeAuthentication: (BAccountDetails *) details withUser: (id<PUser>) user {
    
    _isAuthenticatedThisSession = YES;
        
    // If the user was authenticated automatically
    if (!details) {
        [BHookNotification notificationDidAuthenticate:user type:bHook_AuthenticationTypeCached];
    }
    else if (details.type == bAccountTypeRegister) {
        [BHookNotification notificationDidAuthenticate:user type:bHook_AuthenticationTypeSignUp];
    }
    else {
        [BHookNotification notificationDidAuthenticate:user type:bHook_AuthenticationTypeLogin];
    }
    
    [BChatSDK.core save];
        
    // Add listeners here
    [BChatSDK.event currentUserOn:user.entityID];
        
    [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationAuthenticationComplete object:Nil];
    
    [BChatSDK.core setUserOnline];

    return [self retrieveRemoteConfig].thenOnMain(^id(id success) {
        return user;
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
