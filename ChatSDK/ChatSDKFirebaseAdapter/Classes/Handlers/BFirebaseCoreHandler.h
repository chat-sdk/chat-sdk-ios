//
//  BFirebaseMessagingHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import <ChatSDKCore/BAbstractCoreHandler.h>

@interface BFirebaseCoreHandler : BAbstractCoreHandler

/**
 * @brief
 */
+(NSNumber *) dateToTimestamp: (NSDate *) date;

/**
 * @brief
 */
+(NSDate *) timestampToDate: (NSNumber *) timestamp;


@end
