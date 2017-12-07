//
//  BMessageCache.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 20/12/2016.
//
//

#import "BMessageCache.h"

#import <ChatSDK/ChatCore.h>
#import <ChatSDK/ChatUI.h>


#define bMessagePositionKey @"bMessagePositionKey"
#define bNextMessageKey @"bNextMessageKey"

@implementation BMessageCache

static BMessageCache * cache;

+(BMessageCache *) sharedCache {
    
    @synchronized(self) {
        
        // If the sharedSoundManager var is nil then we need to allocate it.
        if(cache == nil) {
            // Allocate and initialize an instance of this class
            cache = [[self alloc] init];
        }
    }
    return cache;
}

-(instancetype) init {
    if ((self = [super init])) {
        _messageInfo = [NSMutableDictionary new];
        _messageBubbleImages = [NSMutableDictionary new];
        
        // Clear the cache when the user logs out
        [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationLogout object:Nil queue:0 usingBlock:^(NSNotification * notification) {
            [self clear];
        }];
        
    }
    return self;
}

-(UIImage *) bubbleForMessage: (id<PElmMessage>) message withColorWeight: (float) weight {
    
    bMessagePosition pos = [self positionForMessage:message];
    BOOL isMine = [self isMine:message];
    
    NSString * bubbleImageName = @"";
    switch (pos) {
        case bMessagePositionFirst:
            bubbleImageName = @"chat_bubble_right_0S.png";
            break;
        case bMessagePositionMiddle:
            bubbleImageName = @"chat_bubble_right_SS.png";
            break;
        case bMessagePositionLast:
            bubbleImageName = @"chat_bubble_right_ST.png";
            break;
        case bMessagePositionSingle:
            bubbleImageName = @"chat_bubble_right_0T.png";
            break;
    }
    
    // Color
    NSString * colorString = Nil;
    if (isMine) {
        colorString = [BChatSDK shared].configuration.messageColorMe;
    }
    else {
        colorString = [BChatSDK shared].configuration.messageColorReply;
    }

    NSString * imageIdentifier = [NSString stringWithFormat:@"%@%@%i%f", bubbleImageName, colorString, isMine, weight];
    if(_messageBubbleImages[imageIdentifier]) {
        return _messageBubbleImages[imageIdentifier];
    }
    else {

        UIImage * bubbleImage = [NSBundle chatUIImageNamed:bubbleImageName];

        if (isMine) {
            bubbleImage = [bubbleImage stretchableImageWithLeftCapWidth:bLeftCapRight topCapHeight:bTopCap];
        }
        else {
            bubbleImage = [UIImage imageWithCGImage:bubbleImage.CGImage
                                                            scale:bubbleImage.scale
                                                      orientation:UIImageOrientationUpMirrored];
            
            bubbleImage = [bubbleImage stretchableImageWithLeftCapWidth:bLeftCapRight topCapHeight:bTopCap];
            
        }
        
        UIColor * color = [BCoreUtilities colorWithHexString:colorString withColorWeight:weight];
        
        UIImage * image = [BMessageCell bubbleWithImage:bubbleImage withColor:color];
        
        _messageBubbleImages[imageIdentifier] = image;
        
        return image;
    }
    
}

// We want to cache any message apart from the last message because the
// properties of the last message can still change
-(BOOL) shouldCacheMessage: (id<PElmMessage>) message {
    return ![message isEqual:message.thread.messagesOrderedByDateAsc.lastObject];
}

-(bMessagePosition) positionForMessage: (id<PElmMessage>) message {
    bMessagePosition pos;
    if([self isMessageCached:message]) {
        pos = [[self infoForMessage:message][bMessagePositionKey] intValue];
    }
    else {
        pos = message.messagePosition;
        [self cacheMessage:message];
    }
    return pos;
}

-(void) cacheMessage: (id<PElmMessage>) message {
    if ([self shouldCacheMessage:message]) {

        bMessagePosition pos = message.messagePosition;
        id<PElmMessage> nm = message.nextMessage;
        
        [self infoForMessage:message][bMessagePositionKey] = @(pos);
        [self infoForMessage:message][bNextMessageKey] = nm;
    }
}

-(id<PElmMessage>) nextMessageForMessage: (id<PElmMessage>) message {
    id<PElmMessage> nm;
    if([self isMessageCached:message]) {
        nm = [self infoForMessage:message][bNextMessageKey];
    }
    else {
        nm = message.nextMessage;
        [self cacheMessage:message];
    }
    return nm;
}

-(NSMutableDictionary *) infoForMessage: (id<PElmMessage>) message {
    // Have we already seen this message?
    NSMutableDictionary * messageInfo = _messageInfo[message.entityID];
    if(!messageInfo && message.entityID) {
        messageInfo = [NSMutableDictionary new];
        _messageInfo[message.entityID] = messageInfo;
    }
    return messageInfo;
}

-(BOOL) isMessageCached: (id<PElmMessage>) message {
    return _messageInfo[message.entityID] != Nil;
}

-(BOOL) isMine: (id<PElmMessage>) message {
    return [message.userModel.entityID isEqualToString: self.currentUserEntityID];
}

-(void) clear {
    _currentUserEntityID = Nil;
    [_messageBubbleImages removeAllObjects];
    [_messageInfo removeAllObjects];
}

-(NSString *) currentUserEntityID {
    if(!_currentUserEntityID) {
        _currentUserEntityID = NM.currentUser.entityID;
    }
    return _currentUserEntityID;
}

@end
