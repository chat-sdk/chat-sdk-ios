//
//  TWTRSessionRefreshStrategy.h
//  TwitterCore
//
//  Created by Kang Chen on 6/24/15.
//  Copyright (c) 2015 Twitter Inc. All rights reserved.
//

@class TWTRAuthConfig;
@protocol TWTRAPIServiceConfig;
@protocol TWTRBaseSession;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Completion block to call when done refreshing the session or it fails.
 *
 *  @param refreshedSession The refreshed session
 *  @param error            Non nil error if the refresh fails.
 */
typedef void (^TWTRSessionRefreshCompletion)(id _Nullable refreshedSession, NSError *_Nullable error);

/**
 *  Protocol for session refresh strategies.
 */
@protocol TWTRSessionRefreshStrategy <NSObject>

/**
 *  Determines whether the strategy supports the given session class.
 *
 *  @param sessionClass The class of session to check.
 *
 *  @return YES if this strategy can be used to refresh the given session class.
 */
+ (BOOL)canSupportSessionClass:(Class)sessionClass;

/**
 *  Determines whether the session has expired based on the API response of a previous API request made with the session.
 *
 *  @param response HTTP response of a previous API request
 *
 *  @return YES if the HTTP response is contains information to indicate the session is invalid or has expired.
 */
+ (BOOL)isSessionExpiredBasedOnRequestResponse:(NSHTTPURLResponse *)response;

/**
 *  Determines whether the session has expired based on the API response error of a previous API request made with the session.
 *
 *  @param response error a previous API request
 *
 *  @return YES if the error contains information to indicate the session is invalid or has expired.
 */
+ (BOOL)isSessionExpiredBasedOnRequestError:(NSError *)responseError;

/**
 *  Request to fetch a new session.
 *
 *  @param session    Expired session to request new one for
 *  @param URLSession URL session to make the authentication request with
 *  @param completion Completion block to call when done refreshing the session or it fails.
 */
- (void)refreshSession:(id<TWTRBaseSession>)session URLSession:(NSURLSession *)URLSession completion:(TWTRSessionRefreshCompletion)completion;

@end

/**
 Concrete implementation of a strategy for handling expiration and refresh of guest sessions.
 */
@interface TWTRGuestSessionRefreshStrategy : NSObject <TWTRSessionRefreshStrategy>

/**
 *  Initializes a new guest refresh strategy.
 *
 *  @param authConfig       The `authConfig` associated with the app to refresh guest sessions for
 *  @param APIServiceConfig The API service config to configure endpoints
 *
 *  @return Initialized strategy that can refresh guest sessions of the given application
 */
- (instancetype)initWithAuthConfig:(TWTRAuthConfig *)authConfig APIServiceConfig:(id<TWTRAPIServiceConfig>)APIServiceConfig;
- (instancetype)init __unavailable;

@end

NS_ASSUME_NONNULL_END
