//
//  PPublicThreadHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#ifndef PPublicThreadHandler_h
#define PPublicThreadHandler_h

#import <RXPromise.h>

@protocol PPublicThreadHandler <NSObject>

/**
 * @brief Create a public group thread with a name. This can be used for group discussion
 */
-(RXPromise *) createPublicThreadWithName: (NSString *) name;

@end

#endif /* PPublicThreadHandler_h */
