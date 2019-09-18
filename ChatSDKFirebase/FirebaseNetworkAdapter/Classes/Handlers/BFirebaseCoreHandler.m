//
//  BFirebaseMessagingHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BFirebaseCoreHandler.h"

#import <ChatSDKFirebase/FirebaseAdapter.h>

@implementation BFirebaseCoreHandler

-(RXPromise *) pushUser {
    [self save];
    if(self.currentUser && self.currentUser.entityID) {
        return [self.currentUser push];
    }
    else return [RXPromise rejectWithReason:Nil];
}

-(void) setUserOnline {
    [super setUserOnline];
    id<PUser> user = self.currentUserModel;
    if(!user || !user.entityID) {
        return;
    }
    [[CCUserWrapper userWithModel:user] goOnline];
}

-(void) setUserOffline {
    [super setUserOffline];
    id<PUser> user = self.currentUserModel;
    if(!user || !user.entityID) {
        return;
    }

    [BHookNotification notificationUserWillDisconnect];
    
    [[CCUserWrapper userWithModel:user] goOffline];
}
-(void) goOnline {
    [FIRDatabaseReference goOnline];
    if (self.currentUserModel) {
        [self setUserOnline];
    }
}

-(void) goOffline {
    [FIRDatabaseReference goOffline];
}


-(RXPromise *)observeUser: (NSString *)entityID {
    id<PUser> userModel = [BChatSDK.db fetchOrCreateEntityWithID:entityID withType:bUserEntity];
    [[CCUserWrapper userWithModel:userModel] onlineOn];
    return [[CCUserWrapper userWithModel:userModel] metaOn];
}

-(RXPromise *) createThreadWithUsers: (NSArray *) users
                                name: (NSString *) name
                                type: (bThreadType) type
                         forceCreate: (BOOL) force
                       threadCreated: (void(^)(NSError * error, id<PThread> thread)) threadCreated {
    
    id<PThread> threadModel = [self fetchThreadWithUsers: users];
    if (threadModel && threadCreated != Nil && !force) {
        threadCreated(Nil, threadModel);
        return [RXPromise resolveWithResult:Nil];
    }
    else {
        threadModel = [self createThreadWithUsers:users name:name type: type];
        CCThreadWrapper * thread = [CCThreadWrapper threadWithModel:threadModel];
        
        return [thread push].thenOnMain(^id(id<PThread> thread) {
                        
            // Add the users to the thread
            if (threadCreated != Nil) {
                threadCreated(Nil, thread);
            }
            return [self addUsers:threadModel.users.allObjects toThread:threadModel];
            
        },^id(NSError * error) {
            //[BChatSDK.db undo];
            
            if (threadCreated != Nil) {
                threadCreated(error, Nil);
            }
            return error;
        });
    }
}

-(RXPromise *) updateThread: (id<PThread>) threadModel dataPushed: (void(^)(NSError * error, id<PThread> thread)) dataPushed {
    CCThreadWrapper * thread = [CCThreadWrapper threadWithModel:threadModel];
    
    return [thread push].thenOnMain(^id(id<PThread> thread) {
        
        if (dataPushed != Nil) {
            dataPushed(Nil, thread);
        }
    },^id(NSError * error) {
        //[BChatSDK.db undo];
        
        if (dataPushed != Nil) {
            dataPushed(error, Nil);
        }
        return error;
    });
    
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

-(RXPromise *) removeUsers: (NSArray *) users fromThread: (id<PThread>) threadModel {
    
    CCThreadWrapper * thread = [CCThreadWrapper threadWithModel:threadModel];
    
    NSMutableArray * promises = [NSMutableArray new];
    
    // Push each user to make sure they have an account
    for (id<PUser> userModel in users) {
        [promises addObject:[thread removeUser:[CCUserWrapper userWithModel:userModel]]];
    }
    
    return [RXPromise all: promises];
    
}

-(RXPromise *) loadMoreMessagesFromDate:(NSDate *)date forThread:(id<PThread>)threadModel fromServer:(BOOL)fromServer {
    return [super loadMoreMessagesFromDate:date forThread:threadModel fromServer:fromServer].then(^id(NSArray * messages) {
        
        int messagesToLoad = BChatSDK.config.messagesToLoadPerBatch;
        int localMessageCount = messages.count;
        
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

#pragma Private methods

-(CCUserWrapper *) currentUser {
    return [CCUserWrapper userWithModel:self.currentUserModel];
}

#pragma Static methods

+(NSDate *) timestampToDate:(NSNumber *)timestamp {
    return [NSDate dateWithTimeIntervalSince1970:timestamp.doubleValue / 1000];
}

+(NSNumber *) dateToTimestamp:(NSDate *)date {
    return @((double)date.timeIntervalSince1970 * 1000);
}


@end
