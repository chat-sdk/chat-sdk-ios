//
//  PImageMessageHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#ifndef PImageMessageHandler_h
#define PImageMessageHandler_h

#import <ChatSDK/PMessageHandler.h>

@class RXPromise;

@protocol PImageMessageHandler <PMessageHandler>

/**
 * @brief Send an image message
 */
-(RXPromise *) sendMessageWithImage: (UIImage *) image withThreadEntityID: (NSString *) threadID;

@end

#endif /* PImageMessageHandler_h */
