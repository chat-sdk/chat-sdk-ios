//
//  TWTRScribeMediaDetails.h
//  TwitterCore
//
//  Created by Kang Chen on 11/18/15.
//  Copyright © 2015 Twitter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWTRScribeSerializable.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Mapping to `MediaType` in scribing.
 */
typedef NS_ENUM(NSUInteger, TWTRScribeMediaType) {
    /**
     *  Consumer video uploaded to Twitter.
     */
    TWTRScribeMediaTypeConsumerVideo = 1,
    /**
     *  Amplify videos.
     */
    TWTRScribeMediaTypeProfessionalVideo = 2,
    /**
     *  Gif as a video.
     */
    TWTRScribeMediaTypeGIF = 3,
    /**
     *  Vine as a video.
     */
    TWTRScribeMediaTypeVine = 4
};

@interface TWTRScribeMediaDetails : NSObject <TWTRScribeSerializable>

@property (nonatomic, readonly, copy) NSString *publisherID;
@property (nonatomic, readonly, copy) NSString *contentID;
@property (nonatomic, readonly) TWTRScribeMediaType mediaType;

- (instancetype)init NS_UNAVAILABLE;
/**
 *  Initializes a new media detail scribe item.
 *
 *  @param publisherID Owner (publisher) of the content. This is often the Twitter user.
 *  @param contentID   UUID to the content. This is often the entity ID.
 *  @param mediaType   Type of media included.
 *
 *  @return A new media detail scribe item.
 */
- (instancetype)initWithPublisherID:(NSString *)publisherID contentID:(NSString *)contentID mediaType:(TWTRScribeMediaType)mediaType;

@end

NS_ASSUME_NONNULL_END
