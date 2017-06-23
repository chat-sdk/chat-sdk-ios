//
//  TWTRScribeService.h
//
//  Created by Mustafa Furniturewala on 7/21/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//

@class TFSScribe;
@class TWTRScribeEvent;
@class TWTRAPIClient;
@class TWTRAuthConfig;
@class TWTRGuestSession;
@class TWTRNetworkingPipeline;
@class TWTRSessionStore;
@class TwitterNetworking;
@protocol TWTRAuthSession;
@protocol TWTRAPIServiceConfig;

NS_ASSUME_NONNULL_BEGIN

@interface TWTRScribeService : NSObject

- (instancetype)initWithScribe:(TFSScribe *)scribe scribeAPIServiceConfig:(id<TWTRAPIServiceConfig>)APIserviceConfig;

- (instancetype)init __unavailable;

/**
 This method must be called before the scribe attempts to enqueue any network requests.
 */
- (void)setSessionStore:(TWTRSessionStore *)sessionStore networkingPipeline:(TWTRNetworkingPipeline *)pipeline;

- (void)enqueueEvent:(nullable TWTRScribeEvent *)event;
- (void)enqueueEvents:(nullable NSArray *)events;

@end

NS_ASSUME_NONNULL_END
