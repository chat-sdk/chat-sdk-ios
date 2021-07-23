//
//  CCThread.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 10/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import "CCThreadWrapper.h"

#import <ChatSDKFirebase/FirebaseAdapter.h>
#import <ChatSDK/Core.h>

@implementation CCThreadWrapper

+(CCThreadWrapper *) threadWithModel: (id<PThread>) model {
    return [[self alloc] initWithModel:model];
}

-(CCThreadWrapper *) initWithModel: (id<PThread>) model {
    if((self = [self init])) {
        _model = model;
    }
    return self;
}

+(id) threadWithEntityID: (NSString *) entityID {
    return [[self alloc] initWithEntityID:entityID];
}

-(id) initWithEntityID: (NSString *) entityID {
    if((self = [self init])) {
        // Get or create the model
        _model = [BChatSDK.db fetchOrCreateEntityWithID:entityID withType:bThreadEntity];
    }
    return self;
}

-(RXPromise *) on {
    
    RXPromise * promise = [RXPromise new];

    if (((NSManagedObject *)_model).on) {
        [promise resolveWithResult:self];
        return promise;
    }
    ((NSManagedObject *)_model).on = YES;
    
    // Get the thread data
    FIRDatabaseReference * threadMetaRef = [[FIRDatabaseReference threadRef:self.entityID] child:bMetaPath];
    
    [threadMetaRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
        if (![snapshot.value isEqual: [NSNull null]]) {
            // Update the thread
            [self deserialize:snapshot.value];
            [promise resolveWithResult:self];

        }
        else {
            [promise rejectWithReason:Nil];
        }
    }];
    
    if(BChatSDK.typingIndicator) {
        [BChatSDK.typingIndicator typingOn: self.model];
    }
    
    return promise;
}

-(void) off {
    
    ((NSManagedObject *)_model).on = NO;
    
    FIRDatabaseReference * threadDetailsRef = [[FIRDatabaseReference threadRef:self.entityID] child:bMetaPath];
    [threadDetailsRef removeAllObservers];
    
    [self messagesOff];
    [self usersOff];
    
    if(BChatSDK.typingIndicator) {
        [BChatSDK.typingIndicator typingOff: self.model];
    }
}

// TODO: Remove promise maybe
-(RXPromise *) messagesOn {

    if(BChatSDK.readReceipt) {
        [BChatSDK.readReceipt updateReadReceiptsForThread:self.model];
    }
    
    RXPromise * promise = [RXPromise new];

    if (((NSManagedObject *)_model).messagesOn) {
        [promise resolveWithResult:self];
        return promise;
    }
    ((NSManagedObject *)_model).messagesOn = YES;
    
    return [self threadDeletedDate].thenOnMain(^id(NSDate * deletedDate) {

        FIRDatabaseQuery * query = [FIRDatabaseReference threadMessagesRef:self.model.entityID];
        
        // Get the last message from the thread
        NSArray * messages = self.model.messagesOrderedByDateDesc;
        
        // Start date - the date we'll start retrieving messages
        NSDate * startDate = Nil;
        
        // If there are messages we only fetch messages since the
        // last message
        if (messages.count) {
            startDate = ((id<PMessage>)messages.firstObject).date;
        }
        
        // If thread is deleted
        if (deletedDate) {
            startDate = deletedDate;
            _model.deletedDate = deletedDate;
        }
        
        // Listen for new messages
        startDate = [startDate dateByAddingTimeInterval:1];
        
        // Convert the start date to a Firebase timestamp
        query = [query queryOrderedByChild:bDate];
        if (startDate) {
            query = [query queryStartingAtValue:[BFirebaseCoreHandler dateToTimestamp:startDate] childKey:bDate];
        } else {
            // Limit to 50 messages just to be safe - on a busy public thread we wouldn't want to
            // download 50k messages!
            query = [query queryLimitedToLast:BChatSDK.config.messageHistoryDownloadLimit];
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [query observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * snapshot) {

                if (![snapshot.value isEqual: [NSNull null]]) {
                    
                    if(BChatSDK.blocking) {
                        if([BChatSDK.blocking isBlocked:snapshot.value[bUserFirebaseID]]) {
                            return;
                        }
                    }
                    
                    if (self.model.deletedDate) {
                        [self.model setDeletedDate: Nil];
                        [BHookNotification notificationThreadAdded:self.model];
                    }
                    
                    // This gets the message if it exists and then updates it from the snapshot
                    CCMessageWrapper * message = [CCMessageWrapper messageWithSnapshot:snapshot];
                    
                    
                    BOOL newMessage = message.model.isDelivered == NO;
                    
                    // Is this a new message?
                    // When a message arrives we add it to the database
                    //newMessage = [BChatSDK.db fetchEntityWithID:snapshot.key withType:bMessageEntity] == Nil;
                    
                    // Mark the message as delivered
                    [message.model setDelivered: @YES];
                    
                    // Add the message to this thread;
                    [self.model addMessage:message.model];
                    
                    NSLog(@"Message: %@", message.model.text);
                    
                    [BChatSDK.core save];

                    if (newMessage) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [BHookNotification notificationMessageReceived: message.model];
                        });
                    }
                    
                    // Mark the message as received
                    [message markAsReceived];
                    
                    if(BChatSDK.readReceipt) {
                        [BChatSDK.readReceipt updateReadReceiptsForThread:self.model];
                    }
                    
                    [promise resolveWithResult:self];
                }
                else {
                    [promise rejectWithReason:Nil];
                }
            }];
        });
                
        // For Android we fixed this issue by counting back the messages in the thread
        // TODO: Fix this
        
        if (BChatSDK.config.messageDeletionEnabled) {
            query = [FIRDatabaseReference threadMessagesRef:self.model.entityID];
    //        [query queryOrderedByChild:bDate];
            
            // Only add deletion handlers to the last 100 messages
    //        query = [query queryLimitedToLast:BChatSDK.config.messageDeletionListenerLimit];
            
            // This will potentially delete all the messages
            [query observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * snapshot) {
//                NSLog(@"Message deleted: %@", snapshot.value);
                CCMessageWrapper * wrapper = [CCMessageWrapper messageWithSnapshot:snapshot];
                id<PMessage> message = wrapper.model;
                NSString * entityID = message.entityID;
                [BHookNotification notificationMessageWillBeDeleted: message];
                [self.model removeMessage: message];
                [BHookNotification notificationMessageWasDeleted:entityID];
            }];
        }

        return promise;
        
    }, Nil);
}

-(void) messagesOff {
    
    ((NSManagedObject *)_model).messagesOn = NO;
    
    FIRDatabaseReference * ref = [FIRDatabaseReference threadMessagesRef:_model.entityID];
    [ref removeAllObservers];
}

-(void) usersOn {
    
    if ([((NSManagedObject *)_model) pathOn:bUsersPath]) {
        return;
    }
    [((NSManagedObject *)_model) setPath:bUsersPath on:YES];
    
    // Get the thread data
    FIRDatabaseReference * threadUsersRef = [FIRDatabaseReference threadUsersRef:self.entityID];
    
    [threadUsersRef observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * snapshot) {
        if (![snapshot.value isEqual: [NSNull null]]) {
            // Update the thread
            CCUserWrapper * user = [CCUserWrapper userWithSnapshot:snapshot];
            [self.model addUser:user.model];
            [user metaOn];
            [BHookNotification notificationThreadUsersUpdated:self.model];
        }
    }];
    
    [threadUsersRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
        if (![snapshot.value isEqual: [NSNull null]]) {
            for(NSString * userEntityID in [snapshot.value allKeys]) {
                if(snapshot.value[userEntityID][bDeletedKey]) {
                    // Update the thread
                    CCUserWrapper * user = [CCUserWrapper userWithEntityID:userEntityID];
                    if (self.model.type.intValue ^ bThreadType1to1) {
                        [self.model removeUser:user.model];
                        [BHookNotification notificationThreadUsersUpdated:self.model];
                    }
                }
                if ([userEntityID isEqualToString:BChatSDK.currentUserID]) {
                    if ([snapshot.value[userEntityID][bMute] boolValue]) {
                        [self.model setMetaValue:@"" forKey:bMute];
                    } else {
                        [self.model removeMetaValueForKey:bMute];
                    }
                }
            }
        }
    }];
    
    [threadUsersRef observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * snapshot) {
        if (![snapshot.value isEqual: [NSNull null]]) {
            // Update the thread
            CCUserWrapper * user = [CCUserWrapper userWithSnapshot:snapshot];
            [self.model removeUser:user.model];
            [BHookNotification notificationThreadUsersUpdated:self.model];
        }
    }];
}

-(void) usersOff {
    [((NSManagedObject *)_model) setPath:bUsersPath on:NO];
    for(id<PUser> user in _model.users) {
        [[CCUserWrapper userWithModel:user.model] off];
    }
    [[FIRDatabaseReference threadUsersRef:self.entityID] removeAllObservers];
}

/**
 * @brief Get the date when the thread was deleted
 * @return RXPromise On success return the date or Nil if the thread hasn't been deleted
 */
-(RXPromise *) threadDeletedDate {
   
    RXPromise * promise = [RXPromise new];
    
    id<PUser> currentUser = BChatSDK.currentUser;

    FIRDatabaseReference * currentThreadUser = [[FIRDatabaseReference threadUsersRef:self.entityID] child:currentUser.entityID];

    [currentThreadUser observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
        if (![snapshot.value isEqual: [NSNull null]] && snapshot.value[bDeletedKey]) {
            [promise resolveWithResult:[BFirebaseCoreHandler timestampToDate:snapshot.value[bDeletedKey]]];
        }
        else {
            [promise resolveWithResult:Nil];
        }
    }];
    
    return promise;
}

-(RXPromise *) deleteThread {

    if(_model.deletedDate) {
        return [RXPromise resolveWithResult:Nil];
    }

    RXPromise * promise = [RXPromise new];
    
    [BChatSDK.db beginUndoGroup];
    
    [_model setDeletedDate: [NSDate date]];
    
    // Delete all messages
    for(id<PMessage> m in _model.allMessages) {
        [_model removeMessage:m];
    }
    
    [BChatSDK.db endUndoGroup];
    
    id<PUser> currentUser = BChatSDK.currentUser;
    FIRDatabaseReference * currentThreadUser = [[FIRDatabaseReference threadUsersRef:self.entityID] child:currentUser.entityID];
    
    // If this is a private thread with only two users
    // TODO: Consider deleting it for groups and only doing this for 1to1
    if (_model.type.intValue == bThreadType1to1) {
        // Rather than delete the thread we just set the status as deleted
        [currentThreadUser setValue:@{bUserNameKey: currentUser.name, bDeletedKey: [FIRServerValue timestamp]}
                withCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
                    if (!error) {
                        [promise resolveWithResult:Nil];
                    }
                    else {
                        [promise rejectWithReason:error];
                    }
                }];
        
        return promise.thenOnMain(^id(id success) {
              [BChatSDK.db save];
              // We can keep listening to the thread. That way, if a new message comes in,
              // it get's regenerated
              //[self off];
              //[self messagesOff];
                [BHookNotification notificationThreadRemoved:self.model];
            
                  return Nil;
            
              }, ^id(NSError * error) {
                  [BChatSDK.db undo];
                  return error;
              });
    }
    else {
        
        // We still want to notify the user to refresh the view
        [BHookNotification notificationThreadRemoved:_model];
        
        // Otherwise we just remove the user
        return [self removeUser:[CCUserWrapper userWithModel:currentUser]];
    }
}

-(RXPromise *) loadMoreMessagesFromDate: (NSDate *) date count: (int) count {
    
    RXPromise * promise = [RXPromise new];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        FIRDatabaseReference * messagesRef = [FIRDatabaseReference threadMessagesRef:self.entityID];
        
        // Convert the end date to a Firebase timestamp
        FIRDatabaseQuery * query = [messagesRef queryOrderedByChild:bDate];
        NSNumber * timestamp = [BFirebaseCoreHandler dateToTimestamp:date];
        query = [query queryEndingAtValue:@(timestamp.doubleValue - 1) childKey:bDate];
        
        // We add one becase we'll also be returning the last message again
        query = [query queryLimitedToLast:count];
        
        [query observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
            if (![snapshot.value isEqual: [NSNull null]]) {
                
                NSMutableArray * messages = [NSMutableArray new];
                
                // Add the messages to an array - they can come through in any order...
                NSDictionary * dictionary = snapshot.value;
                for (NSString * key in dictionary.allKeys) {
                    // Create the messages with the sub-snapshot
                    CCMessageWrapper * message = [CCMessageWrapper messageWithSnapshot:[snapshot childSnapshotForPath:key]];
                    
                    // If we are loading historic messages, assume they have been delivered
                    [message.model setDelivered: @YES];
                    
                    [messages addObject:message.model];
                }
                
                // Sort the messages into "newest first" order
                [messages sortUsingComparator:[BMessageSorter newestFirst]];

                // Add the messages to the thread
                for (id<PMessage> message in messages) {
                    [self.model addMessage:message toStart:YES];
                }

                [promise resolveWithResult:messages];
            }
            else {
                [promise resolveWithResult:Nil];
            }
        }];
    });
    return promise;
}

//-(NSDictionary *) serialize {
//    return @{bDetailsPath: self.serializeMeta};
//}

-(NSDictionary *) serialize {
    NSMutableDictionary * dict = [NSMutableDictionary new];
    [dict addEntriesFromDictionary:@{bCreationDate: [FIRServerValue timestamp],
                                     bNameKey: [NSString safe:_model.name],
                                     bType: _model.type,
//                                     bImageURL: [NSString safe: [_model.meta valueForKey:bImageURL]],
                                     bCreator: [NSString safe: _model.creator.entityID]}];
    
    return dict;
}

-(void) deserialize: (NSDictionary *) value {
    
    NSNumber * creationDate = value[bCreationDate];
    if (creationDate) {
        _model.creationDate = [BFirebaseCoreHandler timestampToDate:creationDate];
    }
    
    NSNumber * type = value[bType];
    
    if(type) {
        _model.type = type;
    }
    
//    NSString * imageURL = value[bImageURL];
//    if (imageURL) {
//        [_model setMetaValue:imageURL forKey:bImageURL];
//    }

    NSString * creatorEntityID = value[bCreator];
    
    if(creatorEntityID) {
        
        void(^onComplete)(id<PUser> user) = ^void(id<PUser> user) {
            _model.creator = user;
            [BHookNotification notificationThreadUpdated:self.model];
        };
            
        id<PUser> user = [BChatSDK.db fetchEntityWithID:creatorEntityID withType:bUserEntity];
        if (!user) {
            user = [BChatSDK.db fetchOrCreateEntityWithID:creatorEntityID withType:bUserEntity];
            [BChatSDK.core observeUser:user.entityID].thenOnMain(^id(id success) {
                onComplete(user);
                return success;
            }, Nil);
        } else {
            onComplete(user);
        }
    }
    
    NSString * name = value[bUserNameKey];
    if (name) {
        _model.name = name;
    }
    
    // Meta data
    NSMutableDictionary * meta = [NSMutableDictionary dictionaryWithDictionary:value];
    NSDictionary * details = [self serialize];
    
    for (NSString * key in details.allKeys) {
        [meta removeObjectForKey:key];
    }
    
    [_model setMeta:meta];
    
}

-(RXPromise *) push {
    RXPromise * promise = [RXPromise new];
    
    if(!_model.entityID || !_model.entityID.length) {
        _model.entityID = [[FIRDatabaseReference threadsRef] childByAutoId].key;
    }
    
    FIRDatabaseReference * metaRef = [FIRDatabaseReference threadMetaRef:_model.entityID];

    // Also update the meta ref - we do this for forwards compatibility
    // in the future we will move everything to the meta area
    [metaRef updateChildValues:self.serialize withCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
           if (!error) {
               [promise resolveWithResult:self.model];
           }
           else {
               [promise rejectWithReason:error];
           }
       }];
    
    return promise;
}

-(RXPromise *) addUserWithEntityID: (NSString *) entityID {
    
    FIRDatabaseReference * threadUsersRef = [[FIRDatabaseReference threadUsersRef:_model.entityID] child:entityID];
    
    NSString * status = [self.model.creator.entityID isEqualToString:entityID] ? bStatusOwner : bStatusMember;
    RXPromise * promise = [self setThreadPropertyForUser:entityID key:bStatus value:status];
    
//    // When we disconnect, we leave all our public threads
    if (_model.type.intValue & bThreadFilterPublic && !BChatSDK.config.publicChatAutoSubscriptionEnabled) {
        [threadUsersRef onDisconnectRemoveValue];
    }
    
    return promise;
}

-(RXPromise *) setThreadPropertyForUser: (NSString *) entityID key: (NSString *) key value: (NSString *) value {
        FIRDatabaseReference * threadUsersRef = [[FIRDatabaseReference threadUsersRef:_model.entityID] child:entityID];
        
        RXPromise * promise = [RXPromise new];
        
        [threadUsersRef updateChildValues:@{key: value} withCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
            if (!error) {
                [BEntity pushThreadUsersUpdated:self.model.entityID];
                [promise resolveWithResult:self];
            }
            else {
                [promise rejectWithReason:error];
            }
        }];
                
        return promise;
}

-(RXPromise *) removeUserWithEntityID: (NSString *) entityID {
    FIRDatabaseReference * threadUsersRef = [[FIRDatabaseReference threadUsersRef:_model.entityID] child:entityID];
    
    RXPromise * promise = [RXPromise new];
    // Add the user entities to the thread too
    [threadUsersRef removeValueWithCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
        if (!error) {
            [BEntity pushThreadUsersUpdated:self.model.entityID];
            [promise resolveWithResult:self];
        }
        else {
            [promise rejectWithReason:error];
        }
    }];

    return promise;
}

-(RXPromise *) setMuted: (BOOL) muted {
    return [self setThreadPropertyForUser:BChatSDK.currentUserID key:bMute value:@(muted)];
}

-(RXPromise *) removeUser: (CCUserWrapper *) user {
    return [self removeUserWithEntityID:user.entityID].thenOnMain(^id(id success)
    {
        // We only add the thread to the user if it's a private thread
        if (_model.type.intValue & bThreadFilterPrivate) {
            return [user removeThreadWithEntityID:self.entityID];
        }
        else {
            return success;
        }
    }, Nil);
    
}

-(RXPromise *) addUser: (CCUserWrapper *) user {
    return [self addUserWithEntityID:user.entityID].thenOnMain(^id(id success)
    {
        // We only add the thread to the user if it's a private thread
        if (_model.type.intValue & bThreadFilterPrivate) {
            return [user addThreadWithEntityID:self.entityID];
        }
        else {
            return success;
        }
    }, Nil);
}

#pragma EntityWrapper protocol

-(id<PThread>) model {
    return _model;
}

-(NSString *) entityID {
    return [self model].entityID;
}

-(void) removeUserOnDisconnect: (NSString *) entityID {
    FIRDatabaseReference * threadUsersRef = [[FIRDatabaseReference threadUsersRef:_model.entityID] child:entityID];
    [threadUsersRef onDisconnectRemoveValue];
}

-(void) markRead {
    [_model markRead];
}

@end
