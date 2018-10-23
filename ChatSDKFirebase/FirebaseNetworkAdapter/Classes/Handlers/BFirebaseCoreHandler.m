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
    id<PUser> user = self.currentUserModel;
    if(!user || !user.entityID) {
        return;
    }
    [[CCUserWrapper userWithModel:user] goOnline];
}

-(void) setUserOffline {
    id<PUser> user = self.currentUserModel;
    if(!user || !user.entityID) {
        return;
    }
    [[CCUserWrapper userWithModel:user] goOffline];
}
-(void) goOnline {
    [super goOnline];
    [FIRDatabaseReference goOnline];
    if (self.currentUserModel) {
        [self setUserOnline];
    }
}

-(void) goOffline {
    [FIRDatabaseReference goOffline];
}

-(void)observeUser: (NSString *)entityID {
    id<PUser> contactModel = [BChatSDK.db fetchOrCreateEntityWithID:entityID withType:bUserEntity];
    [[CCUserWrapper userWithModel:contactModel] metaOn];
    [[CCUserWrapper userWithModel:contactModel] onlineOn];
}

-(RXPromise *) createThreadWithUsers: (NSArray *) users name: (NSString *) name threadCreated: (void(^)(NSError * error, id<PThread> thread)) threadCreated {
    
    id<PThread> threadModel = [self fetchThreadWithUsers: users];
    if (threadModel && threadCreated != Nil) {
        threadCreated(Nil, threadModel);
        return [RXPromise resolveWithResult:Nil];
    }
    else {
        threadModel = [self createThreadWithUsers:users name:name];
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

-(RXPromise *) createThreadWithUsers: (NSArray *) users threadCreated: (void(^)(NSError * error, id<PThread> thread)) threadCreated {
    return [self createThreadWithUsers:users name:nil threadCreated:threadCreated];
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

-(RXPromise *) loadMoreMessagesForThread: (id<PThread>) threadModel {
    CCThreadWrapper * thread = [CCThreadWrapper threadWithModel:threadModel];
    return [thread loadMoreMessages: 30];
}

-(RXPromise *) deleteThread: (id<PThread>) thread {
    return [[CCThreadWrapper threadWithModel:thread] deleteThread];
}

// TODO: Implement this
-(RXPromise *) leaveThread: (id<PThread>) thread {
    return Nil;
}

-(RXPromise *) joinThread: (id<PThread>) thread {
    return Nil;
}

-(RXPromise *) sendMessage: (id<PMessage>) messageModel {
    
    if(BChatSDK.encryption) {
        [BChatSDK.encryption encryptMessage:messageModel];
    }

    // Send a push notification for the message
    [BChatSDK.push pushForMessage:messageModel];

    // Create the new CCMessage wrapper
    return [[CCMessageWrapper messageWithModel:messageModel] send].thenOnMain(^id(id success) {
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
