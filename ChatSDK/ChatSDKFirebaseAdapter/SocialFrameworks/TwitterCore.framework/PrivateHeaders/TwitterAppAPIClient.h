//
//  TwitterAppAPIClient.h
//
//  Created by Alden Keefe Sampson on 5/7/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//

#import "TwitterNetworking.h"

@class TWTRAuthConfig;

/**
 An Twitter Social HTTP API client for use with an Application only access token.
 Application only auth allows for an app to access some Twitter content without a logged in user.
 To obtain an app only access token use TWTRAuthClient.
 For more about application only auth see https://dev.twitter.com/docs/auth/application-only-auth .

 If you have a logged in user, use TwitterUserAPIClient.
 */
@interface TwitterAppAPIClient : TwitterNetworking

// The application only access token
@property (nonatomic, readonly) NSString *accessToken;

/**
 Designated initializer. Returns nil if access token is missing.
 @param accessToken An application only access token.
 */
- (instancetype)initWithAuthConfig:(TWTRAuthConfig *)authConfig accessToken:(NSString *)accessToken;
- (instancetype)initWithAuthConfig:(TWTRAuthConfig *)authConfig __unavailable;

@end
