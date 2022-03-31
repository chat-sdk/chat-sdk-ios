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
#import <ChatSDKFirebase/ChatSDKFirebase-Swift.h>

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

-(RXPromise *) doOn {
    
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
            
            [self messagesOn];
            [self usersOn];
            [self permissionsOn];
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

-(RXPromise *) on {
    return [self myPermission].thenOnMain(^id(id success) {
        return [self doOn];
    }, nil);
}

-(void) off {
    
    ((NSManagedObject *)_model).on = NO;
    
    FIRDatabaseReference * threadDetailsRef = [[FIRDatabaseReference threadRef:self.entityID] child:bMetaPath];
    [threadDetailsRef removeAllObservers];
    
    [self messagesOff];
    [self usersOff];
    [self permissionsOff];
    
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
        
        [query keepSynced:NO];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [query observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * snapshot) {

                if (![snapshot.value isEqual: [NSNull null]]) {
                    
                    if(BChatSDK.blocking) {
                        if([BChatSDK.blocking isBlocked:snapshot.value[bFrom]]) {
                            return;
                        }
                    }
                    
                    if (self.model.deletedDate) {
                        [self.model setDeletedDate: Nil];
                        [BHookNotification notificationThreadAdded:self.model];
                    }
                    
                    // If the firebase rules are set up so there is a permission denied error, it can be that
                    // this is called locally before the data has actually been written. If we are sending a message
                    // this can cause an issue because added and then removed callbacks are called immediately afterards
                    // and that messes up the resend functionality. If the message state is sending, we ignore...
                    id<PMessage> message = [BChatSDK.db fetchEntityWithID:snapshot.key withType:bMessageEntity];
                    if (message && message.messageSendStatus == bMessageSendStatusSending ) {
                        return;
                    }
                    
                    // This gets the message if it exists and then updates it from the snapshot
                    CCMessageWrapper * wrapper = [FirebaseNetworkAdapterModule.shared.firebaseProvider messageWrapperWithSnapshot:snapshot];
                    
                    BOOL newMessage = wrapper.model.isDelivered == NO;
                    
                    // Is this a new message?
                    // When a message arrives we add it to the database
                    //newMessage = [BChatSDK.db fetchEntityWithID:snapshot.key withType:bMessageEntity] == Nil;
                    
                    // Mark the message as delivered
                    [wrapper.model setDelivered: @YES];
                    
                    // Add the message to this thread;
                    [self.model addMessage:wrapper.model];
                    
                    NSLog(@"Message: %@", wrapper.model.text);
                    
                    [BChatSDK.core save];

                    if (newMessage) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [BHookNotification notificationMessageReceived: wrapper.model];
                        });
                    }
                    
                    // Mark the message as received
                    [wrapper markAsReceived];
                    
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
                     
            NSDate * date = nil;

            // Get the messages
            int limit = BChatSDK.config.messageDeletionListenerLimit;
            if (limit < 0) {
                [self.model setCanDeleteMessagesFromDate:[NSDate dateWithTimeIntervalSince1970:0]];
            } else {
                query = [query queryOrderedByChild:bDate];

                NSArray<PMessage> * messages = self.model.messagesOrderedByDateNewestFirst;
                id<PMessage> earliestMessage = nil;

                if (messages.count > limit) {
                    earliestMessage = messages[limit];
                } else if (messages.count > 0) {
                    earliestMessage = messages.lastObject;
                }
                
                if (earliestMessage) {
                    date = earliestMessage.date;
                }
                
                if(date) {
                    query = [query queryStartingAtValue:@(date.timeIntervalSince1970 - 1000)];
                    [self.model setCanDeleteMessagesFromDate:date];
                } else {
                    [self.model setCanDeleteMessagesFromDate:[NSDate date]];
                }

            }
                        
            // This will potentially delete all the messages
            [query observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * snapshot) {

                // If the firebase rules are set up so there is a permission denied error, it can be that
                // this is called locally before the data has actually been written. If we are sending a message
                // this can cause an issue because added and then removed callbacks are called immediately afterards
                // and that messes up the resend functionality. If the message state is sending, we ignore...
                id<PMessage> message = [BChatSDK.db fetchEntityWithID:snapshot.key withType:bMessageEntity];
                if (message && message.messageSendStatus == bMessageSendStatusSending) {
                    return;
                }

                [self removeMessage:message];
            }];
        }

        return promise;
        
    }, Nil);
}

-(void) removeMessage: (id<PMessage>) message {
    NSString * entityID = message.entityID;
    [BHookNotification notificationMessageWillBeDeleted: message];
    [self.model removeMessage: message];
    [BHookNotification notificationMessageWasDeleted:entityID];
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
            CCUserWrapper * user = [FirebaseNetworkAdapterModule.shared.firebaseProvider userWrapperWithSnapshot:snapshot];
            [self.model addUser:user.model];
            [user metaOn];
            [BHookNotification notificationThreadUsersUpdated:self.model];
        }
    }];
    
    [threadUsersRef observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * snapshot) {
        if (![snapshot.value isEqual: [NSNull null]]) {
            // Update the thread
            CCUserWrapper * user = [FirebaseNetworkAdapterModule.shared.firebaseProvider userWrapperWithSnapshot:snapshot];
            [self.model removeUser:user.model];
            [BHookNotification notificationThreadUsersUpdated:self.model];
        }
    }];

    [threadUsersRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
        if (![snapshot.value isEqual: [NSNull null]]) {
            for(NSString * userEntityID in [snapshot.value allKeys]) {
                if(snapshot.value[userEntityID][bDeletedKey]) {
                    // Update the thread
                    CCUserWrapper * user = [FirebaseNetworkAdapterModule.shared.firebaseProvider userWrapperWithEntityID:userEntityID];
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
    
}

-(void) usersOff {
    [((NSManagedObject *)_model) setPath:bUsersPath on:NO];
    for(id<PUser> user in _model.users) {
        [[FirebaseNetworkAdapterModule.shared.firebaseProvider userWrapperWithModel:user] off];
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
        return [self removeUser:[FirebaseNetworkAdapterModule.shared.firebaseProvider userWrapperWithModel:currentUser]];
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
                                     bType: _model.type,
                                     bCreator: [NSString safe: _model.creator.entityID]}];

    [dict addEntriesFromDictionary:self.serializeMeta];
    
    return dict;
}

-(NSDictionary *) serializeMeta {
    return @{
      bNameKey: [NSString safe:_model.name],
      bImageURL: [NSString safe: _model.imageURL]
    };
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
    
    NSString * imageURL = value[bImageURL];
    if (imageURL) {
        [_model setMetaValue:imageURL forKey:bImageURL];
    }

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
        if (![key isEqual:bImageURL]) {
            [meta removeObjectForKey:key];
        }
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

-(RXPromise *) pushMeta {
    RXPromise * promise = [RXPromise new];
    
    FIRDatabaseReference * metaRef = [FIRDatabaseReference threadMetaRef:_model.entityID];

    // Also update the meta ref - we do this for forwards compatibility
    // in the future we will move everything to the meta area
    [metaRef updateChildValues:self.serializeMeta withCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
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

-(void) permissionsOn {
    
    if (((NSManagedObject *)_model).permissionsOn) {
        return;
    }
    ((NSManagedObject *)_model).permissionsOn = YES;
    
    void(^block)(FIRDataSnapshot *) = ^(FIRDataSnapshot * snapshot) {
        [BChatSDK.db performOnMain:^{
            id<PUserConnection> connection = [self.model connection:snapshot.key];
            if (connection) {
                if (snapshot.value != [NSNull null]) {
                    connection.role = snapshot.value;
                } else {
                    if (_model.creator.isMe) {
                        connection.role = Permissions.owner;
                    } else {
                        connection.role = Permissions.member;
                    }
                }
                
                if ([snapshot.key isEqual:BChatSDK.currentUserID]) {
                    [self updateListenersForPermission: connection.role];
                }
                
                id<PUser> user = [BChatSDK.db fetchEntityWithID:snapshot.key withType:bUserEntity];
                [BHookNotification notificationThreadUserRoleUpdated:self.model user:user];
            }
        }];

    };

    FIRDatabaseReference * ref = [FIRDatabaseReference threadPermissions:self.entityID];
    [ref observeEventType:FIRDataEventTypeChildAdded withBlock:block];
    [ref observeEventType:FIRDataEventTypeChildChanged withBlock:block];
//    [ref observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * snapshot) {
//        if (snapshot.value != [NSNull null]) {
//
//        } else {
//
//        }
//    }];
}

-(void) updateListenersForPermission: (NSString *) role {
    if ([role isEqual:Permissions.banned]) {
        [self messagesOff];
        if(BChatSDK.typingIndicator) {
            [BChatSDK.typingIndicator typingOff: self.model];
        }
    } else {
        [self messagesOn];
        if(BChatSDK.typingIndicator) {
            [BChatSDK.typingIndicator typingOn: self.model];
        }
    }
}

-(RXPromise *) myPermission {
    RXPromise * promise = [RXPromise new];
    
    NSString * userEntityID = BChatSDK.currentUserID;
    
    FIRDatabaseReference * ref = [[FIRDatabaseReference threadPermissions:self.entityID] child: userEntityID];
    [ref observeSingleEventOfType:FIRDataEventTypeValue withBlock: ^(FIRDataSnapshot * snapshot) {
        [BChatSDK.db performOnMain:^{
            id<PUserConnection> connection = [self.model connection:userEntityID];
            if (snapshot.value == [NSNull null]) {
                connection.role = Permissions.member;
            } else {
                connection.role = snapshot.value;
            }
            [promise resolveWithResult:snapshot.value];
        }];
    }];
    
    return promise;
}

-(RXPromise *) setPermission: (NSString *) userEntityID permission: (NSString *) permission {
    RXPromise * promise = [RXPromise new];
    FIRDatabaseReference * ref = [[FIRDatabaseReference threadPermissions:self.entityID] child: userEntityID];
    [ref setValue:permission withCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
        if (error) {
            [promise rejectWithReason:error];
        } else {
            [promise resolveWithResult:nil];
        }
    }];
    return promise;
}

-(void) permissionsOff {
    ((NSManagedObject *)_model).permissionsOn = NO;
    FIRDatabaseReference * ref = [FIRDatabaseReference threadPermissions:self.entityID];
    [ref removeAllObservers];
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
