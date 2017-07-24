//
//  TWTRAPINetworkErrorsShim.h
//  TwitterKit
//
//  Created by Kang Chen on 1/15/15.
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWTRNetworkingPipeline.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Abstraction around the Twitter REST API networking response validation and errors to handle various
 quirks of the API.
 */
@interface TWTRAPINetworkErrorsShim : NSObject

/**
 *  @param response     response from the API request
 *  @param responseData data from the request response
 */
- (instancetype)initWithHTTPResponse:(NSURLResponse *)response responseData:(NSData *)responseData NS_DESIGNATED_INITIALIZER;

- (instancetype)init __unavailable;
/**
 *  Validates the error response while taking into account some Twitter-specific quirks.
 *
 *  @return the normalized error if there was something to surface from either the HTTP response
 *          or API response
 */

- (nullable NSError *)validate;

@end

/// This class just simply wraps the TWTRAPINetworkErrorsShim class so that we can use
/// something that conforms to the TWTRNetworkingResponseValidating. It simply creates
/// an instance of TWTRAPINetworkErrorsShim for each validation call. Eventually, the
/// TWTRAPINetworkErrorsShim class can be removed or hidden.
@interface TWTRAPIResponseValidator : NSObject <TWTRNetworkingResponseValidating>
@end

NS_ASSUME_NONNULL_END
