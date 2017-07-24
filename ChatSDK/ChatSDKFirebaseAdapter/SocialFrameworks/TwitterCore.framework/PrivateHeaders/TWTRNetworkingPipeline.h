//
//  TWTRNetworkingPipeline.h
//  TwitterKit
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <TwitterCore/TWTRSessionStore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TWTRNetworkingResponseValidating;

typedef void (^TWTRNetworkingPipelineCallback)(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error);

@interface TWTRNetworkingPipeline : NSObject

/**
 *if set, this object will be used to validate network responses.
 */
@property (nonatomic, readonly, nullable) id<TWTRNetworkingResponseValidating> responseValidator;

/**
 * Use the initWithURLSession: method instead.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * Returns an instance of the networking pipeline
 *
 * @param URLSession URLSession object to invoke network requests on.
 * @param responseValidator an optional response validator to use to validate responses.
 */
- (instancetype)initWithURLSession:(NSURLSession *)URLSession responseValidator:(nullable id<TWTRNetworkingResponseValidating>)responseValidator NS_DESIGNATED_INITIALIZER;

/**
 * Enqueues a request in the pipeline.
 *
 * @param request The HTTP Request to send
 * @param sessionStore The session store that will provide the session.
 * @param userID The userId to sign the request for or nil if using the guest session
 * @param completion The completion block to invoke on completion.
 */
- (NSProgress *)enqueueRequest:(NSURLRequest *)request sessionStore:(id<TWTRSessionStore>)sessionStore;
- (NSProgress *)enqueueRequest:(NSURLRequest *)request sessionStore:(id<TWTRSessionStore>)sessionStore requestingUser:(nullable NSString *)userID;

/**
 *  Enqueues a request in the pipeline.
 *
 *  @param request      The HTTP request to send.
 *  @param sessionStore The session store that will provide the session.
 *  @param userID       The user to sign the request for or nil if using the guest session.
 *  @param completion   The completion block to invoke on completion.
 */
- (NSProgress *)enqueueRequest:(NSURLRequest *)request sessionStore:(id<TWTRSessionStore>)sessionStore requestingUser:(nullable NSString *)userID completion:(nullable TWTRNetworkingPipelineCallback)completion;

@end

@protocol TWTRNetworkingResponseValidating <NSObject>

@required
/**
 * This method should return an NO if the response represents an error state.
 */
- (BOOL)validateResponse:(nullable NSURLResponse *)response data:(nullable NSData *)data error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
