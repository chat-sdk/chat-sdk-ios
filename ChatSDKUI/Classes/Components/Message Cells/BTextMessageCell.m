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
        textView.userInteractionEnabled = YES;
        textView.scrollEnabled = YES;
        // Get rid of padding and margin
        textView.textContainer.lineFragmentPadding = 0;
        textView.textContainerInset = UIEdgeInsetsZero;

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

-(void) setMessage: (id<PElmMessage>) message withColorWeight:(float)colorWeight {
    [super setMessage:message withColorWeight:colorWeight];
    
    textView.text = message.text;
    
    if(BChatSDK.config.messageTextColorMe && message.userModel.isMe) {
        textView.textColor = [BCoreUtilities colorWithHexString:BChatSDK.config.messageTextColorMe];
    }
    else if(BChatSDK.config.messageTextColorReply && !message.userModel.isMe) {
        textView.textColor = [BCoreUtilities colorWithHexString:BChatSDK.config.messageTextColorReply];
    }
    else
    {
        textView.textColor = [BCoreUtilities colorWithHexString:bDefaultTextColor];
    }
}

#pragma Cell sizing static methods

+(NSNumber *) messageContentHeight: (id<PElmMessage>) message maxWidth: (float) maxWidth {
    UIFont * font = [UIFont systemFontOfSize:bDefaultFontSize];
    if(BChatSDK.config.messageTextFont) {
        font = BChatSDK.config.messageTextFont;
    }
    return @([self getText: message.text heightWithFont:font withWidth:[self messageContentWidth:message maxWidth:maxWidth].floatValue]);
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
        if(BChatSDK.config.messageTextFont) {
            font = BChatSDK.config.messageTextFont;
        }
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
