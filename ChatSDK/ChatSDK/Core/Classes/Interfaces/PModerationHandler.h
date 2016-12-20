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

/**
 * @brief
 */
- (RXPromise *) flagMessage: (NSString *)messageID;

/**
 * @brief
 */
- (RXPromise *) unflagMessage: (NSString *)messageID;


@end

#endif /* PModerationHandler_h */
