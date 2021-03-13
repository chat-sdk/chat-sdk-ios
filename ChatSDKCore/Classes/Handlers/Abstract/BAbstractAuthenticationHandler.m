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
    return _isAuthenticatedThisSession && self.isAuthenticated;
}

-(id<PUser>) currentUser {
    NSString * currentUserID = _currentUserID;
    if (currentUserID && (!_currentUser || !_currentUser.entityID)) {
        _currentUser = [BChatSDK.db fetchEntityWithID:currentUserID withType:bUserEntity];
    }
    return _currentUser;
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

-(NSString *) currentUserID {
    if (!_currentUserID) {
        _currentUserID = [[NSUserDefaults standardUserDefaults] stringForKey: bAuthenticationIDKey];
    }
    return _currentUserID;
}

-(void) setCurrentUserID: (NSString *) currentUserID {
    [[NSUserDefaults standardUserDefaults] setObject:currentUserID forKey:bAuthenticationIDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) clearCurrentUserID {
    _currentUser = nil;
    _currentUserID = Nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:bAuthenticationIDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * @brief Authenticate with Firebase
 */
-(BOOL) isAuthenticated {
    assert(NO);
}

/**
 * @brief Logout the user from the current account
 */
-(RXPromise *) logout {
    _isAuthenticatedThisSession = false;
    [self clearCurrentUserID];
    return [RXPromise resolveWithResult:Nil];
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
