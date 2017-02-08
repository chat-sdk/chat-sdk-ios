//
//  BThreadCell.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 16/04/2014.
//  Copyright (c) 2014 chatsdk.co All rights reserved. The Chat SDK is issued under the MIT liceense and is available for free at http://github.com/chat-sdk
//

#import <UIKit/UIKit.h>

@class AsyncImageView;

@interface BThreadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIView *unreadView;

-(void) setIsOnline: (BOOL) isOnline;
-(void) startTypingWithMessage: (NSString *) message;
-(void) stopTypingWithMessage: (NSString *) message;

@end
