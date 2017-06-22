//
//  PTypingIndicatorHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 04/11/2016.
//
//

#ifndef PTypingIndicatorHandler_h
#define PTypingIndicatorHandler_h

#import <ChatSDK/bChatState.h>

@class RXPromise;
@protocol PThread;

@protocol PTypingIndicatorHandler <NSObject>

-(void) typingOn: (id<PThread>) thread;
-(void) typingOff: (id<PThread>) thread;

-(RXPromise *) setChatState: (bChatState) state forThread: (id<PThread>) thread;

@end

#endif /* PTypingIndicatorHandler_h */
