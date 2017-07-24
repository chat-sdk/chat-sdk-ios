//
//  TWTRAppleSocialAuthenticaticationProvider.h
//  TWTRAuthentication
//
//  Created by Mustafa Furniturewala on 2/7/14.
//  Copyright (c) 2014 Mustafa Furniturewala. All rights reserved.
//

#import "TWTRAuthenticationProvider.h"

@class TWTRAuthConfig;
@protocol TWTRErrorLogger;
@protocol TWTRAPIServiceConfig;

__TVOS_UNAVAILABLE @interface TWTRAppleSocialAuthenticaticationProvider : TWTRAuthenticationProvider

                                                                          -
                                                                          (instancetype)init __unavailable;

- (instancetype)initWithAuthConfig:(TWTRAuthConfig *)authConfig apiServiceConfig:(id<TWTRAPIServiceConfig>)apiServiceConfig errorLogger:(id<TWTRErrorLogger>)errorLogger;

@end
