//
//  TWTRGuestAuthProvider.h
//  TwitterKit
//
//  Created by Kang Chen on 1/27/15.
//  Copyright (c) 2015 Twitter. All rights reserved.
//

@class TWTRAuthConfig;
@protocol TWTRAPIServiceConfig;
#import "TWTRAuthenticationProvider.h"

/**
 Manages activation of new guest tokens.

 @see TWTRAuthenticator
 */
@interface TWTRGuestAuthProvider : TWTRAuthenticationProvider

- (instancetype)init __unavailable;
- (instancetype)initWithAuthConfig:(TWTRAuthConfig *)authConfig apiServiceConfig:(id<TWTRAPIServiceConfig>)apiServiceConfig accessToken:(NSString *)accessToken __attribute__((nonnull(1, 2)))NS_DESIGNATED_INITIALIZER;

@end
