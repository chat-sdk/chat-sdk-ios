//
//  BXMPPChatManager.h
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 29/08/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "XMPPModule.h"
#import <ChatSDKVendor/XMPPFramework.h>

@protocol PThread;
@protocol PUser;
@protocol PMessage;
@class XMPPMessage;
@class IncomingMessageQueue;
@class SilentMessage;

typedef void(^CompletionMessage)(id<PMessage>);


@interface BXMPPChatManager : XMPPModule {
    IncomingMessageQueue * _queue;
}

@property (nonatomic, readwrite) IncomingMessageQueue * queue;
@property (nonatomic, readwrite) NSMutableArray<SilentMessage *> * silentMessages;


//-(void) handleMessage: (XMPPMessage *) message forThread: (id<PThread>) thread fromUser: (id<PUser>) user;
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message;

-(BOOL) processMessage: (XMPPMessage *) message then: (CompletionMessage) completion;
-(BOOL) processMessage: (XMPPMessage *) message isRead:(BOOL) isRead notify: (BOOL) notify then: (CompletionMessage) completion;

@end
