//
//  TWTRScribeEvent.h
//
//  Created by Mustafa Furniturewala on 7/21/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFSScribe.h"
#import "TWTRScribeClientEventNamespace.h"
#import "TWTRScribeItem.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const TWTRScribeEventImpressionClient;
FOUNDATION_EXPORT NSString *const TWTRScribeEventImpressionPage;
FOUNDATION_EXPORT NSString *const TWTRScribeEventImpressionSectionTweet;
FOUNDATION_EXPORT NSString *const TWTRScribeEventImpressionSectionQuoteTweet;
FOUNDATION_EXPORT NSString *const TWTRScribeEventImpressionSectionVideo;
FOUNDATION_EXPORT NSString *const TWTRScribeEventImpressionSectionGallery;
FOUNDATION_EXPORT NSString *const TWTRScribeEventImpressionSectionAuth;

FOUNDATION_EXPORT NSString *const TWTRScribeEventImpressionComponent;
FOUNDATION_EXPORT NSString *const TWTRScribeEmptyKey;
FOUNDATION_EXPORT NSString *const TWTRScribeEventImpressionTypeLoad;
FOUNDATION_EXPORT NSString *const TWTRScribeEventImpressionTypeImpression;
FOUNDATION_EXPORT NSString *const TWTRScribeEventImpressionTypeShare;
FOUNDATION_EXPORT NSString *const TWTRScribeEventImpressionAction;
FOUNDATION_EXPORT NSString *const TWTRScribeEventActionClick;
FOUNDATION_EXPORT NSString *const TWTRScribeEventActionFilter;

FOUNDATION_EXPORT NSString *const TWTRScribeEventUniquesClient;
FOUNDATION_EXPORT NSString *const TWTRScribeEventUniquesPageTweetViews;
FOUNDATION_EXPORT NSString *const TWTRScribeEventUniquesPageLogin;
FOUNDATION_EXPORT NSString *const TWTRScribeEventUniquesAction;

FOUNDATION_EXPORT NSString *const TWTRScribeActionLike;
FOUNDATION_EXPORT NSString *const TWTRScribeActionUnlike;
FOUNDATION_EXPORT NSString *const TWTRScribeActionStart;
FOUNDATION_EXPORT NSString *const TWTRScribeActionSuccess;
FOUNDATION_EXPORT NSString *const TWTRScribeActionCancelled;
FOUNDATION_EXPORT NSString *const TWTRScribeActionFailure;

/**
 *  Possible values for which category to scribe events to.
 */
typedef NS_ENUM(NSUInteger, TWTRScribeEventCategory) {
    /**
     *  Used for logging impressions and feature usage for Tweet views.
     */
    TWTRScribeEventCategoryImpressions = 1,
    /**
     *  Used only for logging number of uniques using the Kit. There are no browsing history logged,
     *  so we can keep the events longer to calculate monthly actives.
     */
    TWTRScribeEventCategoryUniques
};

@interface TWTRScribeEvent : NSObject <TFSScribeEventParameters>

@property (nonatomic, copy, readonly, nullable) NSString *userID;
@property (nonatomic, copy, readonly, nullable) NSString *tweetID;
@property (nonatomic, copy, readonly) NSString *eventInfo;
@property (nonatomic, assign, readonly) TWTRScribeEventCategory category;
@property (nonatomic, copy, readonly) TWTRScribeClientEventNamespace *eventNamespace;
@property (nonatomic, copy, readonly) NSArray<TWTRScribeItem *> *items;

- (instancetype)init __unavailable;
- (instancetype)initWithUserID:(nullable NSString *)userID tweetID:(nullable NSString *)tweetID category:(TWTRScribeEventCategory)category eventNamespace:(TWTRScribeClientEventNamespace *)eventNamespace items:(nullable NSArray<TWTRScribeItem *> *)items;

- (instancetype)initWithUserID:(nullable NSString *)userID eventInfo:(nullable NSString *)eventInfo category:(TWTRScribeEventCategory)category eventNamespace:(TWTRScribeClientEventNamespace *)eventNamespace items:(nullable NSArray<TWTRScribeItem *> *)items;

#pragma mark - TFSScribeEventParameters

- (NSDictionary *)dictionaryRepresentation;
- (NSString *)userID;
- (NSData *)data;

@end

/**
 *  A Scribe event for logging errors to the Twitter backend
 */
@interface TWTRErrorScribeEvent : TWTRScribeEvent

@property (nonatomic, readonly) NSError *error;
@property (nonatomic, copy, readonly) NSString *errorMessage;

/**
 *  Initializer
 *
 *  @param error        (optional) An NSError object representing this error case.
 *  @param errorMessage (required) An error message describing the error situation.
 *
 *  @return A fully initialized scribe object ready to enqueue or nil if any of
 *          the required parameters are missing.
 */
- (instancetype)initWithError:(nullable NSError *)error message:(NSString *)errorMessage;

@end

NS_ASSUME_NONNULL_END
