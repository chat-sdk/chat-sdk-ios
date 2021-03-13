//
//  PAuthenticationHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#ifndef PAuthenticationHandler_h
#define PAuthenticationHandler_h

#import <RXPromise/RXPromise.h>
#import <ChatSDK/BAccountTypes.h>
#import <ChatSDK/BAccountDetails.h>

@protocol PUser;

@protocol PAuthenticationHandler <NSObject>

/**
 * @brief Check to see if the user is already authenticated
 */
-(RXPromise *) authenticate;

/**
 * @brief Authenticate with Firebase
 */
-(RXPromise *) authenticateWithDictionary: (NSDictionary *) details;
-(RXPromise *) authenticate: (BAccountDetails *) details;

-(BOOL) isAuthenticated;
-(BOOL) isAuthenticatedThisSession;
-(BOOL) cachedCredentialAvailable;
-(NSString *) cachedPassword;

/**
 * @brief Logout the user from the current account
 */
-(RXPromise *) logout;

/**
 * @brief Says which networks are available this can be setup in bFirebaseDefines
 * if you set the API key to @"" for Twitter Facebook or Google then it's automatically
 * disabled
 */
-(BOOL) accountTypeEnabled: (bAccountType) type;

/**
 * @brief Get the current user's authentication id
 */
-(NSString *) currentUserID;
-(void) setCurrentUserID: (NSString *) currentUserID;
-(void) clearCurrentUserID;
-(id<PUser>) currentUser;

-(RXPromise *) resetPasswordWithCredential: (NSString *) credential;

@optional

-(void) activate;

@end

#endif /* PAuthenticationHandler_h */
