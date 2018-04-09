//
//  BFirebaseModerationHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BFirebaseModerationHandler.h"

#import <ChatSDK/ChatCore.h>
#import "ChatFirebaseAdapter.h"

@implementation BFirebaseModerationHandler

@synthesize flaggedMessages;

// TODO: Should we move these out of the message wrapper?
- (RXPromise *) flagMessage: (NSString *)messageID {
    id<PMessage> message = [[BStorageManager sharedManager].a fetchOrCreateEntityWithID:messageID withType:bMessageEntity];
    return [[CCMessageWrapper messageWithModel:message] flag];
}

- (RXPromise *) unflagMessage: (NSString *)messageID {
    id<PMessage> message = [[BStorageManager sharedManager].a fetchOrCreateEntityWithID:messageID withType:bMessageEntity];
    return [[CCMessageWrapper messageWithModel:message] unflag];
}

- (RXPromise *) deleteMessage: (NSString *)messageID {
    [self unflagMessage:messageID];
    id<PMessage> message = [[BStorageManager sharedManager].a fetchOrCreateEntityWithID:messageID withType:bMessageEntity];
    return [[CCMessageWrapper messageWithModel:message] delete];
}

- (void) on {
    [self off];
    flaggedMessages = [[NSMutableArray alloc] init];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self.flaggedRef observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            if (![snapshot.value isEqual: [NSNull null]]) {
                CCMessageWrapper *message = [CCMessageWrapper messageWithID:snapshot.key];
                [flaggedMessages addObject:message.model];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *userInfo = @{bNotificationFlaggedMessageAddedKeyMessage: message.model};
                    [nc postNotificationName:bNotificationFlaggedMessageAdded object:Nil userInfo:userInfo];
                });
            }
        }];
        [self.flaggedRef observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            if (![snapshot.value isEqual: [NSNull null]]) {
                CCMessageWrapper *message = [CCMessageWrapper messageWithID:snapshot.key];
                id<PMessage> msg2remove;
                for (id<PMessage> msg in flaggedMessages) {
                    if (msg.entityID == message.entityID) {
                        msg2remove = msg;
                        break;
                    }
                }
                [flaggedMessages removeObject:msg2remove];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *userInfo = @{bNotificationFlaggedMessageRemovedKeyMessage: msg2remove};
                    [nc postNotificationName:bNotificationFlaggedMessageRemoved object:Nil userInfo:userInfo];
                });
            }
        }];
    });
}

- (void) off {
    [self.flaggedRef removeAllObservers];
}

- (NSArray<id<PMessage>> *) flaggedMessages {
    return flaggedMessages;
}

- (FIRDatabaseReference *) flaggedRef {
    return [FIRDatabaseReference flaggedMessagesRef];
}

@end
