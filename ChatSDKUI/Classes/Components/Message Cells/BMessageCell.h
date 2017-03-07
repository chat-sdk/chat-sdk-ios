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
//#import "PMessage.h"
#import <ChatSDKCore/PElmMessage.h>

// Size of the speech bubble tail
#define bTailSize 5.0

#define bTopCap 13
#define bLeftCapLeft 18
#define bLeftCapRight 13

@interface BMessageCell : UITableViewCell<BMessageDelegate> {
    UIImage * _meBubbleImage;
    UIImage * _replyBubbleImage;
    UIImageView * _profilePicture;
    UILabel * _timeLabel;
    
    UIImageView * _readMessageImageView;
    
    UILabel * _nameLabel;
    
    id<PElmMessage, PMessageLayout> _message;
}

@property (nonatomic, readwrite) UIImageView * bubbleImageView;
@property (nonatomic, readwrite) id<PElmMessage, PMessageLayout> message;

// Let us open the user profile view
@property (nonatomic, weak) UINavigationController * navigationController;

-(void) willDisplayCell;
-(UIView *) cellContentView;
-(BOOL) supportsCopy;
+(UIImage *) bubbleWithImage: (UIImage *) bubbleImage withColor: (UIColor *) color;

@end
