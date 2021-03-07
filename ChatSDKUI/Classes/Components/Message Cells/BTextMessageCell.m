//
//  BTextMessageCell.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 26/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import "BTextMessageCell.h"

#import <ChatSDK/UI.h>
#import <ChatSDK/Core.h>
#import <ChatSDK/PElmMessage.h>
#import <ChatSDK/ChatSDK-Swift.h>

@implementation BTextMessageCell

@synthesize textView;

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Text view
        textView = [[UITextView alloc] init];
        textView.backgroundColor = [UIColor clearColor];
        textView.dataDetectorTypes = UIDataDetectorTypeAll;
        textView.editable = NO;
        textView.userInteractionEnabled = NO;
        textView.scrollEnabled = YES;
        // Get rid of padding and margin
        textView.textContainer.lineFragmentPadding = 0;
        textView.textContainerInset = UIEdgeInsetsZero;
        textView.delegate = self;
        
        textView.font = [UIFont systemFontOfSize:bDefaultFontSize];
        if(BChatSDK.config.messageTextFont) {
            textView.font = BChatSDK.config.messageTextFont;
        }
        
        UIColor * linkColor = [BChatSDK.ui colorForName:bColorMessageLink];
        if(linkColor) {
            textView.linkTextAttributes = @{NSForegroundColorAttributeName: linkColor};
        }
        
//        textView.contentInset = UIEdgeInsetsMake(-9.0, -5.0, 0.0, 0.0);
        
        [self.bubbleImageView addSubview:textView];
        
    }
    return self;
}

-(void) setMessage: (id<PElmMessage>) message isSelected: (BOOL) selected {
    [super setMessage:message isSelected:selected];
    
    textView.text = message.text;
    
    if (message.userModel.isMe) {
        textView.textColor = [Colors getWithName:Colors.outcomingDefaultTextColor];
    } else {
        textView.textColor = [Colors getWithName:Colors.incomingDefaultTextColor];
    }
    textView.dataDetectorTypes = UIDataDetectorTypeAll;
    textView.selectable = true;
    textView.userInteractionEnabled = true;
    textView.editable = false;
    
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    NSLog(@"Click");
    return YES;
}

#pragma Cell sizing static methods

+(NSNumber *) messageContentHeight: (id<PElmMessage>) message maxWidth: (float) maxWidth {
    return @([self getText: message.text heightWithFont:[UIFont systemFontOfSize:bDefaultFontSize] withWidth:[self messageContentWidth:message maxWidth:maxWidth].floatValue]);
}

+(NSNumber *) messageContentWidth: (id<PElmMessage>) message maxWidth: (float) maxWidth {
    return @([self textWidth:message.text maxWidth:maxWidth]);
}

+(NSValue *) messageBubblePadding: (id<PElmMessage>) message {
    return [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(8.0, 9.0, 8.0, 9.0)];
}

#pragma Text size

-(float) getTextHeightWithWidth: (float) width {
    return [BTextMessageCell getText:_message.text heightWithWidth:width];
}

+(float) getText: (NSString *) text heightWithWidth: (float) width {
    return [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:bDefaultFontSize]}
                              context:Nil].size.height;
}

-(float) getTextHeightWithFont: (UIFont *) font withWidth: (float) width {
    return [BTextMessageCell getText:_message.text heightWithFont:font withWidth:width];
}

+(float) getText: (NSString *) text heightWithFont: (UIFont *) font withWidth: (float) width {
    return [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName: font}
                              context:Nil].size.height;
}

+(float) textWidth: (NSString *) text maxWidth: (float) maxWidth {
    if (text) {
        UIFont * font = [UIFont systemFontOfSize:bDefaultFontSize];
        if (font) {
            return [text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName: font}
                                      context:Nil].size.width;
        }
    }
    return 0;
}

#pragma Cell Properties

-(UIView *) cellContentView {
    return textView;
}

@end
