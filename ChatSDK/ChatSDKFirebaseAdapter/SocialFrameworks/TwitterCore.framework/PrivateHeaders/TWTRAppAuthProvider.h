//
//  TWTRAppAuthProvider.h
//
//  Created by Alden Keefe Sampson on 4/2/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//

#import "TWTRAuthenticationProvider.h"

@class TWTRAuthConfig;
@protocol TWTRAPIServiceConfig;

@interface TWTRAppAuthProvider : TWTRAuthenticationProvider

- (instancetype)init __unavailable;

- (instancetype)initWithAuthConfig:(TWTRAuthConfig *)authConfig apiServiceConfig:(id<TWTRAPIServiceConfig>)apiServiceConfig;

/**
 *  Authenticate with App Auth
 *
 *  @param completion (required) The completion that will be called upon success or error.
 *                               Will be called on an arbitrary queue.
 */
- (void)authenticateWithCompletion:(TWTRAuthenticationProviderCompletion)completion;

@end
