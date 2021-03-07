//
//  BFirebaseThreadHandler.m
//  AFNetworking
//
//  Created by ben3 on 06/07/2020.
//

#import "BFirebaseThreadHandler.h"
#import <ChatSDKFirebase/FirebaseAdapter.h>

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
        CCThreadWrapper * thread = [CCThreadWrapper threadWithModel:threadModel];
        
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

-(RXPromise *) addUsers: (NSArray *) users toThread: (id<PThread>) threadModel {
    
    CCThreadWrapper * thread = [CCThreadWrapper threadWithModel:threadModel];
    
    NSMutableArray * promises = [NSMutableArray new];
    
    // Push each user to make sure they have an account
    for (id<PUser> userModel in users) {
        [promises addObject:[thread addUser:[CCUserWrapper userWithModel:userModel]]];
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
            CCThreadWrapper * threadWrapper = [CCThreadWrapper threadWithModel:thread];
            
            NSMutableArray * promises = [NSMutableArray new];
            
            // Push each user to make sure they have an account
            for (NSString * userEntityID in userEntityIDs) {
                id<PUser> user = [BChatSDK.db fetchEntityWithID:userEntityID withType:bUserEntity];
                if (user) {
                    [promises addObject:[threadWrapper removeUser:[CCUserWrapper userWithModel:user]]];
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
            return [[CCThreadWrapper threadWithModel:threadModel] loadMoreMessagesFromDate:finalFromDate count:messagesToLoad - localMessageCount].then(^id(NSArray * remoteMessages) {
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
    return [[CCThreadWrapper threadWithModel:thread] deleteThread];
}

-(RXPromise *) sendMessage: (id<PMessage>) messageModel {

    [BHookNotification notificationMessageWillSend:messageModel];

    // Create the new CCMessage wrapper
    [BHookNotification notificationMessageSending:messageModel];
    return [[CCMessageWrapper messageWithModel:messageModel] send].thenOnMain(^id(id success) {
        
        // Send a push notification for the message
        NSDictionary * pushData = [BChatSDK.push pushDataForMessage:messageModel];
        [BChatSDK.push sendPushNotification:pushData];
        
        [BHookNotification notificationMessageDidSend:messageModel];
        return success;
    }, Nil);
    
}

-(RXPromise *) muteThread: (id<PThread>) thread {
    return [[CCThreadWrapper threadWithModel:thread] setMuted:YES];
}

-(RXPromise *) unmuteThread: (id<PThread>) thread {
    return [[CCThreadWrapper threadWithModel:thread] setMuted:NO];
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
    return [[CCMessageWrapper messageWithModel:message] delete];
}

-(BOOL) canDeleteMessage: (id<PMessage>) message {
    return message.senderIsMe;
}

@end
