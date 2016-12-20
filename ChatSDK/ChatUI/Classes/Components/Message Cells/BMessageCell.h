//
//  BMessageCell.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 27/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMessageDelegate.h"
#import "PMessageLayout.h"
#import "PMessage.h"

@interface BMessageCell : UITableViewCell<BMessageDelegate> {
    UIImage * _meBubbleImage;
    UIImage * _replyBubbleImage;
    UIImageView * _profilePicture;
    UILabel * _timeLabel;
    
    UIImageView * _readMessageImageView;
    
    UILabel * _nameLabel;
    
    id<PMessage, PMessageLayout> _message;
}

@property (nonatomic, readwrite) UIImageView * bubbleImageView;
@property (nonatomic, readwrite) id<PMessage> message;

// Let us open the user profile view
@property (nonatomic, weak) UINavigationController * navigationController;

-(void) willDisplayCell;
-(UIView *) cellContentView;
-(BOOL) supportsCopy;

@end
