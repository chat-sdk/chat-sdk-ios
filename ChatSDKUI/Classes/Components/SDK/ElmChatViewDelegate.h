//
//  ElmChatViewDelegate.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 01/02/2017.
//
//

#ifndef ElmChatViewDelegate_h
#define ElmChatViewDelegate_h

#import <ChatSDK/bChatState.h>

@protocol PElmMessage;
@protocol PElmThread;

@class RXPromise;
@class CLLocation;

@protocol ElmChatViewDelegate <NSObject>

@required

// For all send methods
// RXPromise.success - not used
// RXPromise.error - return NSError to display
-(RXPromise *) sendText: (NSString *) text;
-(RXPromise *) sendText: (NSString *) text withMeta: (NSDictionary *)meta;
-(RXPromise *) sendImage: (UIImage *) image;
-(RXPromise *) sendLocation: (CLLocation *) location;
-(RXPromise *) sendAudio: (NSData *) audio withDuration: (double) duration;
-(RXPromise *) sendVideo: (NSData *) video withCoverImage: (UIImage *) coverImage;
-(RXPromise *) sendSystemMessage: (NSString *) text;
-(RXPromise *) sendSticker: (NSString *) name;
-(RXPromise *) sendFile: (NSDictionary *) file;

-(RXPromise *) setMessageFlagged: (id<PElmMessage>) message isFlagged: (BOOL) flagged;
-(RXPromise *) setChatState: (bChatState) state;

-(void) markRead;
-(void) navigationBarTapped;
-(bThreadType) threadType;

@optional

// When the user pulls down on the table view
-(RXPromise *) loadMoreMessages;

@end

#endif /* ElmChatViewDelegate_h */
