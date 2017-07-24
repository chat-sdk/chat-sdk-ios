//
//  TWTRNetworkingPipelineQueue.h
//  TwitterKit
//
//  Created by Chase Latta on 6/23/15.
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TwitterCore/TWTRNetworkingPipeline.h>

@class TWTRNetworkingPipelinePackage;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TWTRNetworkingPipelineQueueType) {
    /**
     * Queues that depend on having a valid guest session
     */
    TWTRNetworkingPipelineQueueTypeGuest,

    /**
     * Queues that depend on having a valid user session
     */
    TWTRNetworkingPipelineQueueTypeUser
};

@interface TWTRNetworkingPipelineQueue : NSObject

/**
 * Returns the type that this queue was initialized with.
 */
@property (nonatomic, readonly) TWTRNetworkingPipelineQueueType queueType;

/**
 * A response validator to use to validate network responses.
 */
@property (nonatomic, readonly, nullable) id<TWTRNetworkingResponseValidating> responseValidator;

/**
 * Initializes the queue witht the given type.
 *
 * @param type The type of queue to initialize
 * @param session The NSURLSession to send requests with
 * @param responseValidator The response validator to use for this queue
 */
- (instancetype)initWithType:(TWTRNetworkingPipelineQueueType)type URLSession:(NSURLSession *)session responseValidator:(nullable id<TWTRNetworkingResponseValidating>)responseValidator NS_DESIGNATED_INITIALIZER;

/**
 * Convenience initializer to make a new guest pipeline.
 */
+ (instancetype)guestPipelineQueueWithURLSession:(NSURLSession *)session responseValidator:(nullable id<TWTRNetworkingResponseValidating>)responseValidator;

/**
 * Convenience initializer to make a new user pipeline.
 */
+ (instancetype)userPipelineQueueWithURLSession:(NSURLSession *)session responseValidator:(nullable id<TWTRNetworkingResponseValidating>)responseValidator;

/**
 * Enqueues a package for processing.
 * @return an NSProgress object which can be used to cancel the request.
 */
- (NSProgress *)enqueuePipelinePackage:(TWTRNetworkingPipelinePackage *)package;

/**
 * Use -[TWTRNetworkingPipelineQueue initWithType:URLSession:] instead.
 */
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
