//
//  TWTRListTimelineDataSource.h
//  TwitterKit
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TwitterKit/TWTRTimelineDataSource.h>

@class TWTRAPIClient;
@class TWTRTimelineFilter;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Data source representing a list of Tweets. These Tweets are ordered chronologically with the most recent first.
 *
 *  @see https://dev.twitter.com/rest/reference/get/lists/statuses
 */
@interface TWTRListTimelineDataSource : NSObject <TWTRTimelineDataSource>

/**
 *  The ID of the list to show Tweets for. Either the `listID` or the `listSlug` and `listOwnerScreenName` are required.
 */
@property (nonatomic, copy, readonly) NSString *listID;

/**
 *  The slug of the list to show Tweets for. Either the `listID` or the `listSlug` and `listOwnerScreenName` are required.
 */
@property (nonatomic, copy, readonly) NSString *listSlug;

/**
 *  Screen name of the owner of the list as specified by the `listSlug`. Either the `listID` or the `listSlug` and `listOwnerScreenName` are required.
 */
@property (nonatomic, copy, readonly) NSString *listOwnerScreenName;

/**
 *  The number of Tweets to request in each query to the Twitter Timeline API when fetching the next batch of Tweets. Will request 30 Tweets by default. Setting this value to 0 will use the server default.
 */
@property (nonatomic, readonly) NSUInteger maxTweetsPerRequest;

/**
 *  Whether to request retweets in the set of Tweets from the server.
 *
 *  Defaults to YES.
 */
@property (nonatomic, readonly) BOOL includeRetweets;

/*
 *  A filtering object that hides certain tweets.
 */
@property (nonatomic, copy, nullable) TWTRTimelineFilter *timelineFilter;

/**
 *  Convenience initializer. Uses default values for `maxTweetsPerRequest` and `includeRetweets`.
 *
 *  @param listID (required) The ID of the list.
 *  @param client (required) The API client to use for making network requests.
 *
 *  @return A full initialized list timeline datasource.
 */
- (instancetype)initWithListID:(NSString *)listID APIClient:(TWTRAPIClient *)client;

/**
 *  Convenience initializer. Uses default values for `maxTweetsPerRequest` and `includeRetweets`.
 *
 *  @param listSlug            (required) The slug of the list.
 *  @param listOwnerScreenName (required) The list owner's screen name.
 *  @param client              (required) The API client to use for making network requests.
 *
 *  @return A full initialized list timeline datasource.
 */
- (instancetype)initWithListSlug:(NSString *)listSlug listOwnerScreenName:(NSString *)listOwnerScreenName APIClient:(TWTRAPIClient *)client;

/**
 *  Designated initializer for creating list timeline data sources taking all parameters.
 *
 *  @param listID              (optional) The ID of the list. Provide either the `listID` or `listSlug` and `listOwnerScreenName`.
 *  @param listSlug            (optional) The slug of the list. Provide either the `listID` or `listSlug` and `listOwnerScreenName`.
 *  @param listOwnerScreenName (optional) The list owner's screen name. Provide either the `listID` or `listSlug` and `listOwnerScreenName`.
 *  @param client              (required) The API client to use for making networking requests
 *  @param maxTweetsPerRequest (optional) The number of Tweets per batch to request. A value of 0 will use the server default.
 *  @param includeRetweets     (optional) Whether retweets should be requested.
 *
 *  @return A fully initialized list timeline datasource.
 */
- (instancetype)initWithListID:(nullable NSString *)listID listSlug:(nullable NSString *)listSlug listOwnerScreenName:(nullable NSString *)listOwnerScreenName APIClient:(TWTRAPIClient *)client maxTweetsPerRequest:(NSUInteger)maxTweetsPerRequest includeRetweets:(BOOL)includeRetweets NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
