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

-(instancetype) initWithMessages: (NSArray *) messages {
    if((self = [self init])) {
        [_messages addObjectsFromArray:messages];
    }
    return self;
}

-(instancetype) init {
    if ((self = [super init])) {
        _messages = [NSMutableArray new];
    }
    return self;
}

-(NSString *) title {
    id<PElmMessage> message = _messages.firstObject;
    return [message.date dateAgo];
}

-(id<PElmMessage>) messageForRow: (NSInteger) row {
    if (row < _messages.count) {
        return _messages[row];
    }
    return Nil;
}

-(NSInteger) rowCount {
    return _messages.count;
}

-(void) addMessage:(id<PElmMessage>)message {
    [_messages addObject:message];
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

@end
