//
//  BFirebaseModerationHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BFirebaseModerationHandler.h"

#import <RXPromise/RXPromise.h>

#import <ChatSDK/PMessage.h>
#import <ChatSDK/BStorageManager.h>
#import <ChatSDK/CCMessageWrapper.h>

@implementation BFirebaseModerationHandler

// TODO: Should we move these out of the message wrapper?
- (RXPromise *) flagMessage: (NSString *)messageID {
    id<PMessage> message = [[BStorageManager sharedManager].a fetchOrCreateEntityWithID:messageID withType:bMessageEntity];
    return [[CCMessageWrapper messageWithModel:message] flag];
}

- (RXPromise *) unflagMessage: (NSString *)messageID {
    id<PMessage> message = [[BStorageManager sharedManager].a fetchOrCreateEntityWithID:messageID withType:bMessageEntity];
    return [[CCMessageWrapper messageWithModel:message] unflag];
}

@end
