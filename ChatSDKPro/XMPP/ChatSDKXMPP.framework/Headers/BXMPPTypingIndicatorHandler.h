//
//  BXMPPTypingIndicatorHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 21/11/2016.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PTypingIndicatorHandler.h>
#import "XMPPModule.h"

@protocol PThread;
@protocol PUser;
@class XMPPMessage;

@interface BXMPPTypingIndicatorHandler : XMPPModule<PTypingIndicatorHandler> {
    NSMutableDictionary * _typing;
}

//-(void) handleMessage: (XMPPMessage *) message forUser: (id<PUser>) user;
//-(XMPPMessage *) messageForTypingState: (bChatState) state toThread: (id<PThread>) thread;

@end
