//
//  TWTRDateFormatters.h
//
//  Created by Steven Hepting on 7/21/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWTRDateFormatters : NSObject

/**
 *  For use in parsing the Twitter API only.
 *
 *  @return formatter that handles Twitter's API format.
 */
+ (NSDateFormatter *)serverParsingDateFormatter;

/**
 *  For use in parsing the HTTP `date` header only
 *
 *  @return formatter that handles HTTP `date` header format
 */
+ (NSDateFormatter *)HTTPDateHeaderParsingFormatter;

/**
 *  For use in compact Tweet view when 24 hours < createdAt < current year.
 *
 *  @return formatter that emits abbreviated month and day e.g. Aug 5.
 */
+ (NSDateFormatter *)dayAndMonthDateFormatter;

/**
 *  For use in timestamp accessibility labels
 *
 *  @return formatter with NSDateFormatterLongStyle e.g. November 23, 1937
 */
+ (NSDateFormatter *)systemLongDateFormatter;

/**
 *  For use in compact Tweet view when current year < createdAt.
 *
 *  @return formatter that emits just the date without time e.g. MM/DD/YY
 */
+ (NSDateFormatter *)shortHistoricalDateFormatter;

@end
