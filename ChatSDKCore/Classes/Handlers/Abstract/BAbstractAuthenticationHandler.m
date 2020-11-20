//
//  BAbstractAuthenticationHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BAbstractAuthenticationHandler.h"
#import <ChatSDK/Core.h>

@implementation BAbstractAuthenticationHandler

-(instancetype) init {
    if((self = [super init])) {
    }
    return self;
}

-(void) activate {
    __weak __typeof__(self) weakSelf = self;
    [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
        // Resets the view which the tab bar loads on
        __typeof__(self) strongSelf = weakSelf;
        strongSelf->_currentUserID = Nil;
    }] withName:bHookDidLogout];
}

-(BOOL) accountTypeEnabled: (bAccountType) accountType {
    NSString * key = @"";
    
    switch (accountType) {
        case bAccountTypeAnonymous:
            return BChatSDK.config.anonymousLoginEnabled;
        default:
            break;
    }
    return NO;
}

-(BOOL) isAuthenticatedThisSession {
    return _isAuthenticatedThisSession && self.userAuthenticated;
}

-(BOOL) userAuthenticatedThisSession __deprecated {
    return [self isAuthenticatedThisSession];
}

-(RXPromise *) authenticateWithDictionary:(NSDictionary *)details {
    BAccountDetails * accountDetails;
    switch ([details[bLoginTypeKey] intValue]) {
        case bAccountTypeUsername:
            accountDetails = [BAccountDetails username: details[bLoginEmailKey] password:details[bLoginPasswordKey]];
            break;
        case bAccountTypeCustom:
            accountDetails = [BAccountDetails token: details[bLoginCustomToken]];
            break;
        case bAccountTypeRegister:
            accountDetails = [BAccountDetails signUp: details[bLoginEmailKey] password:details[bLoginPasswordKey]];
            break;
        case bAccountTypeAnonymous:
            accountDetails = [BAccountDetails anonymous];
            break;
        default:
            break;
    }
    
    if(accountDetails) {
        return [self authenticate: accountDetails];
    }
    else {
        // TODO: Localize
        return [RXPromise rejectWithReason:[NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey: @"Login credentials invalid"}]];
    }
}

/**
 * @brief Get the current user's ID
 * @deprecated Use currentUserID
 */

-(NSString *) currentUserEntityID __deprecated {
    return self.currentUserID;
}

-(NSString *) currentUserID {
    if (!_currentUserID) {
        _currentUserID = [[NSUserDefaults standardUserDefaults] dictionaryForKey:bCurrentUserLoginInfo][bAuthenticationIDKey];
    }
    return _currentUserID;
}

-(void) saveAccountDetails: (BAccountDetails *) details {
    [self setLoginInfo:@{bLoginUsernameKey: details.username,
                         bLoginPasswordKey: details.password}];
}

-(BAccountDetails *) getSavedAccountDetails {
    return [BAccountDetails username:self.loginInfo[bLoginUsernameKey] password:self.loginInfo[bLoginPasswordKey]];
}

-(void) setLoginInfo: (NSDictionary *) info {
    [[NSUserDefaults standardUserDefaults] setObject:info forKey:bCurrentUserLoginInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSDictionary *) loginInfo {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:bCurrentUserLoginInfo];
}

/**
 * @brief Authenticate with Firebase
 */

/**
 * @brief Checks whether the user has been authenticated this session
 */
-(BOOL) userAuthenticated __deprecated {
    return [self isAuthenticated];
}

-(BOOL) isAuthenticated {
    assert(NO);
}

/**
 * @brief Logout the user from the current account
 */
-(RXPromise *) logout {
    assert(NO);
}

/**
 * @brief Check to see if the user is already authenticated
 * @deprecated Use authenticate
 */
-(RXPromise *) authenticateWithCachedToken __deprecated {
    return [self authenticate];
}

/**
 * @brief Check to see if the user is already authenticated
 */
-(RXPromise *) authenticate {
    assert(NO);
}

- (RXPromise *)authenticate:(BAccountDetails *)details {
    assert(NO);
}

- (RXPromise *)resetPasswordWithCredential:(NSString *)credential {
    assert(NO);
}

-(BOOL) cachedCredentialAvailable {
    return NO;
}

@end
