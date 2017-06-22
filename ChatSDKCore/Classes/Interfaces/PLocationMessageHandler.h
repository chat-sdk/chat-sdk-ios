//
//  PLocationMessageHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#ifndef PLocationMessageHandler_h
#define PLocationMessageHandler_h

#import <ChatSDK/PMessageHandler.h>

@class RXPromise;
@class CLLocation;

@protocol PLocationMessageHandler <PMessageHandler>

/**
 * @brief Send a location message
 */
-(RXPromise *) sendMessageWithLocation: (CLLocation *) location withThreadEntityID: (NSString *) threadID;

@end

#endif /* PLocationMessageHandler_h */
