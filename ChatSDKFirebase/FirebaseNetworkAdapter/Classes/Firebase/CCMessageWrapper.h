//
//  CCMessage.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 10/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import "BEntity.h"

#import <ChatSDK/PMessageWrapper.h>

@class CDMessage;
@class FIRDatabaseReference;
@class FIRDataSnapshot;

@interface CCMessageWrapper : BEntity <PMessageWrapper> {
    NSObject<PMessage> * _model;
}

/**
 * @brief Create a new message from a server snapshot
 */
+(id) messageWithSnapshot: (FIRDataSnapshot *) snapshot;

/**
 * @brief Create a new message based on an existing data model
 */
+(id) messageWithModel: (id<PMessage>) model;

/**
 * @brief Create a new message with an existing message entity ID
 */
+(id) messageWithID: (NSString *) entityID;

/**
 * @brief Send the message to the thread associated with it's model
 */
-(RXPromise *) send;

-(RXPromise *) flag;
-(RXPromise *) unflag;
-(RXPromise *) delete;

-(NSDictionary *) lastMessageData;

-(FIRDatabaseReference *) ref;
-(RXPromise *) markAsReceived;
-(RXPromise *) setReadStatus: (bMessageReadStatus) status;

@end
