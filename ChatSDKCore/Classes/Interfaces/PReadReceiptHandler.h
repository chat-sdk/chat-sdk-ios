//
//  PReadReceiptHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/12/2016.
//
//

#ifndef PReadReceiptHandler_h
#define PReadReceiptHandler_h

@protocol PThread;

@protocol PReadReceiptHandler <NSObject>

-(void) updateReadReceiptsForThread: (id<PThread>) thread;
-(void) markRead: (id<PThread>) thread;
-(void) setAutoSendReadReceipt: (BOOL) autoSend;
-(void) markMessageRead: (id<PMessage>) message;

@end

#endif /* PReadReceiptHandler_h */
