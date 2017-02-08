//
//  BMessageCache.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 20/12/2016.
//
//

#import <Foundation/Foundation.h>

#import <ChatSDK/PMessage.h>

@protocol PMessage;

@interface BMessageCache : NSObject {
    NSMutableDictionary * _messageBubbleImages;
    NSMutableDictionary * _messageInfo;
    NSString * _currentUserEntityID;
}

+(BMessageCache *) sharedCache;

-(UIImage *) bubbleForMessage: (id<PMessage>) message withColorWeight: (float) weight ;

-(BOOL) isMine: (id<PMessage>) message;
-(void) clear;
-(bMessagePosition) positionForMessage: (id<PMessage>) message;
-(id<PMessage>) nextMessageForMessage: (id<PMessage>) message;

@end
