//
//  TWTRTimelineCursor.h
//  TwitterKit
//
//  Created by Kang Chen on 2/12/15.
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This Model object is a generic type of `Cursor` to represent the range of Tweets
 which have already been loaded from the Twitter API. A dataset that supports
 "cursoring" splits of a set of results (or Tweets in our case) in pages. One 
 page is loaded at a time, and the cursor from the previous request is used to
 calculated which set of Tweets should be requested.
 
 
 ## Positions
 For User, Search, and List Timelines generally corresponds to a real Tweet ID.
 
           newer Tweets
         (not yet loaded)
 
     -- newest/highest Tweet --      maxPosition
 
           loaded Tweets
 
     -- oldest/lowest Tweet --      minPosition
                                    minPosition - 1
           older Tweets      
         (not yet loaded)
 
   More: https://dev.twitter.com/overview/api/cursoring
 
 */
@interface TWTRTimelineCursor : NSObject

/**
 *  The ID of the Tweet highest up in a batch of Tweets received from a Timeline.
 *  Often this corresponds to the newest Tweet in terms of time.
 *
 *  For User, Search, and List Timelines this corresponds to a real Tweet ID..
 */
@property (nonatomic, copy, readonly) NSString *maxPosition;

/**
 *  The ID of the Tweet lowest in a batch of Tweets received from a Timeline. This
 *  often corresponds to the oldest Tweet in terms of time.
 *
 */
@property (nonatomic, copy, readonly) NSString *minPosition;

- (instancetype)init __unavailable;

/**
 *  Initialize a new cursor.
 *
 *  @param maxPosition The highest (newest) Tweet ID received in this batch of Tweets.
 *  @param minPosition The lowest (oldest) Tweet ID received in this batch of Tweets.
 *
 *  @return The initialized cursor to be passed back from a request for a Timeline from
 *          the Twitter API.
 */
- (instancetype)initWithMaxPosition:(NSString *)maxPosition minPosition:(NSString *)minPosition;

@end
