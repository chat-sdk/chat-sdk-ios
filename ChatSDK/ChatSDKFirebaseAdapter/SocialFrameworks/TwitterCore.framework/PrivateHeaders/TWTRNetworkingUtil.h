//
//  TWTRNetworkingUtil.h
//  TWTRNetworking
//
//  Created by Mustafa Furniturewala on 4/7/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWTRNetworkingUtil : NSObject

+ (NSString *)queryStringFromParameters:(NSDictionary *)parameters;
+ (NSString *)percentEscapedQueryStringWithString:(NSString *)string encoding:(NSStringEncoding)encoding;
+ (NSDictionary *)parametersFromQueryString:(NSString *)queryString;
+ (NSString *)percentUnescapedQueryStringWithString:(NSString *)string encoding:(NSStringEncoding)encoding;

@end
