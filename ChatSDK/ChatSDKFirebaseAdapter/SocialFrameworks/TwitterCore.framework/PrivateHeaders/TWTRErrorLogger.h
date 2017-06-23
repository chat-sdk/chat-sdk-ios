//
//  TWTRErrorLogger.h
//  TwitterCore
//
//  Created by Kang Chen on 7/16/15.
//  Copyright (c) 2015 Twitter Inc. All rights reserved.
//

/**
 *  Protocol for loggers that support error logging.
 */
@protocol TWTRErrorLogger <NSObject>

/**
 *  Logs that an error was encountered inside our SDK.
 *
 *  @param error        (required) An NSError object describing this error case.
 *  @param errorMessage (required) A message describing the error that occurred.
 */
- (void)didEncounterError:(NSError *)error withMessage:(NSString *)errorMessage;

@end
