//
//  CCThread.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 10/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import "CCThreadWrapper.h"

#import <ChatSDK/FirebaseAdapter.h>

#define bMessageDownloadLimit 50

// How old does a message have to be before we stop adding the
// read receipt listener
#define bReadReceiptMaxAge 7.0 * bDays

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
        _model = [[BStorageManager sharedManager].a fetchOrCreateEntityWithID:entityID withType:bThreadEntity];
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
    FIRDatabaseReference * threadDetailsRef = [[FIRDatabaseReference threadRef:self.entityID] child:bDetailsPath];
    
    [threadDetailsRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
        if (![snapshot.value isEqual: [NSNull null]]) {
            // Update the thread
            [self deserialize:snapshot.value];
            [promise resolveWithResult:self];
            
            // TODO: Move this to inside the read receipt module
//            if(NM.readReceipt) {
//                [NM.readReceipt updateReadReceiptsForThread:self.model];
//            }

        }
        else {
            [promise rejectWithReason:Nil];
        }
    }];
    
    if(NM.typingIndicator) {
        [NM.typingIndicator typingOn: self.model];
    }
    
    return promise;
}

-(void) off {
    
    ((NSManagedObject *)_model).on = NO;
    
    FIRDatabaseReference * threadDetailsRef = [[FIRDatabaseReference threadRef:self.entityID] child:bDetailsPath];
    [threadDetailsRef removeAllObservers];
    
    [self messagesOff];
    [self usersOff];
    
    if(NM.typingIndicator) {
        [NM.typingIndicator typingOff: self.model];
    }
}

// TODO: Remove promise maybe
-(RXPromise *) messagesOn {
    
    if(NM.readReceipt) {
        [NM.readReceipt updateReadReceiptsForThread:self.model];
    }
    
    RXPromise * promise = [RXPromise new];

    if (((NSManagedObject *)_model).messagesOn) {
        [promise resolveWithResult:self];
        return promise;
    }
    ((NSManagedObject *)_model).messagesOn = YES;
    
    return [self threadDeletedDate].thenOnMain(^id(NSDate * deletedDate) {
        
        FIRDatabaseQuery * query = [FIRDatabaseReference threadMessagesRef:_model.entityID];
        
        // Get the last message from the thread
        NSArray * messages = _model.messagesOrderedByDateDesc;
        
        // Start date - the date we'll start retrieving messages
        NSDate * startDate = Nil;
        
        // If there are messages we only fetch messages since the
        // last message
        if (messages.count) {
            startDate = ((id<PMessage>)messages.firstObject).date;
        }
        else {
            // TODO: Add limit
            startDate = [[NSDate date] dateByAddingTimeInterval:-bDays * 3650];
        }
        
        // If thread is deleted
        if (deletedDate) {
            startDate = deletedDate;
        }
        
        // Listen for new messages
        startDate = [startDate dateByAddingTimeInterval:1];
        
        // #6438 Start bug fix for v3.0.2
        // Convert the start date to a Firebase timestamp
        query = [[query queryOrderedByPriority] queryStartingAtValue:[BFirebaseCoreHandler dateToTimestamp:startDate]];
        
        // Limit to 500 messages just to be safe - on a busy public thread we wouldn't want to
        // download 50k messages!
        query = [query queryLimitedToLast:bMessageDownloadLimit];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [query observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * snapshot) {
                
                if (![snapshot.value isEqual: [NSNull null]]) {
                    
                    if(NM.blocking) {
                        if([NM.blocking isBlocked:snapshot.value[b_UserFirebaseID]]) {
                            return;
                        }
                    }
                    
                    [_model setDeleted: @NO];
                    
                    // This gets the message if it exists and then updates it from the snapshot
                    CCMessageWrapper * message = [CCMessageWrapper messageWithSnapshot:snapshot];
                    
                    [NM.hook executeHookWithName:bHookMessageRecieved data:@{bHookMessageReceived_PMessage: message.model}];
                    
                    BOOL newMessage = message.model.delivered.boolValue == NO;
                    
                    // Is this a new message?
                    // When a message arrives we add it to the database
                    //newMessage = [[BStorageManager sharedManager].a fetchEntityWithID:snapshot.key withType:bMessageEntity] == Nil;
                    
                    // Mark the message as delivered
                    message.model.delivered = @YES;
                    
                    // Add the message to this thread;
                    [self.model addMessage:message.model];
                    
                    [NM.core save];
                    
                    if (newMessage) {
                        // TODO: Maybe change here
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationMessageAdded
                                                                                object:Nil
                                                                              userInfo:@{bNotificationMessageAddedKeyMessage: message.model}];
                            
                            NSLog(@"Message: %@, %@", message.model.textString, message.model.date);
                            
                            if(NM.readReceipt) {
                                [NM.readReceipt updateReadReceiptsForThread:self.model];
                            }
                        });
                    }
                    [promise resolveWithResult:self];
                }
                else {
                    [promise rejectWithReason:Nil];
                }
            }];
        });
        
        [[FIRDatabaseReference threadMessagesRef:_model.entityID] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * snapshot) {
            CCMessageWrapper * wrapper = [CCMessageWrapper messageWithSnapshot:snapshot];
            id<PMessage> message = wrapper.model;
            [self.model removeMessage: message];
            [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationMessageRemoved object:Nil userInfo:@{bNotificationMessageRemovedKeyMessage: wrapper.model}];

        }];
        
        return promise;
        
    }, Nil);
}

-(void) messagesOff {
    
    ((NSManagedObject *)_model).messagesOn = NO;
    
    FIRDatabaseReference * ref = [FIRDatabaseReference threadMessagesRef:_model.entityID];
    [ref removeAllObservers];
}

-(RXPromise *) pushMeta {
    RXPromise * promise = [RXPromise new];
    FIRDatabaseReference * ref = [FIRDatabaseReference threadMetaRef:_model.entityID];
    [ref updateChildValues: [_model metaDictionary] withCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
        if(!error) {
            [promise resolveWithResult:Nil];
        }
        else {
            [promise resolveWithResult:error];
        }
    }];
    return promise;
}

-(void) metaOn {
    if (((NSManagedObject *)_model).metaOn) {
        return;
    }
    ((NSManagedObject *)_model).metaOn = YES;

    FIRDatabaseReference * ref = [FIRDatabaseReference threadMetaRef:_model.entityID];
    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
        if(snapshot.value != [NSNull null]) {
            for(NSString * key in snapshot.value) {
                [_model setMetaValue:snapshot.value[key] forKey:key];
                [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationThreadMetaUpdated object:Nil];
            }
        }
    }];
}

-(void) metaOff {
    
    ((NSManagedObject *)_model).metaOn = NO;
    
    FIRDatabaseReference * ref = [FIRDatabaseReference threadMetaRef:_model.entityID];
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
            [_model addUser:user.model];
            [user metaOn];
            [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationThreadUsersUpdated object:Nil];
        }
    }];
    
    [threadUsersRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
        if (![snapshot.value isEqual: [NSNull null]]) {
            for(NSString * userEntityID in [snapshot.value allKeys]) {
                if(snapshot.value[userEntityID][bDeletedKey]) {
                    // Update the thread
                    CCUserWrapper * user = [CCUserWrapper userWithEntityID:userEntityID];
                    if (_model.type.intValue ^ bThreadType1to1) {
                        [_model removeUser:user.model];
                        [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationThreadUsersUpdated object:Nil];
                    }
                }
            }
        }
    }];
    
    [threadUsersRef observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * snapshot) {
        if (![snapshot.value isEqual: [NSNull null]]) {
            // Update the thread
            CCUserWrapper * user = [CCUserWrapper userWithSnapshot:snapshot];
            [_model removeUser:user.model];
            [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationThreadUsersUpdated object:Nil];
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
    
    id<PUser> currentUser = NM.currentUser;

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
    
    RXPromise * promise = [RXPromise new];
    
    [[BStorageManager sharedManager].a beginUndoGroup];
    
    [_model setDeleted: @YES];
    
    // Delete all messages
    for(id<PMessage> m in _model.allMessages) {
        [_model removeMessage:m];
    }
    
    [[BStorageManager sharedManager].a endUndoGroup];
    
    id<PUser> currentUser = NM.currentUser;
    FIRDatabaseReference * currentThreadUser = [[FIRDatabaseReference threadUsersRef:self.entityID] child:currentUser.entityID];
    
    // If this is a private thread with only two users
    // TODO: Consider deleting it for groups and only doing this for 1to1
    if (_model.type.intValue & bThreadFilterPrivate && _model.users.allObjects.count == 2) {
        // Rather than delete the thread we just set the status as deleted
        [currentThreadUser setValue:@{bNameKey: currentUser.name, bDeletedKey: [FIRServerValue timestamp]}
                withCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
                    if (!error) {
                        [promise resolveWithResult:Nil];
                    }
                    else {
                        [promise rejectWithReason:error];
                    }
                }];
        
        return promise.thenOnMain(^id(id success) {
                                      [[BStorageManager sharedManager].a save];
                                      // We can keep listening to the thread. That way, if a new message comes in,
                                      // it get's regenerated
                                      //[self off];
                                      //[self messagesOff];
                                      [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationThreadDeleted object:Nil];
                                      
                                      return Nil;
                                      
                                  }, ^id(NSError * error) {
                                      [[BStorageManager sharedManager].a undo];
                                      return error;
                                  });
    }
    else {
        
        // We still want to notify the user to refresh the view
        [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationThreadDeleted object:Nil];
        
        // Otherwise we just remove the user
        return [self removeUser:[CCUserWrapper userWithModel:currentUser]];
    }
}

-(RXPromise *) loadMoreMessages: (int) numberOfMessages {
    
    NSArray * messages = [_model loadMoreMessages:numberOfMessages];
    
    // All the messages could be loaded from memory
    if(messages.count == numberOfMessages) {
        return [RXPromise resolveWithResult:messages];
    }
    
    RXPromise * promise = [RXPromise new];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Get the earliest message from the database
        id<PMessage> earliestMessage = _model.messagesOrderedByDateAsc.firstObject;
        NSDate * endDate = Nil;
        
        // If we have a message in the database then we use the earliest
        // message's date
        if (earliestMessage) {
            endDate = earliestMessage.date;
        }
        // Otherwise we use todays date
        else {
            endDate = [NSDate date];
        }
        
        FIRDatabaseReference * messagesRef = [[FIRDatabaseReference threadRef:self.entityID] child:bMessagesPath];
        
        // Convert the end date to a Firebase timestamp
        FIRDatabaseQuery * query = [[messagesRef queryOrderedByPriority] queryEndingAtValue:[BFirebaseCoreHandler dateToTimestamp:endDate]];
        
        // We add one becase we'll also be returning the last message again
        query = [query queryLimitedToLast:numberOfMessages + 1];
        
        [query observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
            if (![snapshot.value isEqual: [NSNull null]]) {
                
                NSMutableArray * msgs = [NSMutableArray new];
                NSDictionary * messages = snapshot.value;
                // We'll have an array of messages
                for (NSString * key in messages.allKeys) {
                    // Create the messages with the sub-snapshot
                    CCMessageWrapper * message = [CCMessageWrapper messageWithSnapshot:[snapshot childSnapshotForPath:key]];
                    // Associate the messages with the thread
                    [self.model addMessage:message.model];
                    
                    [msgs addObject:message];
                }
                [promise resolveWithResult:msgs];
            }
            else {
                [promise rejectWithReason:Nil];
            }
            
        }];
        
    });
    return promise;
}

-(RXPromise *) updateLastMessage {
    RXPromise * promise = [RXPromise new];
    
    FIRDatabaseReference *ref = [FIRDatabaseReference threadMessagesRef:self.entityID];
    FIRDatabaseQuery *queryByDate = [[ref queryOrderedByChild:b_Date] queryLimitedToLast:1];
    
    FIRDatabaseHandle handle = [queryByDate observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        if (![snapshot.value isEqual: [NSNull null]]) {
            NSDictionary *messageData = [[CCMessageWrapper messageWithID:snapshot.key] lastMessageData];
            NSLog(@"–––– Received latest message: %@", messageData);
            [self pushLastMessage:messageData].thenOnMain(^id(id result) {
                [promise resolveWithResult:Nil];
                return Nil;
            }, ^id(NSError *error) {
                [promise rejectWithReason:error];
                return Nil;
            });
        }
        else {
            [promise resolveWithResult:Nil];
        }
    }];
    
    return promise.thenOnMain(^id(id result) {
        [ref removeObserverWithHandle:handle];
        return Nil;
    }, ^id(NSError * error) {
        [ref removeObserverWithHandle:handle];
        return Nil;
    });
}

-(NSDictionary *) serialize {
    return @{bDetailsPath: @{b_CreationDate: [FIRServerValue timestamp],
                             b_Name: _model.name ? _model.name : @"",
                             b_Type: _model.type.integerValue & bThreadFilterPrivate ? @(bThreadTypePrivateV3) : @(bThreadTypePublicV3),
                             b_TypeV4: _model.type,
                             b_CreatorEntityID: _model.creator.entityID}};
}

-(void) deserialize: (NSDictionary *) value {
    
    NSNumber * creationDate = value[b_CreationDate];
    if (creationDate) {
        _model.creationDate = [BFirebaseCoreHandler timestampToDate:creationDate];
    }
    
    NSNumber * typev4 = value[b_TypeV4];
    NSNumber * type = value[b_Type];
    
    if(typev4) {
        _model.type = typev4;
    }
    else if (type) {
        _model.type = type.intValue == bThreadTypePrivateV3 ? @(bThreadTypePrivateGroup) : @(bThreadTypePublicGroup);
    }
    
    NSString * creatorEntityID = value[b_CreatorEntityID];
    if(creatorEntityID) {
        _model.creator = [[BStorageManager sharedManager].a fetchEntityWithID:creatorEntityID withType:bUserEntity];
        if(!_model.creator) {
            id<PUser> user = [[BStorageManager sharedManager].a fetchOrCreateEntityWithID:creatorEntityID withType:bUserEntity];
            [[CCUserWrapper userWithModel:user] once].thenOnMain(^id(id success) {
                _model.creator = user;
                [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationMessageUpdated
                                                                    object:Nil
                                                                  userInfo:@{bNotificationMessageUpdatedKeyMessage: self.model}];
                return success;
            }, Nil);
        }
    }
    
    NSString * name = value[b_Name];
    if (name) {
        _model.name = name;
    }
    
}

-(RXPromise *) push {
    RXPromise * promise = [RXPromise new];
    
    FIRDatabaseReference * ref = Nil;
    if(_model.entityID) {
        ref = [FIRDatabaseReference threadRef:_model.entityID];
    }
    else {
        ref = [[FIRDatabaseReference threadsRef] childByAutoId];
        _model.entityID = ref.key;
    }
    
    [ref updateChildValues:self.serialize withCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
        if (!error) {
            [BEntity pushThreadDetailsUpdated:self.model.entityID];
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
    
    RXPromise * promise = [RXPromise new];
    // Add the user entities to the thread too
    // TODO: check this
    NSString * status = [self.model.creator.entityID isEqualToString:entityID] ? bStatusOwner : bStatusMember;
    
    [threadUsersRef setValue:@{b_Status: status} withCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
        if (!error) {
            [BEntity pushThreadUsersUpdated:self.model.entityID];
            [promise resolveWithResult:self];
        }
        else {
            [promise rejectWithReason:error];
        }
    }];
    
//    // When we disconnect, we leave all our public threads
    if (_model.type.intValue & bThreadFilterPublic) {
        [threadUsersRef onDisconnectRemoveValue];
    }
    
    return promise;
}

-(RXPromise *) pushLastMessage: (NSDictionary *) messageData {
    RXPromise * promise = [RXPromise new];
    
    [[[FIRDatabaseReference threadRef:_model.entityID] child:b_LastMessage] setValue:messageData withCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
        if(!error) {
            [promise resolveWithResult:Nil];
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

-(RXPromise *) once {
    
    NSString * token = NM.auth.loginInfo[bTokenKey];
    FIRDatabaseReference * ref = [FIRDatabaseReference threadRef:self.entityID];
    
    return [BCoreUtilities getWithPath:[ref.description stringByAppendingString:@".json"] parameters:@{@"auth": token}].thenOnMain(^id(NSDictionary * response) {
        
        [self deserialize:response];
        
        return self;
    }, Nil);
}

-(void) markRead {
    [_model markRead];
}

@end
