//
//  BMessageCache.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 20/12/2016.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PMessage.h>

@protocol PElmMessage;

@interface BMessageCache : NSObject {
    NSMutableDictionary * _messageBubbleImages;
    NSMutableDictionary * _messageInfo;
    NSString * _currentUserEntityID;
} 

+(BMessageCache *) sharedCache;

-(UIImage *) bubbleForMessage: (id<PElmMessage>) message withColorWeight: (float) weight ;

-(BOOL) isMine: (id<PElmMessage>) message;
-(void) clear;
-(bMessagePosition) positionForMessage: (id<PElmMessage>) message;
-(id<PElmMessage>) nextMessageForMessage: (id<PElmMessage>) message;

@end
