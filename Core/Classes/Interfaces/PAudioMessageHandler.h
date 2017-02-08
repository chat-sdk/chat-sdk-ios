//
//  PAudioMessagingHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#ifndef PAudioMessagingHandler_h
#define PAudioMessagingHandler_h

#import <ChatSDK/PMessageHandler.h>

@class RXPromise;


@protocol PAudioMessageHandler <PMessageHandler>

/**
 * @brief Send an audio message
 */
-(RXPromise *) sendMessageWithAudio:(NSData *) data duration:(double) seconds withThreadEntityID:(NSString *)threadID;

@end

#endif /* PAudioMessagingHandler_h */
