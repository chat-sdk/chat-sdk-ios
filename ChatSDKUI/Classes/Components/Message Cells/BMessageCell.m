//
//  BMessageCell.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 27/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import "BMessageCell.h"

#import <ChatSDK/ChatUI.h>
#import <ChatSDK/ChatCore.h>
#import <ChatSDK/PElmMessage.h>


@implementation BMessageCell

@synthesize bubbleImageView;
@synthesize message = _message;

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSLog(@"Allocate Cell %@", reuseIdentifier);

        // They aren't selectable
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        // Make sure the selected color is white
        self.selectedBackgroundView = [[UIView alloc] init];

        // Bubble view
        bubbleImageView = [[UIImageView alloc] init];
        bubbleImageView.contentMode = UIViewContentModeScaleToFill;
        bubbleImageView.userInteractionEnabled = YES;

        [self.contentView addSubview:bubbleImageView];
        
        _profilePicture = [[UIImageView alloc] init];
        _profilePicture.clipsToBounds = YES;
        
        [self.contentView addSubview:_profilePicture];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(bTimeLabelPadding, 0, 0, 0)];
        
        _timeLabel.font = [UIFont italicSystemFontOfSize:12];
        if([BChatSDK config].messageTimeFont) {
            _timeLabel.font = [BChatSDK config].messageTimeFont;
        }

        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.userInteractionEnabled = NO;
        
        [self.contentView addSubview:_timeLabel];

        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(bTimeLabelPadding, 0, 0, 0)];
        _nameLabel.userInteractionEnabled = NO;
        
        _nameLabel.font = [UIFont boldSystemFontOfSize:bDefaultUserNameLabelSize];
        if([BChatSDK config].messageNameFont) {
            _nameLabel.font = [BChatSDK config].messageNameFont;
        }
        
        _readMessageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(bTimeLabelPadding, 0, 0, 0)];
        [self setReadStatus:bMessageReadStatusNone];
        
        
        [self.contentView addSubview:_readMessageImageView];
        
        [self.contentView addSubview:_nameLabel];
        
        UITapGestureRecognizer * profileTouched = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProfileView)];
        _profilePicture.userInteractionEnabled = YES;
        [_profilePicture addGestureRecognizer:profileTouched];
    }
    return self;
}

-(void) setReadStatus: (bMessageReadStatus) status {
    NSString * imageName = Nil;

    switch (status) {
        case bMessageReadStatusNone:
            imageName = @"icn_message_received.png";
            break;
        case bMessageReadStatusDelivered:
            imageName = @"icn_message_delivered.png";
            break;
        case bMessageReadStatusRead:
            imageName = @"icn_message_read.png";
            break;
        default:
            break;
    }
    
    if (imageName) {
        _readMessageImageView.image = [NSBundle chatUIImageNamed:imageName];
        
        
    }
    else {
        _readMessageImageView.image = Nil;
    }
}

-(void) setMessage: (id<PElmMessage, PMessageLayout>) message {
    [self setMessage:message withColorWeight:1.0];
}

// Called to setup the current cell for the message
-(void) setMessage: (id<PElmMessage, PMessageLayout>) message withColorWeight: (float) colorWeight {
    
    // Set the message for later use
    _message = message;
    
    BOOL isMine = message.senderIsMe;
    if (isMine) {
        [self setReadStatus:message.readStatus];
    }
    else {
        [self setReadStatus:bMessageReadStatusHide];
    }
    
    bMessagePos position = message.messagePosition;
    id<PElmMessage> nextMessage = message.lazyNextMessage;
    
    // Set the bubble to be the correct color
    bubbleImageView.image = [[BMessageCache sharedCache] bubbleForMessage:message withColorWeight:colorWeight];

    // Hide profile pictures for 1-to-1 threads
    _profilePicture.hidden = message.thread.type.intValue & bThreadType1to1;
    
    // We only want to show the user picture if it is the latest message from the user
    if (position & bMessagePosLast) {
        if (message.userModel) {
            if(message.userModel.imageURL) {
                [_profilePicture sd_setImageWithURL:[NSURL URLWithString: message.userModel.imageURL]
                                   placeholderImage:message.userModel.defaultImage];
            }
            else if (message.userModel.imageAsImage) {
                [_profilePicture setImage:message.userModel.imageAsImage];
            }
            else {
                [_profilePicture setImage:message.userModel.defaultImage];
            }
        }
        else {
            // If the user doesn't have a profile picture set the default profile image
            _profilePicture.image = message.userModel.defaultImage;
            _profilePicture.backgroundColor = [UIColor whiteColor];
        }
    }
    else {
        _profilePicture.image = nil;
    }
    
    if (message.flagged.intValue) {
        _timeLabel.text = [NSBundle t:bFlagged];
    }

    _timeLabel.text = _message.date.messageTimeAt;
    // We use 10 here because if the messages are less than 10 minutes apart, then we
    // can just compare the minute figures. If they were hours apart they could have
    // the same number of minutes
    if (nextMessage && [nextMessage.date minutesFrom:message.date] < 10) {
        if (message.date.minute == nextMessage.date.minute && [message.userModel isEqual: nextMessage.userModel]) {
            _timeLabel.text = Nil;
        }
    }
    
    _nameLabel.text = _message.userModel.name;

//    
//    // We only want to show the name label if the previous message was posted by someone else and if this is enabled in the thread
//    // Or if the message is mine...
    
    _nameLabel.hidden = ![_message showUserNameLabelForPosition:position];
    
    // Hide the read receipt view if this is a public thread or if read receipts are disabled
    _readMessageImageView.hidden = [_message.thread.type intValue] & bThreadFilterPublic || !NM.readReceipt;
}

-(void) willDisplayCell {
    
    id<PMessageLayout> l = [BMessageLayout layoutWithMessage:_message];
    
    // Add an extra margin if there is no profile picture
    float margin = l.bubbleMargin;
    float padding = l.bubblePadding;
    
    // Set the margins and height for message
    [bubbleImageView setFrame:CGRectMake(margin,
                                         margin/2,
                                         l.bubbleWidth + bTailSize,
                                         l.bubbleHeight)];
    
    [_nameLabel setViewFrameY:l.bubbleHeight + 5];
    
    // #1 Because of the text view insets we want the cellContentView of the
    // text cell to extend to the right edge of the bubble
    BOOL isMine = [_message.userModel isEqual:NM.currentUser];
    
    // Update the content view size for the message length
    [self cellContentView].frame = CGRectMake(padding + (!isMine ? bTailSize : 0),
                                              padding,
                                              l.messageWidth + (_message.type.intValue == bMessageTypeText ? padding : 0), // HERE #1
                                              l.messageHeight + (_message.type.intValue == bMessageTypeText ? padding : 0));
    
    // Layout the profile picture
    if (_profilePicture.isHidden) {
        _profilePicture.frame = CGRectZero;
    }
    else {
        float ppDiameter = l.profilePictureDiameter;
        float ppPadding = l.profilePicturePadding;

        [_profilePicture setFrame:CGRectMake(ppPadding,
                                             (l.cellHeight - ppDiameter - l.nameHeight)/2.0,
                                             ppDiameter,
                                             ppDiameter)];
        
        _profilePicture.layer.cornerRadius = ppDiameter / 2.0;
    }
}

// Open the users profile
-(void) showProfileView {
    
    // Cannot view our own profile this way
    if (![_message.userModel.entityID isEqualToString:NM.currentUser.entityID]) {
        
        
        UIViewController * profileView = [[BInterfaceManager sharedManager].a profileViewControllerWithUser:_message.userModel];
        [self.navigationController pushViewController:profileView animated:YES];
    }
}

// Format the cells properly when the device orientation changes
-(void) layoutSubviews {
    [super layoutSubviews];
    
    id<PMessageLayout> l = [BMessageLayout layoutWithMessage:_message];

    BOOL isMine = [_message.userModel isEqual:NM.currentUser];
    
    // Extra x-margin if the profile picture isn't shown
    // TODO: Fix this
    float xMargin =  _profilePicture.image ? 0 : 0;
    
    // Layout the date label this will be the full size of the cell
    // This will automatically center the text in the y direction
    // we'll set the side using text alignment
    [_timeLabel setViewFrameWidth:self.fw - bTimeLabelPadding * 2.0];
    
    // We don't want the label getting in the way of the read receipt
    [_timeLabel setViewFrameHeight:l.cellHeight * 0.8];
    
    [_readMessageImageView setViewFrameWidth:_profilePicture.fw];
    [_readMessageImageView setViewFrameHeight:_profilePicture.fw * 2 / 3];
    [_readMessageImageView setViewFrameY:self.fh - _profilePicture.fw * 2 / 3];

    // Make the width less by the profile picture width means the name and profile picture are inline
    [_nameLabel setViewFrameWidth:self.fw - bTimeLabelPadding * 2.0 - _profilePicture.fw];
    [_nameLabel setViewFrameHeight:l.nameHeight];
    
    // Layout the bubble
    // The bubble is translated the "margin" to the right of the profile picture
    if (!isMine) {
        [_profilePicture setViewFrameX:_profilePicture.hidden ? 0 : l.profilePicturePadding];
        [bubbleImageView setViewFrameX:l.bubbleMargin + _profilePicture.fx + _profilePicture.fw + xMargin];
        [_nameLabel setViewFrameX:bTimeLabelPadding];
        
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    else {
        [_profilePicture setViewFrameX:_profilePicture.hidden ? self.contentView.fw : self.contentView.fw - _profilePicture.fw - l.profilePicturePadding];
        [bubbleImageView setViewFrameX:_profilePicture.fx - l.bubbleWidth - l.bubbleMargin - xMargin];
        //[_nameLabel setViewFrameX: bTimeLabelPadding];
        
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textAlignment = NSTextAlignmentRight;
        
//        // We need to make sure the time label isn't in the way if there is a users name
//        if (self.fh < 50) {
//            [_timeLabel setViewFrameHeight:self.fh * 2 / 3];
//        }
    }
}

-(UIView *) cellContentView {
    NSLog(@"Method: cellContentView must be implemented in sub classes");
    assert(1 == 0);
    return Nil;
}

// Change the color of a bubble. This method takes an image and loops over
// the pixels changing any non-zero pixels to the new color
+(UIImage *) bubbleWithImage: (UIImage *) bubbleImage withColor: (UIColor *) color {

    // Get a CGImageRef so we can use CoreGraphics
    CGImageRef image = bubbleImage.CGImage;
    
    CGFloat width = CGImageGetWidth(image);
    CGFloat height = CGImageGetHeight(image);
    
    // Create a new bitmap context i.e. a buffer to store the pixel data
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel    = 4;
    size_t bytesPerRow      = (width * bitsPerComponent * bytesPerPixel + 7) / 8; // As per the header file for CGBitmapContextCreate
    size_t dataSize         = bytesPerRow * height;
    
    // Allocate some memory to store the pixels
    unsigned char *data = malloc(dataSize);
    memset(data, 0, dataSize);
    
    // Create the context
    CGContextRef context = CGBitmapContextCreate(data, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    // Draw the image onto the context
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    
    // Get the components of our input color
    const CGFloat * colors = CGColorGetComponents(color.CGColor);
    
    // Change the pixels which have alpha > 0 to our new color
    for (int i  = 0 ; i < width * height * 4 ; i+=4)
    {
        // If alpha is not zero
        if (data[i+3] != 0) {
            data[i] = (char) (colors[0] * 255);
            data[i + 1] = (char) (colors[1] * 255);
            data[i + 2] = (char) (colors[2] * 255);
        }
    }
    
    NSInteger leftCapWidth = bubbleImage.leftCapWidth;
    NSInteger topCapHeight = bubbleImage.topCapHeight;
    
    // Write from the context to our new image
    // Make sur to copy across the orientation and scale so the bubbles render
    // properly on a retina screen
    UIImage * newImage = [[UIImage imageWithCGImage:CGBitmapContextCreateImage(context)
                                              scale:bubbleImage.scale
                                        orientation:bubbleImage.imageOrientation] stretchableImageWithLeftCapWidth:leftCapWidth
                                                                                                             topCapHeight:topCapHeight];
    // Free up the memory we used
    CGContextRelease(context);
    free(data);
    CGColorSpaceRelease(colorSpace);
    
    return newImage;
}

-(BOOL) supportsCopy {
    return NO;
}

-(void) dealloc {
    NSLog(@"Dealloc cell %@", self.reuseIdentifier);
}



@end
