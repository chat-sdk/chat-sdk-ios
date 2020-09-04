//
//  BMessagingHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 04/11/2016.
//
//

#ifndef PCoreHandler_h
#define PCoreHandler_h

#import <ChatSDK/PUser.h>

@class RXPromise;

@protocol PCoreHandler <NSObject>

/**
 * @brief Update the user on the server
 */
-(RXPromise *) pushUser;

/**
 * @brief Return the current user data
 */
-(id<PUser>) currentUserModel;
-(RXPromise *) currentUserModelAsync;

// TODO: Consider removing / refactoring this
/**
 * @brief Mark the user as online
 */
-(void) setUserOnline;
-(void) setUserOffline;

/**
 * @brief Connect to the server
 */

-(void) goOffline;

/**
 * @brief Disconnect from the server
 */
-(void) goOnline;

// TODO: Consider removing / refactoring this
/**
 * @brief Subscribe to a user's updates
 */
-(RXPromise *)observeUser: (NSString *)entityID;



-(id<PUser>) userForEntityID: (NSString *) entityID;

// TODO: Consider removing this
/**
 * @brief Core Data doesn't save data to disk automatically. During the programs execution
 * Core Data stores all data chages in memory and when the program terminates these
 * changes are lost. Calling save forces Core Data to persist the data to perminant storage
 */
-(void) save;

// Save the data to perminent storage
-(void) saveToStore;


@end

#endif /* PCoreHandler_h */
