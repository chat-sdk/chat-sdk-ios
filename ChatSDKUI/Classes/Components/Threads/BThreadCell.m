//
//  BThreadCell.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 16/04/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "BThreadCell.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

#define bOnlineIndicatorColor @"88bb45"

@implementation BThreadCell

- (void)awakeFromNib
{
    self.profileImageView.layer.cornerRadius = self.profileImageView.fh/2.0;
    self.profileImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.profileImageView.layer.borderWidth = 1.0;
    self.messageTextView.userInteractionEnabled = NO;
    self.messageTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    self.unreadView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.unreadView.layer.borderWidth = 1.0;
    self.unreadView.layer.cornerRadius = self.unreadView.fh / 2.0;
    
    self.unreadMessagesLabel.layer.cornerRadius = 5;
    self.unreadMessagesLabel.clipsToBounds = YES;
    [self.unreadMessagesLabel setHidden:YES];
    self.preservesSuperviewLayoutMargins = NO;
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins = UIEdgeInsetsZero;
}

-(void) setIsOnline: (BOOL) isOnline {
    if (isOnline) {
        self.profileImageView.layer.borderColor = [BCoreUtilities colorWithHexString:bOnlineIndicatorColor].CGColor;
        self.profileImageView.layer.borderWidth = 2.0;
    }
    else {
        self.profileImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.profileImageView.layer.borderWidth = 1.0;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) startTypingWithMessage: (NSString *) message {
    self.messageTextView.text = message;
    self.messageTextView.textColor = [UIColor darkGrayColor];
}

-(void) stopTypingWithMessage: (NSString *) message {
    self.messageTextView.text = message;
    self.messageTextView.textColor = [UIColor lightGrayColor];
}

@end
