//
//  BAbstractAuthenticationHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BAbstractAuthenticationHandler.h"
#import <ChatSDK/ChatCore.h>

@implementation BAbstractAuthenticationHandler

-(BOOL) accountTypeEnabled: (bAccountType) accountType {
    NSString * key = @"";
    
    switch (accountType) {
        case bAccountTypeFacebook:
            key = [BSettingsManager facebookAppId];
            return key.length && NM.socialLogin && [BChatSDK shared].configuration.facebookLoginEnabled;
        case bAccountTypeTwitter:
            key = [BSettingsManager twitterApiKey];
            return key.length && NM.socialLogin && [BChatSDK shared].configuration.twitterLoginEnabled;
        case bAccountTypeGoogle:
            key = [BSettingsManager googleClientKey];
            return key.length && [BChatSDK shared].configuration.googleLoginEnabled && NM.socialLogin;
        case bAccountTypeAnonymous:
            return [BChatSDK shared].configuration.anonymousLoginEnabled;
        default:
            break;
    }
    return NO;
}

-(RXPromise *) authenticateWithDictionary:(NSDictionary *)details {
    BAccountDetails * accountDetails;
    switch ([details[bLoginTypeKey] intValue]) {
        case bAccountTypeFacebook:
            accountDetails = [BAccountDetails facebook];
            break;
        case bAccountTypeTwitter:
            accountDetails = [BAccountDetails twitter];
            break;
        case bAccountTypeGoogle:
            accountDetails = [BAccountDetails google];
            break;
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

-(NSString *) currentUserEntityID {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:bCurrentUserLoginInfo][bAuthenticationIDKey];
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
 * @brief Check to see if the user is already authenticated
 */
-(RXPromise *) authenticateWithCachedToken {
    assert(NO);
}

/**
 * @brief Authenticate with Firebase
 */

/**
 * @brief Checks whether the user has been authenticated this session
 */
-(BOOL) userAuthenticated {
    assert(NO);
}

-(void) registerFirebaseUserForChat {
    assert(NO);
}

/**
 * @brief Logout the user from the current account
 */
-(RXPromise *) logout {
    assert(NO);
}

- (RXPromise *)authenticate:(BAccountDetails *)details {
    assert(NO);
}

- (RXPromise *)resetPasswordWithCredential:(NSString *)credential {
    assert(NO);
}

@end
