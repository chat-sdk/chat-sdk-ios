//
//  BFirebaseMessagingHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import <ChatSDK/BAbstractCoreHandler.h>

@class FIRApp;
@class FIRDatabase;
@class FIRAuth;

@interface BFirebaseCoreHandler : BAbstractCoreHandler

/**
 * @brief Convert a date object to a Firebase timestamp
 */
+(NSNumber *) dateToTimestamp: (NSDate *) date;

/**
 * @brief Convert a Firebase timestamp to a date object
 */
+(NSDate *) timestampToDate: (NSNumber *) timestamp;

+(FIRApp *) app;
+(FIRDatabase *) database;
+(FIRAuth *) auth;


@end
