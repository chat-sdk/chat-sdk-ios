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

@synthesize profileImageView;
@synthesize messageTextView;
@synthesize unreadView;
@synthesize unreadMessagesLabel;
@synthesize titleLabel;
@synthesize dateLabel;


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    profileImageView.layer.cornerRadius = profileImageView.fh/2.0;
    profileImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    profileImageView.layer.borderWidth = 1.0;
    messageTextView.userInteractionEnabled = NO;
    messageTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    unreadView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    unreadView.layer.borderWidth = 1.0;
    unreadView.layer.cornerRadius = unreadView.fh / 2.0;
    
    unreadMessagesLabel.layer.cornerRadius = 5;
    unreadMessagesLabel.clipsToBounds = YES;
    
    self.preservesSuperviewLayoutMargins = NO;
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins = UIEdgeInsetsZero;
}

-(void) bind: (id<PThread>) thread {
 
    NSDate * threadDate = thread.orderDate;
    
    NSString * text = @"";// [NSBundle t:bNoMessages];
    
    id<PMessage> newestMessage = thread.newestMessage;
    if (newestMessage) {
        text = [NSBundle textForMessage:newestMessage];
    }
    
    if (threadDate) {
        dateLabel.text = threadDate.threadTimeAgo;
    }
    else {
        dateLabel.text = @"";
    }
    
    if(BChatSDK.config.threadTimeFont) {
        dateLabel.font = BChatSDK.config.threadTimeFont;
    }
    
    if(BChatSDK.config.threadTitleFont) {
        titleLabel.font = BChatSDK.config.threadTitleFont;
    }
    
    if(BChatSDK.config.threadSubtitleFont) {
        messageTextView.font = BChatSDK.config.threadSubtitleFont;
    }
    
    titleLabel.text = thread.displayName ? thread.displayName : [NSBundle t: bDefaultThreadName];
   
    [profileImageView loadThreadImage:thread];
    
    int unreadCount = thread.unreadMessageCount;
    unreadMessagesLabel.hidden = !unreadCount;
    unreadMessagesLabel.text = [@(unreadCount) stringValue];
    
    [self stopTypingWithMessage:text];
    
}

-(void) setIsOnline: (BOOL) isOnline {
    if (isOnline) {
        profileImageView.layer.borderColor = [BCoreUtilities colorWithHexString:bOnlineIndicatorColor].CGColor;
        profileImageView.layer.borderWidth = 2.0;
    }
    else {
        profileImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        profileImageView.layer.borderWidth = 1.0;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) startTypingWithMessage: (NSString *) message {
    messageTextView.text = message;
    messageTextView.textColor = [UIColor darkGrayColor];
}

-(void) stopTypingWithMessage: (NSString *) message {
    messageTextView.text = message;
    messageTextView.textColor = [UIColor lightGrayColor];
}

@end
