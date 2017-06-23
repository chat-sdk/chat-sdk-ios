//
//  TWTRGuestAuthRequestSigner.h
//  TwitterCore
//
//  Created by Kang Chen on 6/25/15.
//  Copyright (c) 2015 Twitter Inc. All rights reserved.
//

@class TWTRAuthConfig;
@class TWTRGuestSession;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Signer abstracting logic to sign a guest authenticated network request.
 */
@interface TWTRGuestAuthRequestSigner : NSObject

/**
 *  Signs the given request with the appropriate guest authentication headers.
 *
 *  @param URLRequest The URL request to sign
 *  @param session    The guest session containing guest tokens required to sign the request
 *
 *  @return The signed URL request
 */
+ (NSURLRequest *)signedURLRequest:(NSURLRequest *)URLRequest session:(TWTRGuestSession *)session;

@end

NS_ASSUME_NONNULL_END
