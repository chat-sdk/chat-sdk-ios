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
}

+(BMessageCache *) sharedCache;

-(UIImage *) bubbleForMessage: (id<PElmMessage>) message withColorWeight: (float) weight ;


@end
