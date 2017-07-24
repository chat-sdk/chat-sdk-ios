//
//  TWTRScribeFilterDetails.h
//  TwitterCore
//
//  Created by Jaihee Lee on 12/1/16.
//  Copyright © 2016 Twitter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWTRScribeSerializable.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TWTRScribeFilterDetailsType) {

    TWTRScribeFilterDetailsTypeDefault = 1,
    TWTRScribeFilterDetailsTypeCompact = 2
};

@interface TWTRScribeFilterDetails : NSObject <TWTRScribeSerializable>

@property (nonatomic) NSUInteger totalFilteredTweets;
@property (nonatomic) NSUInteger requestedTweets;
@property (nonatomic) NSUInteger totalFilters;
@property (nonatomic, assign, readonly) TWTRScribeFilterDetailsType scribeType;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFilters:(NSUInteger)totalFilters;
/**
 *  Initializes a new filter detail scribe item.
 *
 *  @param totalFilters         number of filters
 *  @param requestedTweets      number of tweets requested to filter
 *  @param totalFilteredTweets  number of tweets that got filtered
 *
 *  @return A new filter detail scribe item.
 */
- (instancetype)initWithRequestedTweets:(NSUInteger)requestedTweets totalFilters:(NSUInteger)totalFilters totalFilteredTweets:(NSUInteger)totalFilteredTweets;

- (NSString *)stringRepresentation;

@end

NS_ASSUME_NONNULL_END
