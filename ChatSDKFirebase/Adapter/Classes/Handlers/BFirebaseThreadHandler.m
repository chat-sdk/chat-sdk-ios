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
        CCThreadWrapper * thread = [FirebaseNetworkAdapterModule.shared.firebaseProvider threadWrapperWithModel: threadModel];
        
        if (entityID) {
            threadModel.entityID = entityID;
        }
        
        __weak __typeof(self) weakSelf = self;

        return [thread push].thenOnMain(^id(id<PThread> thread) {
                        
            // Add the users to the thread
            if (threadCreated != Nil) {
                threadCreated(Nil, thread);
            }
            return [weakSelf addUsers:threadModel.users.allObjects toThread:threadModel];
            
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
-(RXPromise *) setChatState: (bChatState) state forThread: (id<PThread>) thread {
    return Nil;
}

-(RXPromise *) acceptSubscriptionRequestForUser: (id<PUser>) user {
    return Nil;
}

-(RXPromise *) rejectSubscriptionRequestForUser: (id<PUser>) user {
    return Nil;
}

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

@end
