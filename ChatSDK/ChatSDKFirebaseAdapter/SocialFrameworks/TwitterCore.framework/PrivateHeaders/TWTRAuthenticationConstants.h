//
//  TWTRAuthenticationConstants.h
//  TWTRAuthentication
//
//  Created by Mustafa Furniturewala on 2/5/14.
//  Copyright (c) 2014 Mustafa Furniturewala. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark Twitter API
FOUNDATION_EXPORT NSString *const TWTRTwitterDomain;

#pragma mark - Authentication
FOUNDATION_EXPORT NSString *const TWTRAuthDirectoryLegacyName;
FOUNDATION_EXPORT NSString *const TWTRAuthDirectoryName;
FOUNDATION_EXPORT NSString *const TWTRSDKScheme;
FOUNDATION_EXPORT NSString *const TWTRSDKRedirectHost;

#pragma mark - Paths
FOUNDATION_EXPORT NSString *const TWTRTwitterRequestTokenPath;
FOUNDATION_EXPORT NSString *const TWTRTwitterAuthenticatePath;
FOUNDATION_EXPORT NSString *const TWTRTwitterAccessTokenPath;
FOUNDATION_EXPORT NSString *const TWTRAppAuthTokenPath;
FOUNDATION_EXPORT NSString *const TWTRGuestAuthTokenPath;

#pragma mark - OAuth strings
FOUNDATION_EXPORT NSString *const TWTRAuthOAuthTokenKey;
FOUNDATION_EXPORT NSString *const TWTRAuthOAuthSecretKey;
FOUNDATION_EXPORT NSString *const TWTRAuthAppOAuthTokenKey;
FOUNDATION_EXPORT NSString *const TWTRGuestAuthOAuthTokenKey;
FOUNDATION_EXPORT NSString *const TWTRAuthAppOAuthUserIDKey;
FOUNDATION_EXPORT NSString *const TWTRAuthAppOAuthScreenNameKey;
FOUNDATION_EXPORT NSString *const TWTRAuthAppOAuthVerifierKey;
FOUNDATION_EXPORT NSString *const TWTRAuthAppOAuthDeniedKey;
FOUNDATION_EXPORT NSString *const TWTRAuthAppOAuthAppKey;
FOUNDATION_EXPORT NSString *const TWTRAuthAppOAuthCallbackConfirmKey;
FOUNDATION_EXPORT NSString *const TWTRAuthAppOAuthCallbackKey;
FOUNDATION_EXPORT NSString *const TWTRAuthTokenTypeKey;
FOUNDATION_EXPORT NSString *const TWTRAuthTokenKey;
FOUNDATION_EXPORT NSString *const TWTRAuthSecretKey;
FOUNDATION_EXPORT NSString *const TWTRAuthUsernameKey;
FOUNDATION_EXPORT NSString *const TWTRAuthTokenSeparator;

#pragma mark - HTTP Headers
FOUNDATION_EXPORT NSString *const TWTRAuthorizationHeaderField;
FOUNDATION_EXPORT NSString *const TWTRGuestTokenHeaderField;

#pragma mark - Resources
FOUNDATION_EXPORT NSString *const TWTRLoginButtonImageLocation;

#pragma mark - Errors
FOUNDATION_EXPORT NSString *const TWTRMissingAccessTokenMsg;

typedef NS_ENUM(NSInteger, TWTRAuthType) {
    TWTRAuthTypeApp = 1,

    TWTRAuthTypeGuest = 2,

    TWTRAuthTypeUser = 3
};
