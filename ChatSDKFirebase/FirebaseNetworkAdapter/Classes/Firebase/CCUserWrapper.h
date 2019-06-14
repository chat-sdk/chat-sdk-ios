//
//  BUser+BUser_Chatcat.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 09/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import <ChatSDK/PUserWrapper.h>
#import <ChatSDKFirebase/BEntity.h>

@class FIRUser;
@class FIRDataSnapshot;

@interface CCUserWrapper : BEntity <PUserWrapper> {
    NSObject<PUser> * _model;
}

+(CCUserWrapper *) userWithModel: (id<PUser>) user;
+(CCUserWrapper *) userWithSnapshot: (FIRDataSnapshot *) data;
+(CCUserWrapper *) userWithAuthUserData: (FIRUser *) user;
+(CCUserWrapper *) userWithEntityID: (NSString *) entityID;

/**
 * @brief Update the user object from Firebase once
 */
-(RXPromise *) once;

/**
 * @brief Push the current object data to the server
 */
-(RXPromise *) push;

///**
// * @brief Update the object in real-time from Firebase
// */
//-(RXPromise *) on;
//
/**
 * @brief Turn off real-time updates
 */
-(void) off;

/**
 * @brief Update the user meta in real-time from Firebase
 */
-(RXPromise *) metaOn;

/**
 * @brief Turn off real-time meta updates
 */
-(void) metaOff;

/**
 * @brief Update that the user has come online
 */
-(RXPromise *) onlineOn;

/**
 * @brief Update that the user has gone offline
 */
-(void) onlineOff;

/**
 * @brief This doesn't add the thread to the user's data model, only Firebase - you should use [thread addUser: ] instead
 */
-(RXPromise *) addThreadWithEntityID: (NSString *) entityID;

/**
 * @brief This doesn't remove the thread from the user's data model, only Firebase - you should use [thread removeUser: ] instead
 */
-(RXPromise *) removeThreadWithEntityID: (NSString *) entityID;

/**
 * @brief Set the user's status to online. The status will be set to offline automatically on disconnect
 */
-(void) goOnline;

/**
 * @brief Manually set the user's status to offline
 */
-(void) goOffline;
/**
 * @brief Remove a thread from the user on disconnect
 */
-(void) removeThreadOnDisconnect: (NSString *) entityID;

@end
