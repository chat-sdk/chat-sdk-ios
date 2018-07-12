//
//  BTextMessageCell.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 26/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import "BSystemMessageCell.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>
#import <ChatSDK/PElmMessage.h>

@implementation BSystemMessageCell

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
        textView.font = [UIFont systemFontOfSize:14];
        textView.textColor = [UIColor grayColor];
        textView.textAlignment = NSTextAlignmentCenter;

        self.bubbleImageView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        self.bubbleImageView.layer.cornerRadius = 10;
        
        textView.contentInset = UIEdgeInsetsMake(-9.0, -5.0, 0.0, 0.0);
        
        [self.bubbleImageView addSubview:textView];
        
    }
    return self;
}

-(void) setMessage: (id<PElmMessage>) message withColorWeight:(float)colorWeight {
    [super setMessage:message withColorWeight:colorWeight];
    
    NSDictionary * dict = [message textAsDictionary];
    
    self.bubbleImageView.image = Nil;
    
    textView.text = dict[bMessageTextKey];
    
    int type = [dict[bMessageTypeKey] intValue];
    if (type == bSystemMessageTypeInfo) {
        self.bubbleImageView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    }
    if (type == bSystemMessageTypeError) {
        self.bubbleImageView.backgroundColor = [UIColor colorWithRed:1.0 green:0.9 blue:0.9 alpha:1];
    }

}

-(void) willDisplayCell {
    
    float margin = self.bubbleMargin;
    float padding = self.bubblePadding;
    
    // HERE
    // Set the margins and height for message
    [self.bubbleImageView setFrame:CGRectMake(margin,
                                         margin,
                                         self.bubbleWidth,
                                         self.bubbleHeight)];
    
    _nameLabel.frame = CGRectZero;
    _timeLabel.frame = CGRectZero;
    _timeLabel.hidden = YES;
    
    // Update the content view size for the message length
    [self cellContentView].frame = CGRectMake(padding,
                                              padding,
                                              self.messageWidth + padding,
                                              self.messageHeight + padding);
    
    // Layout the profile picture
    _profilePicture.frame = CGRectZero;

}

// Format the cells properly when the device orientation changes
-(void) layoutSubviews {
    [super layoutSubviews];
    [self.bubbleImageView setViewFrameX:(self.fw - self.bubbleImageView.fw)/2.0];
}

#pragma Cell Properties

-(UIView *) cellContentView {
    return textView;
}

@end
