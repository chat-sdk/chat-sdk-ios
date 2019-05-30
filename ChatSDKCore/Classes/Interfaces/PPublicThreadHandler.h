//
//  PPublicThreadHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#ifndef PPublicThreadHandler_h
#define PPublicThreadHandler_h

@class RXPromise;

@protocol PPublicThreadHandler <NSObject>

/**
 * @brief Create a public group thread with a name. This can be used for group discussion
 */
-(RXPromise *) createPublicThreadWithName: (NSString *) name;
-(RXPromise *) createPublicThreadWithName: (NSString *) name entityID: (NSString *) entityID isHidden: (BOOL) hidden;
-(RXPromise *) createPublicThreadWithName: (NSString *) name entityID: (NSString *) entityID isHidden: (BOOL) hidden meta: (NSDictionary *) meta;

@end

#endif /* PPublicThreadHandler_h */
