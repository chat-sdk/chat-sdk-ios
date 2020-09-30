//
//  BMessageCache.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 20/12/2016.
//
//

#import "BMessageCache.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>
#import <ChatSDK/ChatSDK-Swift.h>


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
        _messageBubbleImages = [NSMutableDictionary new];
    }
    return self;
}

-(UIImage *) bubbleForMessage: (id<PElmMessage>) message isSelected: (BOOL) selected {
    
    bMessagePos pos = [message messagePosition];
    BOOL isMine = [message senderIsMe];
    
    NSString * bubbleImageName = @"";
    switch (pos) {
        case bMessagePosFirst:
            bubbleImageName = BChatSDK.config.messageBubbleMaskFirst;
            break;
        case bMessagePosMiddle:
            bubbleImageName = BChatSDK.config.messageBubbleMaskMiddle;
            break;
        case bMessagePosLast:
            bubbleImageName = BChatSDK.config.messageBubbleMaskLast;
            break;
        case bMessagePosSingle:
            bubbleImageName = BChatSDK.config.messageBubbleMaskSingle;
            break;
    }
    
    UIColor * color = Nil;
    if (!selected) {
        if (isMine) {
            color = [Colors getWithName:Colors.outcomingDefaultBubbleColor];
        } else {
            color = [Colors getWithName:Colors.incomingDefaultBubbleColor];
        }
    } else {
        if (isMine) {
            color = [Colors getWithName:Colors.outcomingDefaultSelectedBubbleColor];
        } else {
            color = [Colors getWithName:Colors.incomingDefaultSelectedBubbleColor];
        }
    }
    
    NSString * imageIdentifier = [NSString stringWithFormat:@"%@%@%@", bubbleImageName, [BCoreUtilities colorToString:color], isMine ? @"Y" : @"N"];
    
    if(_messageBubbleImages[imageIdentifier]) {
        return _messageBubbleImages[imageIdentifier];
    }
    else {

        UIImage * bubbleImage = [NSBundle uiImageNamed:bubbleImageName];

        if (isMine) {
            bubbleImage = [bubbleImage stretchableImageWithLeftCapWidth:bLeftCapRight topCapHeight:bTopCap];
        }
        else {
            bubbleImage = [UIImage imageWithCGImage:bubbleImage.CGImage
                                                            scale:bubbleImage.scale
                                                      orientation:UIImageOrientationUpMirrored];
            
            bubbleImage = [bubbleImage stretchableImageWithLeftCapWidth:bLeftCapRight topCapHeight:bTopCap];
            
        }
                        
        UIImage * image = [BMessageCell bubbleWithImage:bubbleImage withColor:color];
        
        _messageBubbleImages[imageIdentifier] = image;
        
        return image;
    }
    
}

@end
