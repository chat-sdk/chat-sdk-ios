//
//  TWTRAuthorizationProvider.h
//  TWTRAuthentication
//
//  Created by Mustafa Furniturewala on 2/5/14.
//  Copyright (c) 2014 Mustafa Furniturewala. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TWTRAuthenticationProviderCompletion)(NSDictionary *responseObject, NSError *error);

@interface TWTRAuthenticationProvider : NSObject

/**
 *  Authenticate with the Twitter API
 *
 *  @param completion (required) The completion block to be called upon succes or failure.
 *                               Will be called on an arbitrary queue.
 */
- (void)authenticateWithCompletion:(TWTRAuthenticationProviderCompletion)completion;

@end
