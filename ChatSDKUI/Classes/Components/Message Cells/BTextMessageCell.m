//
//  BTextMessageCell.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 26/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import "BTextMessageCell.h"

#import <ChatSDK/ChatUI.h>
#import <ChatSDK/ChatCore.h>
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

        textView.font = [UIFont systemFontOfSize:bDefaultFontSize];
        if([BChatSDK config].messageTextFont) {
            textView.font = [BChatSDK config].messageTextFont;
        }
        
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
    
    textView.text = message.textString;
    
    BOOL isMine = [message.userModel isEqual:NM.currentUser];
    
    if([BChatSDK config].messageTextColorMe && isMine) {
        textView.textColor = [BCoreUtilities colorWithHexString:[BChatSDK config].messageTextColorMe];
    }
    if([BChatSDK config].messageTextColorReply && !isMine) {
        textView.textColor = [BCoreUtilities colorWithHexString:[BChatSDK config].messageTextColorReply];
    }

    textView.textColor = [BCoreUtilities colorWithHexString:bDefaultTextColor];
}


#pragma Cell Properties

-(UIView *) cellContentView {
    return textView;
}

@end
