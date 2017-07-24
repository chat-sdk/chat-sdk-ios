//
//  TWTRTimelineFilter.h
//  TwitterKit
//
//  Copyright © 2016 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Assigning this object to any data source that implements `TWTRTimelineDataSource`
 * will filter the tweets on that timeline using the provided filter configuration.
 */
@interface TWTRTimelineFilter : NSObject <NSCopying>

@property (nonatomic, copy, nullable) NSSet *keywords;

@property (nonatomic, copy, nullable) NSSet *hashtags;

@property (nonatomic, copy, nullable) NSSet *handles;

@property (nonatomic, copy, nullable) NSSet *urls;

- (nullable instancetype)initWithJSONDictionary:(nonnull NSDictionary *)dictionary;
- (nonnull instancetype)new NS_UNAVAILABLE;

/*
 * Returns count of all filters
 */
- (NSUInteger)filterCount;
@end
