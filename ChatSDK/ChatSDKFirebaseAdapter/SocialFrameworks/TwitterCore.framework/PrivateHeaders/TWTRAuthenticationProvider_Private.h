//
//  TWTRAuthenticationProvider_Private.h
//
//  Created by Mustafa Furniturewala on 5/28/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//

#ifndef Twitter_TWTRAuthenticationProvider_Private_h
#define Twitter_TWTRAuthenticationProvider_Private_h

#import "TWTRAuthenticationProvider.h"

@interface TWTRAuthenticationProvider ()

+ (void)validateResponseWithResponse:(NSURLResponse *)response data:(NSData *)data connectionError:(NSError *)connectionError completion:(TWTRAuthenticationProviderCompletion)completion;

@end

#endif
