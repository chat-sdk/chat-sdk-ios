//
//  BTextMessageCell.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 26/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import "BTextMessageCell.h"

#import <ChatSDKUI/ChatUI.h>
#import <ChatSDKCore/ChatCore.h>
#import <ChatSDKCore/PElmMessage.h>

@implementation BTextMessageCell

@synthesize textView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Text view
        textView = [[UITextView alloc] init];
        textView.backgroundColor = [UIColor clearColor];
        textView.dataDetectorTypes = UIDataDetectorTypeAll;
        textView.editable = NO;
        textView.userInteractionEnabled = YES;
        textView.scrollEnabled = YES;
        
        UIColor * linkColor = [[BInterfaceManager sharedManager].a colorForName:bColorMessageLink];
        if(linkColor) {
            textView.linkTextAttributes = @{NSForegroundColorAttributeName: linkColor};
        }
        
        textView.contentInset = UIEdgeInsetsMake(-9.0, -5.0, 0.0, 0.0);
        
        [self.bubbleImageView addSubview:textView];
        
    }
    return self;
}

-(void) setMessage: (id<PElmMessage, PMessageLayout>) message withColorWeight:(float)colorWeight {
    [super setMessage:message withColorWeight:colorWeight];
    
    NSArray * mentions = message.metaDictionary[bMentionsPath];
    
    if (mentions) {
        
        textView.textColor = [BCoreUtilities colorWithHexString:bDefaultTextColor];
        
        NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:message.textString];
        
        // Loop through the string and separate the strings
        
        for (NSDictionary * dict in mentions) {
            
            NSNumber * location = dict[@"location"];
            NSString * name = dict[@"name"];
            
            NSRange range = NSMakeRange(location.integerValue, name.length);
            
            if (dict[@"type"] && [dict[@"type"] isEqual:@1]) {
                [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
            }
            else {
                [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
            }
        }
        
        textView.attributedText = attrString;
        textView.font = [UIFont systemFontOfSize:bDefaultFontSize];
    }
    else {
        
        textView.text = message.textString;
        textView.font = [UIFont systemFontOfSize:bDefaultFontSize];
        
        textView.textColor = [BCoreUtilities colorWithHexString:bDefaultTextColor];
    }
}

#pragma Cell Properties

-(UIView *) cellContentView {
    return textView;
}

@end
