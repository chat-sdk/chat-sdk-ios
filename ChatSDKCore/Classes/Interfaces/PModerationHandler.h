//
//  PModerationHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#ifndef PModerationHandler_h
#define PModerationHandler_h

#import <RXPromise/RXPromise.h>

@protocol PModerationHandler <NSObject>

-(BOOL) canFlagMessage;

@optional

/**
 * @brief Flag a message for moderation
 */
- (RXPromise *) flagMessage: (NSString *)messageID;

/**
 * @brief Unflag a message for moderation
 */
- (RXPromise *) unflagMessage: (NSString *)messageID;
- (NSArray *) flaggedMessages;

@end

#endif /* PModerationHandler_h */
