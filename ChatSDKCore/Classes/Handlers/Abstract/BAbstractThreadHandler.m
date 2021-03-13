//
//  BAbstractThreadHandler.m
//  AFNetworking
//
//  Created by ben3 on 06/07/2020.
//

#import "BAbstractThreadHandler.h"

#import <ChatSDK/Core.h>
#import <Foundation/Foundation.h>

@implementation BAbstractThreadHandler

-(RXPromise *) sendMessageWithText:(NSString *)text withThreadEntityID:(NSString *)threadID withMetaData: (NSDictionary *)meta {
    
    // Set the URLs for the images and save it in CoreData
    [BChatSDK.db beginUndoGroup];
    
    id<PMessage> message = [[[[BMessageBuilder textMessage:text] meta:meta] thread:threadID] build];
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
    id<PThread> thread = [BChatSDK.db fetchEntityWithID:entityID withType:bThreadEntity];
    
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
    return [self threadsWithType:type includeDeleted:NO];
}

-(NSArray *) threadsWithType:(bThreadType)type includeDeleted: (BOOL) includeDeleted {
    return [self threadsWithType:type includeDeleted:includeDeleted includeEmpty:BChatSDK.config.showEmptyChats];
}

// TODO: Optimize this
-(NSArray *) threadsWithType:(bThreadType)type includeDeleted: (BOOL) includeDeleted includeEmpty: (BOOL) includeEmpty {
    
    NSMutableArray * threads = [NSMutableArray new];
//    NSArray * allThreads = type & bThreadFilterPrivate ? BChatSDK.currentUser.threads : [BChatSDK.db fetchEntitiesWithName:bThreadEntity];
    NSArray * allThreads = [BChatSDK.db threadsWithType:type];

    if (type & bThreadFilterPrivate) {
        for(id<PThread> thread in allThreads) {
            if((!thread.deletedDate || includeDeleted) && (thread.hasMessages || includeEmpty)) {
                [threads addObject:thread];
            }
        }
    }
    if (type & bThreadFilterPublic) {
        for(id<PThread> thread in allThreads) {
            if ((!thread.deletedDate || includeDeleted) && (thread.hasMessages || includeEmpty)) {
                if (BChatSDK.config.publicChatRoomLifetimeMinutes == 0) {
                    [threads addObject:thread];
                } else {
                    NSDate * now = [NSDate date];
                    NSTimeInterval interval = [now timeIntervalSinceDate:thread.creationDate];
                    if (interval < BChatSDK.config.publicChatRoomLifetimeMinutes * 60) {
                        [threads addObject:thread];
                    } else {
                        [thread markRead];
                    }
                }
            }
        }
    }
    
    [threads sortUsingComparator:^(id<PThread> t1, id<PThread> t2) {
        return [t2.orderDate compare:t1.orderDate];
    }];
    
    return threads;
}

-(void) sendLocalSystemMessageWithText:(NSString *)text withThreadEntityID:(NSString *)threadID {
    [self sendLocalSystemMessageWithText:text type:bSystemMessageTypeInfo withThreadEntityID:threadID];
}

-(void) sendLocalSystemMessageWithText:(NSString *)text type: (bSystemMessageType) type withThreadEntityID:(NSString *)threadID {
    id<PMessage> message = [[[BMessageBuilder systemMessage:text type:type] thread:threadID] build];
    [BHookNotification notificationMessageReceived:message];
}

/**
 * @brief This method invites adds the users provided to a a conversation thread
 * Register block to:
 * - Handle thread creation
 */
-(RXPromise *) createThreadWithUsers: (NSArray *) users
                                name: (NSString *) name
                                type: (bThreadType) type
                            entityID: (NSString *) entityID
                         forceCreate: (BOOL) force
                       threadCreated: (void(^)(NSError * error, id<PThread> thread)) threadCreated {
    assert(NO);
}

-(RXPromise *) createThreadWithUsers: (NSArray *) users
                                name: (NSString *) name
                         forceCreate: (BOOL) force
                       threadCreated: (void(^)(NSError * error, id<PThread> thread)) threadCreated {
    return [self createThreadWithUsers:users
                                  name:name
                                  type:bThreadTypeNone
                              entityID:nil
                           forceCreate:force
                         threadCreated:threadCreated];
}


-(RXPromise *) createThreadWithUsers: (NSArray *) users
                                name: (NSString *) name
                       threadCreated: (void(^)(NSError * error, id<PThread> thread)) threadCreated {
    return [self createThreadWithUsers:users
                                  name:name
                           forceCreate:NO
                         threadCreated:threadCreated];
}

-(RXPromise *) createThreadWithUsers: (NSArray *) users
                       threadCreated: (void(^)(NSError * error, id<PThread> thread)) threadCreated {
    return [self createThreadWithUsers:users name:nil threadCreated:threadCreated];
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

-(RXPromise *) removeUsers:(NSArray<NSString *> *)userEntityIDs fromThread:(NSString *) threadEntityID {
    assert(NO);
}

-(BOOL) canRemoveUser: (NSString *) userEntityID fromThread: (NSString *) threadEntityID {
    return NO;
}

-(BOOL) canRemoveUsers: (NSArray<NSString *> *) userEntityIDs fromThread: (NSString *) threadEntityID {
    for (NSString * entityID in userEntityIDs) {
        if (![self canRemoveUser:entityID fromThread:threadEntityID]) {
            return false;
        }
    }
    return true;
}

/**
 * @brief Lazy loading of messages this method will load
 * that are not already in memory
 */
-(RXPromise *) loadMoreMessagesFromDate: (NSDate *) date forThread: (id<PThread>) threadModel {
    return [self loadMoreMessagesFromDate:date forThread:threadModel fromServer:YES];
}

-(RXPromise *) loadMoreMessagesFromDate: (NSDate *) date forThread: (id<PThread>) threadModel fromServer: (BOOL) fromServer {
    RXPromise * promise = [RXPromise new];
    NSArray * messages = [BChatSDK.db loadMessagesForThread:threadModel fromDate:date count:BChatSDK.config.messagesToLoadPerBatch];
    [promise resolveWithResult:messages];
    return promise;
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
    id<PUser> user = BChatSDK.currentUser;
    return [self removeUsers:@[user] fromThread:thread];
}

-(RXPromise *) joinThread: (id<PThread>) thread {
    id<PUser> user = BChatSDK.currentUser;
   return [self addUsers:@[user] toThread:thread];
}

-(id<PThread>) fetchThreadWithUsers: (NSArray *) users {
    id<PUser> currentUser = BChatSDK.core.currentUserModel;
    
    NSMutableArray * usersToAdd = [NSMutableArray arrayWithArray:users];
    [usersToAdd removeObject:currentUser];
    [usersToAdd addObject:currentUser];
    
    // If there are only two users check to see if a thread already exists
    if (usersToAdd.count == 2) {
        
        // Check to see if we already have a chat with this user
        id<PThread> jointThread = Nil;
        
        NSSet * usersToAddSet = [NSSet setWithArray:usersToAdd];
        
        // Check to see if a thread already exists with these
        // two users
        for (id<PThread> thread in [BChatSDK.thread threadsWithType:bThreadType1to1 includeDeleted:YES includeEmpty:YES]) {
            if ([thread.users isEqual:usersToAddSet]) {
                jointThread = thread;
                break;
            }
        }
        
        // Complete with the thread
        if(jointThread) {
            [jointThread setDeletedDate: Nil];
            return jointThread;
        }
    }
    return Nil;
}

-(id<PThread>) fetchOrCreateThreadWithUsers: (NSArray *) users name: (NSString *) name {
    id<PThread> thread = [self fetchThreadWithUsers:users];
    if (!thread) {
        thread = [self createThreadWithUsers:users name:name];
    }
    return thread;
}

-(id<PThread>) createThreadWithUsers: (NSArray *) users name: (NSString *) name {
    return [self createThreadWithUsers:users name:name type:bThreadTypeNone];
}

-(id<PThread>) createThreadWithUsers: (NSArray *) users name: (NSString *) name type: (bThreadType) type {

    id<PUser> currentUser = BChatSDK.core.currentUserModel;
    
    NSMutableArray * usersToAdd = [NSMutableArray arrayWithArray:users];
    [usersToAdd removeObject:currentUser];
    [usersToAdd addObject:currentUser];
    
    // Before we create the thread start an undo grouping
    // that means that if it fails we can undo changed to the database
    //[BChatSDK.db beginUndoGroup];
    
    id<PThread> threadModel = [BChatSDK.db createThreadEntity];
    threadModel.creationDate = [NSDate date];
    threadModel.creator = currentUser;
    if (type != bThreadTypeNone) {
        threadModel.type = @(type);
    } else {
        threadModel.type = usersToAdd.count == 2 ? @(bThreadType1to1) : @(bThreadTypePrivateGroup);
    }
    
    if (name) {
        threadModel.name = name;
    }
    
    for (id<PUser> user in usersToAdd) {
        [threadModel addUser:user];
    }
    
    return threadModel;
}

- (NSArray *)threadsWithUsers:(NSArray *)users type:(bThreadType)type {
    NSMutableArray * threads = [NSMutableArray new];

    NSSet * usersSet = [NSSet setWithArray:users];

    for (id<PThread> thread in [BChatSDK.thread threadsWithType:type]) {
        if([usersSet isEqual:thread.users]) {
            [threads addObject:thread];
        }
    }

    return threads;
}

-(RXPromise *) muteThread: (id<PThread>) thread {
    return [RXPromise resolveWithResult:Nil];
}

-(RXPromise *) unmuteThread: (id<PThread>) thread {
    return [RXPromise resolveWithResult:Nil];
}

-(BOOL) canMuteThreads {
    return false;
}

-(RXPromise *) replyToMessage: (id<PMessage>) message withThreadID: (NSString *) threadEntityID reply: (NSString *) reply {
    
    BMessageBuilder * builder = [[BMessageBuilder textMessage: message.isReply ? message.reply : @""] thread:threadEntityID];
    
    if (!message.isReply) {
        NSMutableDictionary * meta = [NSMutableDictionary dictionaryWithDictionary:message.meta];
        meta[bId] = message.entityID;
        meta[bType] = message.type;
        [builder meta: meta];
    }
    
    id<PMessage> newMessage = [builder build];
    [newMessage setMetaValue:reply forKey:bReplyKey];
    
    return [self sendMessage:newMessage];
}

-(RXPromise *) forwardMessage: (id<PMessage>) message toThreadWithID: (NSString *) threadEntityID {
    id<PMessage> newMessage = [[[[BMessageBuilder withType:message.type.intValue] meta:message.meta] thread:threadEntityID] build];
    return [self sendMessage:newMessage];
}

-(void) reconnect {
    
}

-(BOOL) rolesEnabled: (NSString *) threadEntityID {
    return false;
}

-(BOOL) canChangeRole: (NSString *) threadEntityID forUser: (NSString *) userEntityID {
    return false;
}

-(nonnull NSString *) role: (NSString *) threadEntityID forUser: (NSString *) userEntityID {
    return @"";
}

-(nonnull RXPromise *) setRole: (NSString *) role forThread: (NSString *) threadEntityID forUser: (NSString *) userEntityID {
    return [RXPromise rejectWithReason:nil];
}

-(nonnull NSArray<NSString *> *) availableRoles: (NSString *) threadEntityID forUser: (NSString *) userEntityID {
    return @[];
}

-(BOOL) canChangeVoice: (NSString *) threadEntityID forUser: (NSString *) userEntityID {
    return false;
}

-(BOOL) hasVoice: (NSString *) threadEntityID forUser: (NSString *) userEntityID {
    return true;
}

-(nonnull RXPromise *) grantVoice: (NSString *) threadEntityID forUser: (NSString *) userEntityID {
    return [RXPromise rejectWithReason:nil];
}

-(nonnull RXPromise *) revokeVoice: (NSString *) threadEntityID forUser: (NSString *) userEntityID {
    return [RXPromise rejectWithReason:nil];
}

-(BOOL) canChangeModerator: (NSString *) threadEntityID forUser: (NSString *) userEntityID {
    return false;
}

-(BOOL) isModerator: (NSString *) threadEntityID forUser: (NSString *) userEntityID {
    return false;
}

-(nonnull RXPromise *) grantModerator: (NSString *) threadEntityID forUser: (NSString *) userEntityID {
    return [RXPromise rejectWithReason:nil];
}

-(nonnull RXPromise *) revokeModerator: (NSString *) threadEntityID forUser: (NSString *) userEntityID {
    return [RXPromise rejectWithReason:nil];
}

-(BOOL) canDelete: (NSString *) threadEntityID {
    return false;
}

-(BOOL) canDestroyThread: (nonnull NSString *) threadEntityID {
    return false;
}

@end
