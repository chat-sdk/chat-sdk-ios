//
//  TWTRCoreOAuthSigning+Private.h
//  TwitterCore
//
//  Created by Javier Soto on 5/8/15.
//  Copyright (c) 2015 Twitter Inc. All rights reserved.
//

@class TWTRAuthConfig;
@protocol TWTRAuthSession;

FOUNDATION_EXTERN NSDictionary *TWTRCoreOAuthSigningOAuthEchoHeaders(TWTRAuthConfig *authConfig, id<TWTRAuthSession> authSession, NSString *requestMethod, NSString *URLString, NSDictionary *parameters, NSString *expectedAPIHost, NSError **error);
