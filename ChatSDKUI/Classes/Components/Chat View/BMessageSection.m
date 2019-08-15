//
//  BMessageSection.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 27/12/2016.
//
//

#import "BMessageSection.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>
#import <ChatSDK/PElmMessage.h>

@implementation BMessageSection

//-(instancetype) initWithMessages: (NSArray *) messages {
//    if((self = [self init])) {
//        [_messages addObjectsFromArray:messages];
//    }
//    return self;
//}

-(instancetype) initWithDateText: (NSString *) dateText {
    if ((self = [super init])) {
        _messages = [NSMutableArray new];
        _dateText = dateText;
    }
    return self;
}

-(NSString *) title {
    id<PElmMessage> message = _messages.firstObject;
    BMessageSectionDateProvider * provider = [BChatSDK.ui providerForName:bMessageSectionDateProvider];
    return [provider provideString: message];
}

-(id<PElmMessage>) messageForRow: (NSInteger) row {
    if (row < _messages.count) {
        return _messages[row];
    }
    return Nil;
}

-(NSInteger) rowForMessage: (id<PMessage>) message {
    return [_messages indexOfObject:message];
}


-(NSInteger) rowCount {
    return _messages.count;
}

-(NSInteger) addMessage:(id<PMessage>)message {
    if (![_messages containsObject:message]) {
        [_messages addObject:message];
        [self sortMessages];
        return [self rowForMessage:message];
    }
    return NSNotFound;
}

-(NSInteger) removeMessage: (id<PMessage>) message {
    if ([_messages containsObject:message]) {
        int index = [self rowForMessage:message];
        [_messages removeObject:message];
        return index;
    }
    return NSNotFound;
}

-(UIView *) view {
    if (!_view) {
        CGRect rect = CGRectMake(0, 0, 200, 30);
        _view = [[UIView alloc] initWithFrame:rect];
        
        UIView * innerView = [[UIView alloc] initWithFrame:rect];

        UILabel * label = [[UILabel alloc] initWithFrame:rect];
        label.text = self.title;
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [UIColor darkGrayColor];
        label.textAlignment = NSTextAlignmentCenter;

        [_view addSubview:innerView];
        [innerView addSubview:label];
        
        label.keepInsets.equal = 0;
        
        innerView.keepVerticalInsets.equal = 0;
        [innerView keepHorizontallyCentered];
        innerView.keepWidth.equal = label.attributedText.size.width + 10;
        
        innerView.clipsToBounds = YES;
        innerView.backgroundColor = [BCoreUtilities colorWithHexString:@"#EEEEEE"];
        innerView.layer.cornerRadius = 5;


    }
    return _view;
}

-(void) sortMessages {
    [_messages sortUsingComparator:[BMessageSorter oldestFirst]];
}

-(NSString *) dateText {
    return _dateText;
}

-(id<PMessage>) newestMessage {
    return _messages.lastObject;
}

-(id<PMessage>) oldestMessage {
    return _messages.firstObject;
}

-(void) debug {
    int i = 0;
    for (id<PMessage> message in _messages) {
        if (message.entityID) {
            NSLog(@"-- %i: %@, %@", i++, message.entityID, message.text);
        } else {
            NSLog(@"-- %i: null");
        }
    }
}

@end
