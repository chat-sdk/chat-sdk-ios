//
//  BFirebaseReadReceiptHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/12/2016.
//
//

#import "BFirebaseReadReceiptHandler.h"

#import <ChatSDK/Core.h>
#import <ChatSDKFirebase/FirebaseAdapter.h>
#import <ChatSDKFirebase/ChatSDKFirebase-Swift.h>

// How old does a message have to be before we stop adding the
// read receipt listener
#define bReadPath @"read"

@implementation BFirebaseReadReceiptHandler

-(instancetype) init {
    if((self = [super init])) {

        [BChatSDK.hook addHook:[BHook hookOnMain:^(NSDictionary * result){
            NSArray * threads = [BChatSDK.thread threadsWithType:bThreadFilterPrivate];
            for (id<PThread> thread in threads) {
                [self updateReadReceiptsForThread:thread];
            }
        }] withName:bHookDidAuthenticate];

        [BChatSDK.hook addHook:[BHook hookOnMain:^(NSDictionary * result){
            id<PMessage> message = result[bHook_PMessage];
            if (message) {
                [self updateReadReceiptsForMessage:message];
            }
        }] withNames:@[bHookMessageRecieved, bHookMessageDidSend]];
        
    }
    return self;
}

-(void) updateReadReceiptsForThread: (id<PThread>) thread {
    if (!(thread.type.intValue & bThreadFilterPrivate)) {
        return;
    }
    for (id<PMessage> message in thread.messagesOrderedByDateAsc) {
        [self updateReadReceiptsForMessage:message];
    }
}

-(void) updateReadReceiptsForMessage: (id<PMessage>) message {
    if (message.senderIsMe) {
        if ([self shouldListenToReadReceipt:message]) {
            [self messageReadReceiptsOn:message];
        }
        else {
            [self messageReadReceiptsOff: message];
        }
    }
}

-(void) markRead: (id<PThread>) thread {
    [BChatSDK.db unreadMessages:thread.entityID then:^(NSArray * messages) {
        if (messages) {
            for (id<PMessage> message in messages) {
                [self markMessageRead:message];
            }
        }
        [thread markRead];
    }];
    
//    for(id<PMessage> message in thread.messagesOrderedByDateNewestFirst) {
//        [self markMessageRead: message];
//    }
//    [thread markRead];
}


- (void)setAutoSendReadReceipt:(BOOL)autoSend {

}


-(void) markMessageRead: (id<PMessage>) message {
    if ([self shouldMarkReadReceipt:message]) {
        CCMessageWrapper * wrapper = [FirebaseNetworkAdapterModule.shared.firebaseProvider messageWrapperWithModel:message];
        [wrapper setReadStatus: bMessageReadStatusRead];
    }
}

-(BOOL) shouldListenToReadReceipt: (id<PMessage>) message {
    return message.senderIsMe && [self readReceiptEnabledForMessage:message];
}

-(BOOL) shouldMarkReadReceipt: (id<PMessage>) message {
    return !message.senderIsMe && [self readReceiptEnabledForMessage:message];
}

-(BOOL) readReceiptEnabledForMessage: (id<PMessage>) message {
    BOOL enabled = [self readReceiptEnabledForThread:message.thread] && [message.date timeIntervalSinceNow] < BChatSDK.config.readReceiptMaxAgeInSeconds;
    if (enabled) {
//        int readStatus = [message messageReadStatus];
        int readStatus = [message readStatusForUserID:BChatSDK.currentUserID];
        return readStatus != bMessageReadStatusRead;
    }
    return NO;
}

-(BOOL) readReceiptEnabledForThread: (id<PThread>) thread {
    return thread.type.intValue & bThreadFilterPrivate;
}

-(void) messageReadReceiptsOn: (id<PMessage>) message {
    
    if (((NSManagedObject *) message).on) {
        return;
    }
    
    ((NSManagedObject *) message).on = YES;
    
    [[self messageReadRef: message] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
        if (![snapshot.value isEqual: [NSNull null]]) {
            [message setReadStatus:snapshot.value];
            if (message.messageReadStatus != bMessageReadStatusNone) {
                [BHookNotification notificationMessageReadReceiptUpdated:message];
            }
        }
    }];
}

-(void) messageReadReceiptsOff:(id<PMessage>) message {
    [[self messageReadRef: message] removeAllObservers];
    ((NSManagedObject *) message).on = NO;
}

-(FIRDatabaseReference *) messageReadRef: (id<PMessage>) message {
    return [[[FirebaseNetworkAdapterModule.shared.firebaseProvider messageWrapperWithModel:message] ref] child:bReadPath];
}



@end
