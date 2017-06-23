//
//  TWTRUserAuthRequestSigner.h
//  TwitterKit
//
//  Created by Kang Chen on 7/1/15.
//  Copyright (c) 2015 Twitter. All rights reserved.
//

@class TWTRAuthConfig;
@protocol TWTRAuthSession;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Signer abstracting logic and type of user auth to sign a user authenticated network request.
 */
@interface TWTRUserAuthRequestSigner : NSObject

/**
 *  Signs the given request with the appropriate user authentication headers.
 *
 *  @param URLRequest URL request to sign
 *  @param authConfig The auth config containing the app's `consumerKey` and `consumerSecret`
 *  @param session    The authenticated user session
 *
 *  @return The signed URL request
 */
+ (NSURLRequest *)signedURLRequest:(NSURLRequest *)URLRequest authConfig:(TWTRAuthConfig *)authConfig session:(id<TWTRAuthSession>)session;

@end

NS_ASSUME_NONNULL_END
