//
//  TwitterUserAPIClient.h
//  TwitterUserAPIClient
//
//  Created by Mustafa Furniturewala on 4/7/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//

#import "TwitterNetworking.h"

@interface TwitterUserAPIClient : TwitterNetworking

- (instancetype)initWithAuthConfig:(TWTRAuthConfig *)authConfig __unavailable;
- (instancetype)initWithAuthConfig:(TWTRAuthConfig *)authConfig authToken:(NSString *)authToken authTokenSecret:(NSString *)authTokenSecret;

@end
