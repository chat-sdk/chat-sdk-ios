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

-(UIImage *) bubbleForMessage: (id<PElmMessage>) message withColorWeight: (float) weight {
    
    bMessagePos pos = [message messagePosition];
    BOOL isMine = [message senderIsMe];
    
    NSString * bubbleImageName = @"";
    switch (pos) {
        case bMessagePosFirst:
            bubbleImageName = @"chat_bubble_right_0S.png";
            break;
        case bMessagePosMiddle:
            bubbleImageName = @"chat_bubble_right_SS.png";
            break;
        case bMessagePosLast:
            bubbleImageName = @"chat_bubble_right_ST.png";
            break;
        case bMessagePosSingle:
            bubbleImageName = @"chat_bubble_right_0T.png";
            break;
    }
    
    // Color
    NSString * colorString = Nil;
    if (isMine) {
        colorString = BChatSDK.shared.configuration.messageColorMe;
    }
    else {
        colorString = BChatSDK.shared.configuration.messageColorReply;
    }

    NSString * imageIdentifier = [NSString stringWithFormat:@"%@%@%i%f", bubbleImageName, colorString, isMine, weight];
    
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
        
        UIColor * color = [BCoreUtilities colorWithHexString:colorString withColorWeight:weight];
        
        UIImage * image = [BMessageCell bubbleWithImage:bubbleImage withColor:color];
        
        _messageBubbleImages[imageIdentifier] = image;
        
        return image;
    }
    
}

@end
