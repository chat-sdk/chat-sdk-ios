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
    bMessageTypeAll = -1,
    bMessageTypeText = 0,
    bMessageTypeLocation = 1,
    bMessageTypeImage = 2,
    bMessageTypeAudio = 3,
    bMessageTypeVideo = 4,
    bMessageTypeSystem = 5,
    bMessageTypeSticker = 6,
    bMessageTypeFile = 7,
    bMessageTypeSilent = 98,
    bMessageTypeCustom = 99,
} bMessageType;

typedef enum {
    bMessagePosFirst = 0x1,
    bMessagePosLast = 0x2,
    bMessagePosMiddle = bMessagePosFirst & bMessagePosLast,
    bMessagePosSingle = bMessagePosFirst | bMessagePosLast,
} bMessagePos;

typedef enum {
    bMessageActionUserLeftGroup = 1,
    bMessageActionUserGroupInvite = 2
} bMessageAction;


#define bMessageText @"text"

// We need the key here so it doesn't clash with the enum
#define bMessageTypeKey @"type"

#define bMessageImageURL @"image-url"

#define bMessageImageWidth @"image-width"
#define bMessageImageHeight @"image-height"
#define bMessageVideoURL @"video-url"
#define bMessageFileURL @"file-url"
#define bMessageMimeType @"mime-type"

#define bMessageLongitude @"longitude"
#define bMessageLatitude @"latitude"
#define bMessageAudioURL @"audio-url"
#define bMessageAudioLength @"audio-length"
#define bMessageEncryptedPayloadKey @"encrypted-message"

#define bMessageSystemType @"system-type"

#define bMessageIsHistoric @"historic"

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

-(NSURL*) imageURL;

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

/**
 * @brief Set user that sent the message
 * @param user id<PUser> user
 */
-(void) setUserModel:(id<PUser>)user;
-(id<PUser>) userModel;
-(id<PUser>) user;
/**
 * @brief Has the user seen this message
 */
-(void) setRead: (NSNumber *) read;
-(BOOL) isRead;
-(BOOL) isDelivered;

/**
 * @brief Message creation date
 */
-(void) setDate: (NSDate *) date;
-(NSDate *) date;

/**
 * @brief The message is marked as delivered once it arrives at the server successfully
 */
-(void) setDelivered: (NSNumber *) delivered;

/**
 * @brief Placeholder image
 * @return placeholder NSData(UIImage)
 */
-(NSData *) placeholder;
-(void) setPlaceholder: (NSData *) placeholder;

- (NSInteger)imageWidth;

- (NSInteger)imageHeight;

-(void) setMeta: (NSDictionary *) meta;
-(NSDictionary *) meta;

-(bMessagePos) messagePosition;
-(BOOL) senderIsMe;
-(void) updatePosition;

-(BOOL) isReply;
-(NSString *) reply;
-(bMessageType) replyType;

- (BOOL)showUserNameLabelForPosition: (bMessagePos) position;

/**
 * @brief Message flagged on server for moderator attention
 */

- (NSNumber *)flagged;
-(void) setFlagged: (NSNumber *) flagged;
//-(id<PMessage>) copy;

@optional


-(void) setReadStatus:(NSDictionary *)status;
-(BOOL) setReadStatus: (bMessageReadStatus) status_ forUserID: (NSString *) uid date: (NSDate *) date;
-(BOOL) setReadStatus: (bMessageReadStatus) status_ forUserID: (NSString *) uid;
-(bMessageReadStatus) readStatusForUserID: (NSString *) uid;
-(bMessageReadStatus) messageReadStatus;
-(void) setMetaValue: (id) value forKey: (NSString *) key;
-(void) setupInitialReadReceipts;
-(void) setReadReceiptsTo: (bMessageReadStatus) status;

@end
