//
//  NSDate+Additions.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 15/09/2016.
//
//

#import "NSDate+Additions.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

@implementation NSDate (Additions)

-(NSString *) threadTimeAgo {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:self.timeFormat];
    
    NSString * time = [formatter stringFromDate:self];
    
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:[NSDate date]];

    // We check if the last date was in the last few days
    // Then check if it was exactly yesterday
    if ([self daysAgo] < 3 && today.day == otherDay.day + 1) {
        time = [NSBundle t: bYesterday];
    }
    else if (self.daysAgo > 1 && self.daysAgo < 7) {
        [formatter setDateFormat:@"EEEE"];
        time = [formatter stringFromDate:self];
    }
    else if (self.daysAgo >= 7) {   
        [formatter setDateFormat:@"dd/MM/yy"];
        time = [formatter stringFromDate:self];
    }
    return time;
}

-(NSString *) timeFormat {
    return [BChatSDK config].timeFormat;
}

-(NSString *) messageTimeAt {
//    if (self.daysAgo < 1) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:self.timeFormat];
        return [formatter stringFromDate:self];
//    }
//    else {
//        return [self timeAgoWithFormatString:b_at_];
//    }
}

-(NSString *) lastSeenTimeAgo {
    return [self timeAgoWithFormatString:bLastSeen_at_];
}

-(NSString *) dateAgo {

    NSString * day = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if ([self daysAgo] == 0) {
        day = [NSBundle t: bToday];
    }
    else if ([self daysAgo] == 1) {
        day = [NSBundle t: bYesterday];
    }
    else if (self.daysAgo < 7) {
        [formatter setDateFormat:@"EEE"];
        day = [formatter stringFromDate:self];
    }
    else {
        [formatter setDateFormat:@"MM/yy"];
        day = [formatter stringFromDate:self];
    }
    
    return day;
}

-(NSString *) timeAgoWithFormatString: (NSString *) formatString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:self.timeFormat];
    
    NSString * time = [formatter stringFromDate:self];
    NSString * day = [self dateAgo];
    return [NSString stringWithFormat:[NSBundle t:formatString], day, time];
}


@end

