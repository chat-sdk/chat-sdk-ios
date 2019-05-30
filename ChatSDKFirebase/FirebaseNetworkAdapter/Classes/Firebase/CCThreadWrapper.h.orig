//
//  CCThread.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 10/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import "BEntity.h"

#import <ChatSDK/PThreadWrapper.h>

@class CCUserWrapper;

@interface CCThreadWrapper : BEntity<PThreadWrapper> {
    NSObject<PThread> * _model;
}

/**
 * @brief Create a new thread with a thread data model
 */
+(CCThreadWrapper *) threadWithModel: (id<PThread>) model;

/**
 * @brief Retrieve or create a thread with an entity ID
 */
+(CCThreadWrapper *) threadWithEntityID: (NSString *) entityID;

/**
 * @brief Starts listening to real-time changes to the thread meta data
 */
-(RXPromise *) on;

/**
 * @brief Stops listening to real-time changes to the thread meta data
 */
-(void) off;

/**
 * @brief Starts listening to real-time changes to the thread's messages. The thread only looks for new messages. If no messages exist it will load a maximum of 500 historic messages.
 */
-(RXPromise *) messagesOn;

/**
 * @brief Stops listening to real-time changes to the thread's messages
 */
-(void) messagesOff;

/**
 * @brief Start updating the thread users
 */
-(void) usersOn;

/**
 * @brief Stop updating the thread users
 */
-(void) usersOff;

/**
 * @brief Update/create the thread entity on the server with the thread's current meta data
 */
-(RXPromise *) push;

/**
 * @brief Add a new user to this thread - if there's an error adding the user to the thread or the thread to the user, the whole data change is rolled back
 */
-(RXPromise *) addUser: (CCUserWrapper *) user;

/**
 * @brief Remove a user from this thread - if there's an error removeing the user from the thread or the thread from the user, the whole data change is rolled back
 */
-(RXPromise *) removeUser: (CCUserWrapper *) user;

/**
 * @brief Lazyload a certain number of historic messages
 */
-(RXPromise *) loadMoreMessagesFromDate: (NSDate *) date count: (int) count;

/**
 * @brief Mark the thread as deleted on the server
 */
-(RXPromise *) deleteThread;

/**
 * @brief Remove a user from a thread - this is used when a user closes a public thread
 */
-(RXPromise *) removeUserWithEntityID: (NSString *) entityID;

/**
 * @brief If the app crashes, remove the user from the thread. This must be called each time the user is added
 */
-(void) removeUserOnDisconnect: (NSString *) entityID;


/**
 * @brief Mark the thread as read and send the read receipt
 */
-(void) markRead;

/**
 * @brief Update the class object from Firebase once
 */
-(RXPromise *) once;

/**
 * @brief Set the last message on the thread (used by the web client)
 */
-(RXPromise *) pushLastMessage: (NSDictionary *) messageData;
-(void) lastMessageOn;
-(void) lastMessageOff;

-(RXPromise *) pushMeta;
-(void) metaOn;
-(void) metaOff;
-(RXPromise *) updateLastMessage;

@end
