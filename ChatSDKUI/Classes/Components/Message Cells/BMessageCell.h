//
//  BMessageCell.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 27/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChatSDK/BMessageDelegate.h>
#import <ChatSDK/PElmMessage.h>

// Size of the speech bubble tail
#define bTailSize 5.0

#define bTopCap 13
#define bLeftCapLeft 18
#define bLeftCapRight 13

#define bReadReceiptWidth 36
#define bReadReceiptHeight 24

#define bReadReceiptTopPadding 10

#define bTimeLabelPadding 10
#define bMaxMessageWidth 270
#define bMaxMessageHeight 300
#define bMinMessageHeight 50
#define bUserNameHeight 25
#define bProfilePictureDiameter 36
#define bMessageMarginX 70 // So it doesn't overlap the time stamp

@interface BMessageCell : UITableViewCell<BMessageDelegate> {
    UIImage * _meBubbleImage;
    UIImage * _replyBubbleImage;
    UIImageView * _profilePicture;
    UILabel * _timeLabel;
    
    UIImageView * _readMessageImageView;
    
    UILabel * _nameLabel;
    UIActivityIndicatorView * _activityIndicator;
    
    id<PElmMessage> _message;
}

@property (nonatomic, readwrite) UIImageView * bubbleImageView;
@property (nonatomic, readwrite) id<PElmMessage> message;
@property (nonatomic, readwrite) UIImageView * profilePicture;

// Let us open the user profile view
@property (nonatomic, weak) UINavigationController * navigationController;

-(void) willDisplayCell;
-(UIView *) cellContentView;
-(BOOL) supportsCopy;
+(UIImage *) bubbleWithImage: (UIImage *) bubbleImage withColor: (UIColor *) color;
-(void) hideProfilePicture;

-(void) showActivityIndicator;
-(void) hideActivityIndicator;

-(float) bubbleHeight;
-(float) bubbleWidth;

-(float) cellHeight;
-(float) cellWidth;

-(float) messageHeight;
-(float) messageWidth;

-(UIEdgeInsets) bubbleMargin;
-(UIEdgeInsets) bubblePadding;

+(float) bubbleHeight: (id<PElmMessage>) message maxWidth: (float) maxWidth;
+(float) bubbleWidth: (id<PElmMessage>) message maxWidth: (float) maxWidth;

+(float) cellHeight: (id<PElmMessage>) message maxWidth: (float) maxWidth;
+(float) cellHeight: (id<PElmMessage>) message;
+(float) cellWidth: (id<PElmMessage>) message;

+(float) messageHeight: (id<PElmMessage>) message;
+(float) messageWidth: (id<PElmMessage>) message;

+(UIEdgeInsets) bubbleMargin: (id<PElmMessage>) message;
+(UIEdgeInsets) bubblePadding: (id<PElmMessage>) message;


+(NSNumber *) messageContentHeight: (id<PElmMessage>) message maxWidth: (float) maxWidth;
+(NSNumber *) messageContentWidth: (id<PElmMessage>) message maxWidth: (float) maxWidth;
+(NSValue *) messageBubblePadding: (id<PElmMessage>) message;
+(NSValue *) messageBubbleMargin: (id<PElmMessage>) message;
+(NSNumber *) messageProfilePicturePadding: (id<PElmMessage>) message;

@end
