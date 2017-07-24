//
//  TWTRScribeCardEvent.h
//  TwitterCore
//
//  Created by Kang Chen on 9/30/15.
//  Copyright © 2015 Twitter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWTRScribeSerializable.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Type of promotional card. Numeric values are direct mapping of what's in the backend.
 */
typedef NS_ENUM(NSUInteger, TWTRScribePromotionCardType) {
    /**
     *  Image App Card
     */
    TWTRScribePromotionCardTypeImageAppDownload = 8,
};

/**
 *  Immutable representation of a scribe Card event item.
 */
@interface TWTRScribeCardEvent : NSObject <TWTRScribeSerializable>

@property (nonatomic, readonly) TWTRScribePromotionCardType promotionCardType;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithPromotionCardType:(TWTRScribePromotionCardType)promotionCardType;

@end

NS_ASSUME_NONNULL_END
