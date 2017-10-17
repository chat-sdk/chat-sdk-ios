//
//  PVideoMessagingHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#ifndef PVideoMessagingHandler_h
#define PVideoMessagingHandler_h

#import <ChatSDK/PMessageHandler.h>


@class RXPromise;

@protocol PVideoMessageHandler <PMessageHandler>

/**
 * @brief Send a video message
 */
-(RXPromise *) sendMessageWithVideo: (NSData *) data coverImage:(UIImage *)image withThreadEntityID:(NSString *)threadID;

@end

#endif /* PVideoMessagingHandler_h */
