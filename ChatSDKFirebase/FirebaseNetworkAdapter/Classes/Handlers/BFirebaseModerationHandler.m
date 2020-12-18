//
//  BFirebaseModerationHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BFirebaseModerationHandler.h"

#import <ChatSDKFirebase/FirebaseAdapter.h>

@implementation BFirebaseModerationHandler

@synthesize flaggedMessages;

-(void) activate {
    [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * dict) {
        [self on];
    }] withName:bHookDidAuthenticate];
    [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * dict) {
        [self off];
    }] withName:bHookDidLogout];
}

// TODO: Should we move these out of the message wrapper?
- (RXPromise *) flagMessage: (NSString *)messageID {
    id<PMessage> message = [BChatSDK.db fetchOrCreateEntityWithID:messageID withType:bMessageEntity];
    return [[CCMessageWrapper messageWithModel:message] flag];
}

- (RXPromise *) unflagMessage: (NSString *)messageID {
    id<PMessage> message = [BChatSDK.db fetchOrCreateEntityWithID:messageID withType:bMessageEntity];
    return [[CCMessageWrapper messageWithModel:message] unflag];
}

- (void) on {
    [self off];
    flaggedMessages = [[NSMutableArray alloc] init];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self.flaggedRef observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            if (![snapshot.value isEqual: [NSNull null]]) {
                CCMessageWrapper *message = [CCMessageWrapper messageWithID:snapshot.key];
                [weakSelf.flaggedMessages addObject:message.model];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *userInfo = @{bNotificationFlaggedMessageAdded_PMessage: message.model};
                    [nc postNotificationName:bNotificationFlaggedMessageAdded object:Nil userInfo:userInfo];
                });
            }
        }];
        [self.flaggedRef observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            if (![snapshot.value isEqual: [NSNull null]]) {
                NSString * entityID = snapshot.key;
                id<PMessage> msg2remove;
                for (id<PMessage> msg in weakSelf.flaggedMessages) {
                    if (msg.entityID == entityID) {
                        msg2remove = msg;
                        break;
                    }
                }
                NSDictionary * userInfo = Nil;
                if (msg2remove) {
                    [weakSelf.  flaggedMessages removeObject:msg2remove];
                    userInfo = @{bNotificationFlaggedMessageRemoved_PMessage: msg2remove};
                }
                dispatch_async(dispatch_get_main_queue(), ^{
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

-(BOOL) canFlagMessage {
    return YES;
}

@end
