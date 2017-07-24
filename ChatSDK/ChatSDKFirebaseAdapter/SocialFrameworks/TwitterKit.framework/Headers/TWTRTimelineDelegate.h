//
//  TWTRTimelineDelegate.h
//  TwitterKit
//
//  Created by Steven Hepting on 7/25/16.
//  Copyright © 2016 Twitter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TWTRTweet;
@class TWTRTimelineViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol TWTRTimelineDelegate <NSObject>

@optional

/**
 *  The Timeline started loading new Tweets. This would be an
 *  appropriate place to begin showing a loading indicator.
 *
 *  @param timeline Timeline controller providing the updates
 */
- (void)timelineDidBeginLoading:(TWTRTimelineViewController *)timeline;

/**
 *  The Timeline has finished loading more Tweets.
 *
 *  If Tweets array is `nil`, you should check the error object
 *  for a description of the failure case.
 *
 *  @param timeline Timeline displaying loaded Tweets
 *  @param tweets   Tweet objects loaded from the network
 *  @param error    Error object describing details of failure
 */
- (void)timeline:(TWTRTimelineViewController *)timeline didFinishLoadingTweets:(nullable NSArray *)tweets error:(nullable NSError *)error;

@end

NS_ASSUME_NONNULL_END
