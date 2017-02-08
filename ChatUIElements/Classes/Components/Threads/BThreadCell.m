//
//  BThreadCell.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 16/04/2014.
//  Copyright (c) 2014 chatsdk.co All rights reserved. The Chat SDK is issued under the MIT liceense and is available for free at http://github.com/chat-sdk
//

#import "BThreadCell.h"

#import <ChatSDK/ChatCore.h>
#import <ChatSDK/ChatUI.h>

#define bOnlineIndicatorColor @"88bb45"

@implementation BThreadCell

- (void)awakeFromNib
{
    self.profileImageView.layer.cornerRadius = self.profileImageView.fh/2.0;
    self.profileImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.profileImageView.layer.borderWidth = 1.0;
    self.messageTextView.userInteractionEnabled = NO;
    self.unreadView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.unreadView.layer.borderWidth = 1.0;
    self.unreadView.layer.cornerRadius = self.unreadView.fh/2.0;
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
