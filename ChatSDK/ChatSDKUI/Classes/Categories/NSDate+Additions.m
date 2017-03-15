//
//  NSDate+Additions.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 15/09/2016.
//
//

#import "NSDate+Additions.h"

#import <ChatSDKCore/ChatCore.h>
#import <ChatSDKUI/ChatUI.h>

@implementation NSDate (Additions)

-(NSString *) threadTimeAgo {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    NSString * time = [formatter stringFromDate:self];
    
    if ([self daysAgo] == 1) {
        time = [NSBundle t: bYesterday];
    }
    else if (self.daysAgo > 1 && self.daysAgo < 7) {
        [formatter setDateFormat:@"EEEE"];
        time = [formatter stringFromDate:self];
    }
    else if (self.daysAgo >= 7) {
        [formatter setDateFormat:@"MM/yy"];
        time = [formatter stringFromDate:self];
    }
    return time;
}

-(NSString *) messageTimeAt {
//    if (self.daysAgo < 1) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
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
    [formatter setDateFormat:@"HH:mm"];
    
    NSString * time = [formatter stringFromDate:self];
    NSString * day = [self dateAgo];
    return [NSString stringWithFormat:[NSBundle t:formatString], day, time];
}


@end

