//
//  BMessageManager.m
//  AFNetworking
//
//  Created by ben3 on 09/05/2019.
//

#import "BMessageManager.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

@implementation BMessageManager

-(instancetype) init {
    if((self = [super init])) {
        _messageSections = [NSMutableArray new];
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyyMMdd";

    }
    return self;
}

-(NSIndexPath *) addMessage: (id<PMessage>) message {
    NSInteger messageIndex = NSNotFound;
    NSInteger sectionIndex = NSNotFound;
    
    BMessageSection * section = [self sectionForDate:message.date];
    if (!section) {
        NSString * messageDate = [_dateFormatter stringFromDate:message.date];
        section = [[BMessageSection alloc] initWithDateText:messageDate];
        [_messageSections addObject:section];
        [self sortMessageSections];
    }
    messageIndex = [section addMessage:message];
    sectionIndex = [_messageSections indexOfObject:section];
    if (messageIndex != NSNotFound && sectionIndex != NSNotFound) {
        return [NSIndexPath indexPathForItem:messageIndex inSection:sectionIndex];
    } else {
        return Nil;
    }
}

-(NSIndexPath *) indexPathForMessage: (id<PMessage>) message {
    BMessageSection * section = [self sectionForDate:message.date];
    if (section) {
        NSInteger row = [section rowForMessage:message];
        if (row != NSNotFound) {
            return [NSIndexPath indexPathForItem:row inSection:[_messageSections indexOfObject:section]];
        }
    }
    return Nil;
}

-(NSIndexPath *) indexPathForPreviousMessageInSection: (id<PMessage>) message {
    NSIndexPath * indexPath = [self indexPathForMessage:message];
    if (indexPath && indexPath.row > 0) {
        return [NSIndexPath indexPathForItem:indexPath.row - 1 inSection:indexPath.section];
    }
    return Nil;
}

-(NSIndexPath *) indexPathForPreviousMessage: (id<PMessage>) message {
    NSIndexPath * indexPath = [self indexPathForPreviousMessage:message];
    if (indexPath) {
        return indexPath;
    } else {
        BMessageSection * section = [self sectionForDate:message.date];
        NSInteger indexOfSection = [_messageSections indexOfObject:section];
        if (indexOfSection > 0) {
            NSInteger indexOfPreviousSection = indexOfSection - 1;
            BMessageSection * previousSection = _messageSections[indexOfPreviousSection];
            return [NSIndexPath indexPathForItem: previousSection.rowCount inSection:indexOfPreviousSection];
        }
    }
    return Nil;
}

-(NSIndexPath *) removeMessage: (id<PMessage>) message {
    NSInteger messageIndex = NSNotFound;
    NSInteger sectionIndex = NSNotFound;
    
    BMessageSection * section = [self sectionForDate:message.date];
    if (section) {
        messageIndex = [section removeMessage:message];
        sectionIndex = [_messageSections indexOfObject:section];
        if (messageIndex != NSNotFound && sectionIndex != NSNotFound) {
            return [NSIndexPath indexPathForItem:messageIndex inSection:sectionIndex];
        }
    }
    return Nil;
}

-(NSArray<NSIndexPath *> *) addMessages: (NSArray<PMessage> *) messages {
    for (id<PMessage> message in messages) {
        [self addMessage:message];
    }
    return [self indexPathsForMessages:messages];
}

-(NSArray<NSIndexPath *> *) indexPathsForMessages: (NSArray<PMessage> *) messages {
    NSMutableArray<NSIndexPath *> * indexPaths = [NSMutableArray new];
    for (id<PMessage> message in messages) {
        [indexPaths addObject:[self indexPathForMessage:message]];
    }
    return indexPaths;
}

//-(NSArray<NSIndexPath *> *) removeMessages: (NSArray<id<PMessage>> *) messages {
//    
//}

-(void) setMessages: (NSArray<PMessage> *) messages {
    // Don't load any additional messages - we will already load the
    // number of messages as defined the config.messagesToLoadPerBatch property
    NSDate * lastMessageDate;
    BMessageSection * section;
    
    for (id<PMessage> message in messages) {
        // This is a new day
        // It is a new day if either the calendar date has changed
        NSString * lastDateString = [_dateFormatter stringFromDate:lastMessageDate];
        NSString * dateString = [_dateFormatter stringFromDate:message.date];
        
        // If the message date is different to the last date
        // Create a new section
        if (!lastMessageDate || ![dateString isEqual:lastDateString]) {
            section = [[BMessageSection alloc] initWithDateText:dateString];
            [_messageSections addObject:section];
        }
        [section addMessage:message];
        lastMessageDate = message.date;
    }
    // Add the last section
    if (![_messageSections containsObject:section] && section) {
        [_messageSections addObject:section];
    }
}

-(void) sortMessageSections {
    [_messageSections sortUsingComparator:^NSComparisonResult(BMessageSection * s1, BMessageSection * s2) {
        return s1.dateText.intValue - s2.dateText.intValue;
    }];
}

-(BMessageSection *) sectionForDate: (NSDate *) date {
    NSString * dateText = [_dateFormatter stringFromDate:date];
    for (BMessageSection * section in _messageSections) {
        if([section.dateText isEqualToString:dateText]) {
            return section;
        }
    }
    return Nil;
}

-(id<PMessage>) newestMessage {
    BMessageSection * lastSection = _messageSections.lastObject;
    if (lastSection) {
        return lastSection.newestMessage;
    }
    return Nil;
}

-(id<PMessage>) oldestMessage {
    BMessageSection * firstSection = _messageSections.firstObject;
    if (firstSection) {
        return firstSection.oldestMessage;
    }
    return Nil;
}

-(NSInteger) sectionCount {
    return _messageSections.count;
}
-(NSInteger) rowCountForSection: (NSInteger) section {
    return _messageSections[section].rowCount;
}

-(id<PElmMessage>) messageForIndexPath: (NSIndexPath *) indexPath {
    return [[self messageSectionForIndex:indexPath.section] messageForRow:indexPath.row];
}

-(UIView *) headerForSection: (NSInteger) section {
    return [[self messageSectionForIndex:section] view];
}

-(BMessageSection *) messageSectionForIndex: (NSInteger) index {
    if (_messageSections.count > index && index >= 0) {
        return _messageSections[index];
    }
    return Nil;
}

-(void) debug {
    int i = 0;
    for (BMessageSection * section in _messageSections) {
        NSLog(@"- %i:", i++);
        [section debug];
    }
}



@end
