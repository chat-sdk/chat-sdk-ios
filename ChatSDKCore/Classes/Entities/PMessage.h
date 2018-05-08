//
//  PMessage.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 09/04/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "PUser.h"
#import "PThread_.h"
#import "bMessageStatus.h"

typedef enum {
    bMessageTypeText,
    bMessageTypeLocation,
    bMessageTypeImage,
    bMessageTypeAudio,
    bMessageTypeVideo,
    bMessageTypeSystem,
    bMessageTypeSticker,
    bMessageTypeFile,
    bMessageTypeCustom,
} bMessageType;

typedef enum {
    bMessagePosFirst = 0x1,
    bMessagePosLast = 0x2,
    bMessagePosMiddle = bMessagePosFirst & bMessagePosLast,
    bMessagePosSingle = bMessagePosFirst | bMessagePosLast,
} bMessagePos;

#define bMessageTextKey @"text"

#define bMessageTypeKey @"type"

#define bMessageImageURL @"image-url"
#define bMessageThumbnailURL @"thumbnail-url"

#define bMessageImageWidth @"image-width"
#define bMessageImageHeight @"image-height"
#define bMessageVideoURL @"video-url"

#define bMessageLongitude @"longitude"
#define bMessageLatitude @"latitude"
#define bMessageAudioURL @"audio-url"
#define bMessageAudioLength @"audio-length"

// Is the message the first, last or a middle message
//#define bMessagePosition @"position"


#define bMessageOriginalThreadEntityID @"original-thread-entity-id"
//#define bMessageSenderIsMe @"sender-is-me"

#define bMessageSticker @"sticker"

typedef enum {
    bSystemMessageTypeInfo = 1,
    bSystemMessageTypeError = 2,
} bSystemMessageType;

@protocol PMessage <PEntity>

/**
 * @brief Message text body
 */
-(void) setText: (NSString *) text;
-(NSString *) text;

-(NSString *) textString;

-(NSDictionary *) json;
-(void) setJson: (NSDictionary *) json;
-(NSDictionary *) compatibilityMeta;

/**
 * @brief Message type - Text, image, location
 * @param type NSNumber(bMessageType) Message type enum
 */
-(void) setType: (NSNumber *) type;
-(NSNumber *) type;

// Use thread setMessage instead
//-(void) setThread: (id<PThread>) thread;
-(id<PThread>) thread;

-(void) setEntityID:(NSString *)uid;
-(NSString *) entityID;

-(NSDictionary *) textAsDictionary;
-(NSError *) setTextAsDictionary: (NSDictionary *) dict;

/**
 * @brief Set user that sent the message
 * @param user id<PUser> user
 */
-(void) setUserModel:(id<PUser>)user;
-(id<PUser>) userModel;

/**
 * @brief Has the user seen this message
 */
-(void) setRead: (NSNumber *) read;
-(NSNumber *) read;

/**
 * @brief Message creation date
 */
-(void) setDate: (NSDate *) date;
-(NSDate *) date;

/**
 * @brief The message is marked as delivered once it arrives at the server successfully
 */
-(void) setDelivered: (NSNumber *) delivered;
-(NSNumber *) delivered;

/**
 * @brief Message bubble color
 */
-(NSString *) color;

/**
 * @brief Placeholder image
 * @return placeholder NSData(UIImage)
 */
-(NSData *) placeholder;
-(void) setPlaceholder: (NSData *) placeholder;

- (NSURL *)thumbnailURL;

- (NSInteger)imageWidth;

- (NSInteger)imageHeight;

-(void) setMetaValue: (id) value forKey: (NSString *) key;
-(id) metaValueForKey: (NSString *) key;

-(void) setMetaDictionary: (NSDictionary *) dict;
-(NSDictionary *) metaDictionary;

-(bMessagePos) messagePosition;
-(BOOL) senderIsMe;
-(id<PMessage>) lazyNextMessage;
-(id<PMessage>) lazyLastMessage;
-(void) updatePosition;


- (BOOL)showUserNameLabelForPosition: (bMessagePos) position;

/**
 * @brief Message flagged on server for moderator attention
 */

- (NSNumber *)flagged;
-(void) setFlagged: (NSNumber *) flagged;
-(id<PMessage>) copy;

@optional

-(void) setReadStatus:(NSDictionary *)status;

-(void) setReadStatus: (bMessageReadStatus) status_ forUserID: (NSString *) uid;
-(bMessageReadStatus) readStatusForUserID: (NSString *) uid;
-(bMessageReadStatus) readStatus;


@end
