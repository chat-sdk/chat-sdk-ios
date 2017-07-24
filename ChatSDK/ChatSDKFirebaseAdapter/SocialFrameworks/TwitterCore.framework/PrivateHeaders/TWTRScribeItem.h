//
//  TWTRScribeItem.h
//  TwitterKit
//
//  Created by Kang Chen on 11/18/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//

@class TWTRScribeFilterDetails;
@class TWTRScribeMediaDetails;
@class TWTRScribeCardEvent;

#import <Foundation/Foundation.h>
#import "TWTRScribeSerializable.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  The type of item (tweet, user, trend, list, etc). Certain values are deprecated so be sure to
 *  check `client_app.thrift` before adding more fields. The raw values here are exactly as they appear
 *  on the backend so do not change without double checking against the thrift IDL.
 */
typedef NS_ENUM(NSUInteger, TWTRScribeItemType) { TWTRScribeItemTypeTweet = 0, TWTRScribeItemTypeUser = 3, TWTRScribeItemTypeMessage = 6, TWTRScribeItemTypeCustomTimeline = 17 };

/**
 *  Model object describing Scribe event details. `Items` is a property of `EventDetails` containing
 *  details of what the specific item being scribed is e.g. type = Tweet and Tweet ID. This model only
 *  contains a subset of what's defined in `client_app.thrift`.
 *  @see https://cgit.twitter.biz/source/tree/science/src/thrift/com/twitter/clientapp/gen/client_app.thrift
 */
@interface TWTRScribeItem : NSObject <TWTRScribeSerializable>

@property (nonatomic, assign, readonly) TWTRScribeItemType itemType;
/**
 *  Using String instead of 64-bit int on the backend for convenience.
 */
@property (nonatomic, copy, readonly, nullable) NSString *itemID;

@property (nonatomic, readonly, nullable) TWTRScribeCardEvent *cardEvent;

@property (nonatomic, readonly, nullable) TWTRScribeMediaDetails *mediaDetails;

@property (nonatomic, readonly, nullable) TWTRScribeFilterDetails *filterDetails;

- (instancetype)init __attribute__((unavailable("Every attribute is optional on the backend but we want to be stricter on the client.")));
- (instancetype)initWithItemType:(TWTRScribeItemType)itemType itemID:(NSString *)itemID;
- (instancetype)initWithItemType:(TWTRScribeItemType)itemType itemID:(nullable NSString *)itemID cardEvent:(nullable TWTRScribeCardEvent *)cardEvent mediaDetails:(nullable TWTRScribeMediaDetails *)mediaDetails;
/**
 *  Initiatizes a generic Scribe Item typically displayed in streams or dashboard modules e.g. Timelines
 *
 *  @param itemType the type of item displayed
 *  @param itemID   corresponds to `Item.id` but `id` is keyword in ObjC. This is used to describe
 *                  the `Item`'s identifier e.g. Tweet ID
 *  @param cardEvent    Information pertaining to the Twitter Card displayed.
 *  @param mediaDetails Information pertaining to the media rendered in the item.
 *  @param filterDetails Information pertainng to the timeline filter.
 *
 */
- (instancetype)initWithItemType:(TWTRScribeItemType)itemType itemID:(nullable NSString *)itemID cardEvent:(nullable TWTRScribeCardEvent *)cardEvent mediaDetails:(nullable TWTRScribeMediaDetails *)mediaDetails filterDetails:(nullable TWTRScribeFilterDetails *)filterDetails NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
