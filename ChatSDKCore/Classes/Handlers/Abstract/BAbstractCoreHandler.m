//
//  BAbstractCoreHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BAbstractCoreHandler.h"

#import <ChatSDK/ChatCore.h>

@implementation BAbstractCoreHandler

-(instancetype) init {
    if ((self = [super init])) {
        // Start checking if we are connected to the internet
        [[Reachability reachabilityForInternetConnection] startNotifier];
        
    }
    return self;
}

-(RXPromise *) sendMessageWithText:(NSString *)text withThreadEntityID:(NSString *)threadID withMetaData: (NSDictionary *)meta {
    
    // Set the URLs for the images and save it in CoreData
    [[BStorageManager sharedManager].a beginUndoGroup];
    
    id<PMessage> message = [[BStorageManager sharedManager].a createEntity:bMessageEntity];
    
    id<PThread> thread = [[BStorageManager sharedManager].a fetchEntityWithID:threadID withType:bThreadEntity];
    [thread addMessage: message];
    
    message.type = @(bMessageTypeText);
    [message setTextAsDictionary:@{bMessageTextKey: text}];
    
    message.date = [NSDate date];
    message.userModel = self.currentUserModel;
    message.delivered = @NO;
    message.read = @YES;
    message.flagged = @NO;
    message.metaDictionary = meta;
    
    return [self sendMessage:message];
}

-(RXPromise *) sendMessageWithText:(NSString *)text withThreadEntityID:(NSString *)threadID {
    return [self sendMessageWithText:text withThreadEntityID:threadID withMetaData:nil];
}


-(RXPromise *) sendMessage: (id<PMessage>) messageModel {
    // This is an abstract method which must be overridden
    NSLog(@"sendMessage: must be overridden");
    assert(1 == 2);
}

-(NSArray *) messagesForThreadWithEntityID:(NSString *) entityID order: (NSComparisonResult) order {
    // Get the thread
    id<PThread> thread = [[BStorageManager sharedManager].a fetchEntityWithID:entityID withType:bThreadEntity];
    
    if (thread) {
        if (order == NSOrderedAscending) {
            return thread.messagesOrderedByDateAsc;
        }
        if (order == NSOrderedDescending) {
            return thread.messagesOrderedByDateDesc;
        }
    }
    return Nil;
}

-(NSArray *) threadsWithType:(bThreadType)type {
    return [self threadsWithType:type includeDeleted:NO includeEmpty:[BChatSDK shared].configuration.showEmptyChats];
}

-(NSArray *) threadsWithType:(bThreadType)type includeDeleted: (BOOL) includeDeleted includeEmpty: (BOOL) includeEmpty {
    
    NSMutableArray * threads = [NSMutableArray new];
    NSArray * allThreads = type & bThreadFilterPrivate ? NM.currentUser.threads : [[BStorageManager sharedManager].a fetchEntitiesWithName:bThreadEntity];
    
    for(id<PThread> thread in allThreads) {
        if(thread.type.intValue & bThreadFilterPrivate) {
            if(thread.type.intValue & type  && (!thread.deleted_.boolValue || includeDeleted) && (thread.hasMessages || includeEmpty)) {
                [threads addObject:thread];
            }
        }
        else if (thread.type.intValue & bThreadFilterPublic) {
            if(thread.type.intValue & type) {
                [threads addObject:thread];
            }
        }
    }
    
    [threads sortUsingComparator:^(id<PThread> t1, id<PThread> t2) {
        return [t2.lastMessageAdded compare:t1.lastMessageAdded];
    }];
    
    return threads;
}

-(void) save {
    [[BStorageManager sharedManager].a save];
}

-(void) sendLocalSystemMessageWithText:(NSString *)text withThreadEntityID:(NSString *)threadID {
    [self sendLocalSystemMessageWithText:text type:bSystemMessageTypeInfo withThreadEntityID:threadID];
}

-(void) sendLocalSystemMessageWithText:(NSString *)text type: (bSystemMessageType) type withThreadEntityID:(NSString *)threadID {
    
    // Set the URLs for the images and save it in CoreData
    id<PMessage> message = [[BStorageManager sharedManager].a createEntity:bMessageEntity];
    message.entityID = [BCoreUtilities getUUID];
    
    message.type = @(bMessageTypeSystem);
    //message.text = text;
    [message setTextAsDictionary:@{bMessageTypeKey: @(type),
                                   bMessageTextKey: text}];
    
    id<PThread> thread = [[BStorageManager sharedManager].a fetchEntityWithID:threadID withType:bThreadEntity];
    [thread addMessage: message];

    message.date = [NSDate date];
    message.userModel = self.currentUserModel;
    message.delivered = @YES;
    message.read = @YES;
    message.flagged = @NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationMessageAdded
                                                            object:Nil
                                                          userInfo:@{bNotificationMessageAddedKeyMessage: message}];
    });
    
}

-(id<PUser>) userForEntityID: (NSString *) entityID {
    // Get the user and make sure it's updated
    id<PUser> user = [[BStorageManager sharedManager].a fetchOrCreateEntityWithID:entityID
                                                                               withType:bUserEntity];
    return user;
}

/**
 * @brief Update the user on the server
 */
-(RXPromise *) pushUser {
    assert(NO);
}

/**
 * @brief Return the current user data
 */
-(id<PUser>) currentUserModel {
    assert(NO);
}

// TODO: Consider removing / refactoring this
/**
 * @brief Mark the user as online
 */
-(void) setUserOnline {
    assert(NO);
}

/**
 * @brief Connect to the server
 */

-(void) goOffline {
    assert(NO);
}


/**
 * @brief Disconnect from the server
 */
-(void) goOnline {
    if(NM.lastOnline && [NM.lastOnline respondsToSelector:@selector(setLastOnlineForUser:)]) {
        [NM.lastOnline setLastOnlineForUser:self.currentUserModel];
    }
}

// TODO: Consider removing / refactoring this
/**
 * @brief Subscribe to a user's updates
 */
-(void)observeUser: (NSString *)entityID {
    assert(NO);
}

/**
 * @brief This method invites adds the users provided to a a conversation thread
 * Register block to:
 * - Handle thread creation
 */
-(RXPromise *) createThreadWithUsers: (NSArray *) users
                                name: (NSString *) name
                       threadCreated: (void(^)(NSError * error, id<PThread> thread)) threadCreated {
    assert(NO);
}

-(RXPromise *) createThreadWithUsers: (NSArray *) users
                       threadCreated: (void(^)(NSError * error, id<PThread> thread)) thread {
    assert(NO);
}

/**
 * @brief Add users to a thread
 */
-(RXPromise *) addUsers: (NSArray *) users toThread: (id<PThread>) threadModel {
    assert(NO);
}

/**
 * @brief Remove users from a thread
 */
-(RXPromise *) removeUsers: (NSArray *) users fromThread: (id<PThread>) threadModel {
    assert(NO);
}

/**
 * @brief Lazy loading of messages this method will load
 * that are not already in memory
 */
-(RXPromise *) loadMoreMessagesForThread: (id<PThread>) threadModel {
    assert(NO);
}

/**
 * @brief This method deletes an existing thread. It deletes the thread from memory
 * and removes the user from the thread so the user no longer recieves notifications
 * from the thread
 */
-(RXPromise *) deleteThread: (id<PThread>) thread {
    assert(NO);
}

-(RXPromise *) leaveThread: (id<PThread>) thread {
    assert(NO);
}

-(RXPromise *) joinThread: (id<PThread>) thread {
    assert(NO);
}

@end
