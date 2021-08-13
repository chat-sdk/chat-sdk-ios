//
//  BXEP0085.h
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 29/08/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ChatSDK/bChatState.h>
#import "XMPPModule.h"

@class XMPPMessage;

@protocol PThread;
@protocol PUser;

@interface BXMPPTypingIndicatorManager: XMPPModule {
    NSMutableDictionary * _typing;
}

-(void) handleMessage: (XMPPMessage *) message forUser: (id<PUser>) user;
-(XMPPMessage *) messageForTypingState: (bChatState) state toThread: (id<PThread>) thread;

@end
