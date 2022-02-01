//
//  BFirebaseThreadHandler.m
//  AFNetworking
//
//  Created by ben3 on 06/07/2020.
//

#import "BFirebaseThreadHandler.h"
#import <ChatSDKFirebase/FirebaseAdapter.h>
#import <ChatSDKFirebase/ChatSDKFirebase-Swift.h>

@implementation BFirebaseThreadHandler

-(RXPromise *) createThreadWithUsers: (NSArray *) users
                                name: (NSString *) name
                                type: (bThreadType) type
                            entityID: (NSString *) entityID
                         forceCreate: (BOOL) force
                       threadCreated: (void(^)(NSError * error, id<PThread> thread)) threadCreated {

    id<PThread> threadModel = nil;
    if (entityID) {
        threadModel = [BChatSDK.db fetchEntityWithID:entityID withType:bThreadEntity];
    }
    if (!threadModel) {
        threadModel = [self fetchThreadWithUsers: users];
    }
    
    if (threadModel && !force) {
        if (threadCreated != nil) {
            threadCreated(Nil, threadModel);
        }
        return [RXPromise resolveWithResult:Nil];
    }
    else {
        threadModel = [self createThreadWithUsers:users name:name type: type];
        CCThreadWrapper * wrapper = [FirebaseNetworkAdapterModule.shared.firebaseProvider threadWrapperWithModel: threadModel];
        
        if (entityID) {
            threadModel.entityID = entityID;
        }
        
        __weak __typeof(self) weakSelf = self;

        return [wrapper push].thenOnMain(^id(id<PThread> thread) {
                                    
            // Add the users to the thread
            if (threadCreated != Nil) {
                threadCreated(Nil, thread);
            }
            return [weakSelf addUsers:threadModel.users.allObjects toThread:threadModel].thenOnMain(^id(id success) {
                // Add the owner permission
                return [wrapper setPermission:BChatSDK.currentUserID permission:Permissions.owner];

            }, nil);
            
        },^id(NSError * error) {
            //[BChatSDK.db undo];
            
            if (threadCreated != Nil) {
                threadCreated(error, Nil);
            }
            return error;
        });
    }
}

-(RXPromise *) addUsers: (NSArray<id<PUser>> *) users toThread: (id<PThread>) threadModel {
    
    CCThreadWrapper * thread = [FirebaseNetworkAdapterModule.shared.firebaseProvider threadWrapperWithModel: threadModel];
    
    NSMutableArray * promises = [NSMutableArray new];
    
    // Push each user to make sure they have an account
    for (id<PUser> userModel in users) {
        [promises addObject:[thread addUser:[FirebaseNetworkAdapterModule.shared.firebaseProvider userWrapperWithModel:userModel]]];
    }
    
    return [RXPromise all: promises];
}

-(BOOL) canAddUsers: (NSString *) threadEntityID {
    __block BOOL canAdd = false;
    [BChatSDK.db performOnMainAndWait:^{
        id<PThread> thread = [BChatSDK.db fetchEntityWithID:threadEntityID withType:bThreadEntity];
        canAdd = thread.creator.isMe && [thread typeIs:bThreadFilterGroup];
    }];
    return canAdd;
}

-(RXPromise *) removeUsers:(NSArray<NSString *> *)userEntityIDs fromThread:(NSString *) threadEntityID {
    RXPromise * promise = [RXPromise new];
    [BChatSDK.db performOnMain: ^{

        id<PThread> thread = [BChatSDK.db fetchEntityWithID:threadEntityID withType:bThreadEntity];
        if (thread) {
            CCThreadWrapper * threadWrapper = [FirebaseNetworkAdapterModule.shared.firebaseProvider threadWrapperWithModel: thread];
            
            NSMutableArray * promises = [NSMutableArray new];
            
            // Push each user to make sure they have an account
            for (NSString * userEntityID in userEntityIDs) {
                id<PUser> user = [BChatSDK.db fetchEntityWithID:userEntityID withType:bUserEntity];
                if (user) {
                    [promises addObject:[threadWrapper removeUser:[FirebaseNetworkAdapterModule.shared.firebaseProvider userWrapperWithModel:user]]];
                }
            }
            [promise resolveWithResult:[RXPromise all: promises]];
        } else {
            [promise rejectWithReason:nil];
        }
        
    }];
    return promise;
}

-(BOOL) canRemoveUsers: (NSArray<NSString *> *) userEntityIDs fromThread: (NSString *) threadEntityID {
    __block BOOL canRemove = NO;
    [BChatSDK.db performOnMainAndWait:^{
        id<PThread> thread = [BChatSDK.db fetchEntityWithID:threadEntityID withType:bThreadEntity];
        canRemove = thread.creator.isMe && [thread typeIs:bThreadFilterGroup];
    }];
    return canRemove;
}


-(RXPromise *) loadMoreMessagesFromDate:(NSDate *)date forThread:(id<PThread>)threadModel fromServer:(BOOL)fromServer {
    return [super loadMoreMessagesFromDate:date forThread:threadModel fromServer:fromServer].then(^id(NSArray * messages) {
        
        int messagesToLoad = BChatSDK.config.messagesToLoadPerBatch;
        NSUInteger localMessageCount = messages.count;
        
        if (localMessageCount < messagesToLoad && fromServer) {
            NSDate * finalFromDate = localMessageCount > 0 ? ((id<PMessage>)messages.lastObject).date : date;
            return [[FirebaseNetworkAdapterModule.shared.firebaseProvider threadWrapperWithModel: threadModel] loadMoreMessagesFromDate:finalFromDate count:messagesToLoad - localMessageCount].then(^id(NSArray * remoteMessages) {
                NSMutableArray * mergedMessages = [NSMutableArray arrayWithArray:messages];
                [mergedMessages addObjectsFromArray:remoteMessages];
                return mergedMessages;
            }, Nil);
        } else {
            return messages;
        }
    }, Nil);
}

//-(RXPromise *) loadMoreMessagesForThread: (id<PThread>) threadModel {
//    CCThreadWrapper * thread = [CCThreadWrapper threadWithModel:threadModel];
//    return [thread loadMoreMessages: 30];
//}

-(RXPromise *) deleteThread: (id<PThread>) thread {
    return [[FirebaseNetworkAdapterModule.shared.firebaseProvider threadWrapperWithModel: thread] deleteThread];
}

-(RXPromise *) sendMessage: (id<PMessage>) messageModel {

    [BHookNotification notificationMessageWillSend:messageModel];

    // Create the new CCMessage wrapper
    [BHookNotification notificationMessageSending:messageModel];
    
    [messageModel setMessageSendStatus:bMessageSendStatusSending];
//    [BChatSDK.db save];
    
    return [[FirebaseNetworkAdapterModule.shared.firebaseProvider messageWrapperWithModel:messageModel] send].thenOnMain(^id(id success) {

        [messageModel setMessageSendStatus:bMessageSendStatusSent];

        // Send a push notification for the message
        NSDictionary * pushData = [BChatSDK.push pushDataForMessage:messageModel];
        [BChatSDK.push sendPushNotification:pushData];

        [BHookNotification notificationMessageDidSend:messageModel];
        
        return success;
    }, ^id(NSError * error) {
        [messageModel setMessageSendStatus:bMessageSendStatusFailed];
//        [messageModel setMetaValue:@"Test" forKey:@"Ok"];
        [BHookNotification notificationMessageDidFailToSend:messageModel.entityID error:error];
        return error;
    });
    
}

-(RXPromise *) muteThread: (id<PThread>) thread {
    return [[FirebaseNetworkAdapterModule.shared.firebaseProvider threadWrapperWithModel: thread] setMuted:YES];
}

-(RXPromise *) unmuteThread: (id<PThread>) thread {
    return [[FirebaseNetworkAdapterModule.shared.firebaseProvider threadWrapperWithModel: thread] setMuted:NO];
}

-(BOOL) canMuteThreads {
    return YES;
}

// TODO: Implement these
//-(RXPromise *) setChatState: (bChatState) state forThread: (id<PThread>) thread {
//    return Nil;
//}
//
//-(RXPromise *) acceptSubscriptionRequestForUser: (id<PUser>) user {
//    return Nil;
//}
//
//-(RXPromise *) rejectSubscriptionRequestForUser: (id<PUser>) user {
//    return Nil;
//}

- (RXPromise *) deleteMessage: (NSString *)messageID {
    id<PMessage> message = [BChatSDK.db fetchOrCreateEntityWithID:messageID withType:bMessageEntity];
    return [[FirebaseNetworkAdapterModule.shared.firebaseProvider messageWrapperWithModel:message] delete].thenOnMain(^id(id success) {
        [message.thread removeMessage:message];
        return success;
    },^id(NSError * error) {
//        [message.thread removeMessage:message];
        return error;
    });
}

-(BOOL) canDeleteMessage: (id<PMessage>) message {
    NSDate * date = message.thread.canDeleteMessagesFromDate;
    if (date && message.date.timeIntervalSince1970 >= date.timeIntervalSince1970) {
        return message.senderIsMe;
    }
    return false;
}

#pragma Permissions

-(BOOL) rolesEnabled: (NSString *) threadEntityID {
    __block BOOL enabled = NO;
    [BChatSDK.db performOnMainAndWait:^{
        id<PThread> thread = [BChatSDK.db fetchEntityWithID:threadEntityID withType:bThreadEntity];
        if ([thread typeIs:bThreadFilterGroup]) {
            enabled = YES;
        }
    }];
    return enabled;
}

-(BOOL) canChangeRole: (NSString *) threadEntityID forUser: (NSString *) userEntityID {
    if (![self rolesEnabled:threadEntityID]) {
        return NO;
    }
    NSString * myRole = [self role:threadEntityID forUser:BChatSDK.currentUserID];
    NSString * role = [self role:threadEntityID forUser:userEntityID];

    if ([Permissions levelWithRole:myRole] > [Permissions levelWithRole:role]) {
        return [Permissions isOr:myRole roles:@[Permissions.owner, Permissions.admin]];
    }
    
    return NO;
}

-(nonnull NSString *) role: (NSString *) threadEntityID forUser: (NSString *) userEntityID {
    __block NSString * role = nil;
    [BChatSDK.db performOnMainAndWait:^{
        id<PThread> thread = [BChatSDK.db fetchEntityWithID:threadEntityID withType:bThreadEntity];
        id<PUserConnection> connection = [thread connection:userEntityID];
        if (connection) {
            role = connection.role;
        }
        if (!role) {
            // For backwards compatiblity, if permissions are not set, we assume they are a member
            role = [thread.creator.entityID isEqual:userEntityID] ? Permissions.owner : Permissions.member;
        }
    }];
    return role;
}

-(nonnull RXPromise *) setRole: (NSString *) role forThread: (NSString *) threadEntityID forUser: (NSString *) userEntityID {
    CCThreadWrapper * wrapper = [FirebaseNetworkAdapterModule.shared.firebaseProvider threadWrapperWithEntityID:threadEntityID];
    return [wrapper setPermission:userEntityID permission:role];
}

-(nonnull NSArray<NSString *> *) availableRoles: (NSString *) threadEntityID forUser: (NSString *) userEntityID {
    NSMutableArray * available = [NSMutableArray new];
    NSString * myRole = [self role:threadEntityID forUser:BChatSDK.currentUserID];
    
    for (NSString * role in Permissions.all) {
        if ([Permissions levelWithRole:myRole] > [Permissions levelWithRole:role]) {
            [available addObject:role];
        }
    }
    
    return available;
}

-(BOOL) canChangeVoice: (NSString *) threadEntityID forUser: (NSString *) userEntityID {
    return false;
}

-(BOOL) hasVoice: (NSString *) threadEntityID forUser: (NSString *) userEntityID {
    __block BOOL hasVoice = false;
    [BChatSDK.db performOnMainAndWait:^{
        id<PThread> thread = [BChatSDK.db fetchEntityWithID:threadEntityID withType:bThreadEntity];
        id<PUser> user = [BChatSDK.db fetchEntityWithID:userEntityID withType:bUserEntity];
        if ([thread containsUser:user] || [thread typeIs:bThreadFilterPublic]) {
            NSString * role = [self role:threadEntityID forUser:userEntityID];
            hasVoice = [Permissions isOr:role roles:@[Permissions.owner, Permissions.admin, Permissions.member]];
        }
    }];
    return hasVoice;
}

-(BOOL) canLeaveThread: (id<PThread>) thread {
    if ([thread typeIs:bThreadFilterGroup]) {
        NSString * myRole = [self role:thread forUser:BChatSDK.currentUserID];
        return [Permissions isOr:myRole roles:@[Permissions.owner, Permissions.admin, Permissions.member, Permissions.watcher]];
    }
    return NO;
}

-(BOOL) canJoinThread: (id<PThread>) thread {
    return NO;
}

-(BOOL) canRemoveUser: (NSString *) userEntityID fromThread: (NSString *) threadEntityID {
    __block BOOL canRemove = false;
    [BChatSDK.db performOnMainAndWait:^{
        id<PThread> thread = [BChatSDK.db fetchEntityWithID:threadEntityID withType:bThreadEntity];
        if ([thread typeIs:bThreadTypePrivateGroup]) {
            NSString * myRole = [self role:threadEntityID forUser:BChatSDK.currentUserID];
            NSString * role = [self role:threadEntityID forUser:userEntityID];
            canRemove = [Permissions isOr:myRole roles:@[Permissions.owner, Permissions.admin]] && [Permissions isOr:role roles:@[Permissions.member, Permissions.watcher, Permissions.banned]];
        }
    }];
    return canRemove;
}

@end
