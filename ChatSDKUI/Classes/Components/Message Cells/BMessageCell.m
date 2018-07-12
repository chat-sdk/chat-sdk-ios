//
//  BMessageCelself.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 27/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import "BMessageCell.h"

#import <ChatSDK/UI.h>
#import <ChatSDK/Core.h>
#import <ChatSDK/PElmMessage.h>

@implementation BMessageCell

@synthesize bubbleImageView;
@synthesize message = _message;

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
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
        _readMessageImageView.image = [NSBundle uiImageNamed:imageName];
        
        
    }
    else {
        _readMessageImageView.image = Nil;
    }
}

-(void) setMessage: (id<PElmMessage>) message {
    [self setMessage:message withColorWeight:1.0];
}

// Called to setup the current cell for the message
-(void) setMessage: (id<PElmMessage>) message withColorWeight: (float) colorWeight {
    
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
    _profilePicture.hidden = self.profilePictureHidden;
    
    // We only want to show the user picture if it is the latest message from the user
    if (position & bMessagePosLast) {
        if (message.userModel) {
            if(message.userModel.imageURL) {
                [_profilePicture sd_setImageWithURL:[NSURL URLWithString: message.userModel.imageURL]
                                   placeholderImage:message.userModel.defaultImage options:SDWebImageLowPriority & SDWebImageScaleDownLargeImages];
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
    _readMessageImageView.hidden = _message.thread.type.intValue & bThreadFilterPublic || !NM.readReceipt;
}

-(void) willDisplayCell {
    
    // Add an extra margin if there is no profile picture
    float margin = self.bubbleMargin;
    float padding = self.bubblePadding;
    
    // Set the margins and height for message
    [bubbleImageView setFrame:CGRectMake(margin,
                                         margin/2,
                                         self.bubbleWidth + bTailSize,
                                         self.bubbleHeight)];
    
    [_nameLabel setViewFrameY:self.bubbleHeight + 5];
    
    // #1 Because of the text view insets we want the cellContentView of the
    // text cell to extend to the right edge of the bubble
    BOOL isMine = [_message.userModel isEqual:NM.currentUser];
    
    
    // Layout the profile picture
    if (_profilePicture.isHidden) {
        _profilePicture.frame = CGRectZero;
    }
    else {
        float ppDiameter = [BMessageCell profilePictureDiameter];
        float ppPadding = self.profilePicturePadding;

        [_profilePicture setFrame:CGRectMake(ppPadding,
                                             (self.cellHeight - ppDiameter - self.nameHeight)/2.0,
                                             ppDiameter,
                                             ppDiameter)];
        
        _profilePicture.layer.cornerRadius = ppDiameter / 2.0;
    }
    
    
    // Update the content view size for the message length
    // The cell content view is the view that's inside the bubble that stores the message content
//    [self cellContentView].keepInsets.equal = padding;
    
    [self cellContentView].frame = CGRectMake(padding + (!isMine ? bTailSize : 0),
                                              padding,
                                              self.messageWidth + (_message.type.intValue == bMessageTypeText ? padding: 0),
                                              self.messageHeight + (_message.type.intValue == bMessageTypeText ? padding : 0));

}

-(BOOL) profilePictureHidden {
    return [BMessageCell profilePictureHidden:_message];
}

+(BOOL) profilePictureHidden: (id<PElmMessage>) message {
    return message.thread.type.intValue & bThreadType1to1 && ![BChatSDK config].showUserAvatarsOn1to1Threads;
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
    
    BOOL isMine = [_message.userModel isEqual:NM.currentUser];
    
    // Extra x-margin if the profile picture isn't shown
    // TODO: Fix this
    float xMargin =  _profilePicture.image ? 0 : 0;
    
    // Layout the date label this will be the full size of the cell
    // This will automatically center the text in the y direction
    // we'll set the side using text alignment
    [_timeLabel setViewFrameWidth:self.fw - bTimeLabelPadding * 2.0];
    
    // We don't want the label getting in the way of the read receipt
    [_timeLabel setViewFrameHeight:self.cellHeight * 0.8];
    
    [_readMessageImageView setViewFrameWidth:bReadReceiptWidth];
    [_readMessageImageView setViewFrameHeight:bReadReceiptHeight];
    [_readMessageImageView setViewFrameY:_timeLabel.fh * 2.0 / 3.0];

    // Make the width less by the profile picture width means the name and profile picture are inline
    [_nameLabel setViewFrameWidth:self.fw - bTimeLabelPadding * 2.0 - _profilePicture.fw];
    [_nameLabel setViewFrameHeight:self.nameHeight];
    
    // Layout the bubble
    // The bubble is translated the "margin" to the right of the profile picture
    if (!isMine) {
        [_profilePicture setViewFrameX:_profilePicture.hidden ? 0 : self.profilePicturePadding];
        [bubbleImageView setViewFrameX:self.bubbleMargin + _profilePicture.fx + _profilePicture.fw + xMargin];
        [_nameLabel setViewFrameX:bTimeLabelPadding];
        
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    else {
        [_profilePicture setViewFrameX:_profilePicture.hidden ? self.contentView.fw : self.contentView.fw - _profilePicture.fw - self.profilePicturePadding];
        [bubbleImageView setViewFrameX:_profilePicture.fx - self.bubbleWidth - self.bubbleMargin - xMargin];
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

// MEM1
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
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage * newImage = [[UIImage imageWithCGImage:imageRef
                                              scale:bubbleImage.scale
                                        orientation:bubbleImage.imageOrientation] stretchableImageWithLeftCapWidth:leftCapWidth
                                                                                                             topCapHeight:topCapHeight];
    // Free up the memory we used
    CGImageRelease(imageRef);
    CGContextRelease(context);
    free(data);
    CGColorSpaceRelease(colorSpace);
    
    return newImage;
}

-(BOOL) supportsCopy {
    return NO;
}

-(void) dealloc {
}

// Layout Methods

-(float) messageHeight {
    return [BMessageCell messageHeight:_message];
}

+(float) messageHeight: (id<PElmMessage>) message {
    return [self messageHeight:message maxWidth:bMaxMessageWidth];
}

+(float) messageHeight: (id<PElmMessage>) message maxWidth: (float) maxWidth {
    
    switch ((bMessageType)message.type.intValue) {
        case bMessageTypeImage:
        case bMessageTypeVideo: {
            if (message.imageHeight > 0 && message.imageWidth > 0) {
                
                // We want the height to be less than the max height and more than the min height
                // First check if the calculated height is bigger than the max height, we take the smaller of these
                // Next we take the max of this value and the min value, this ensures the image is at least the min height
                return MAX(bMinMessageHeight, MIN([self messageWidth:message] * message.imageHeight / message.imageWidth, bMaxMessageHeight));
            }
            return 0;
        }
        case bMessageTypeLocation:
            return [self messageWidth:message];
        case bMessageTypeAudio:
            return 50;
        case bMessageTypeSticker:
            return 140;
        default:
            return [self getText: message.textString heightWithFont:[UIFont systemFontOfSize:bDefaultFontSize] withWidth:[self messageWidth:message maxWidth:maxWidth]];
    }
}

-(float) messageWidth {
    return [BMessageCell messageWidth:_message maxWidth:self.maxTextWidth];
}

+(float) messageWidth: (id<PElmMessage>) message {
    return [self messageWidth:message maxWidth:bMaxMessageWidth];
}

+(float) messageWidth: (id<PElmMessage>) message maxWidth: (float) maxWidth {
    switch ((bMessageType)message.type.intValue) {
        case bMessageTypeText:
        case bMessageTypeSystem:
            return [self textWidth:message.textString maxWidth:maxWidth];
        case bMessageTypeImage:
        case bMessageTypeVideo:
        case bMessageTypeLocation:
            return bMaxMessageWidth;
        case bMessageTypeAudio:
            return bMaxMessageWidth;
        case bMessageTypeSticker:
            return 140;
        default:
            return bMaxMessageWidth;
    }
}

+(float) textWidth: (NSString *) text maxWidth: (float) maxWidth {
    if (text) {
        UIFont * font = [UIFont systemFontOfSize:bDefaultFontSize];
        if (font) {
            return [text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName: font}
                                      context:Nil].size.width;
        }
    }
    return 0;
}

-(float) maxTextWidth {
    return [BMessageCell maxTextWidth: _message];
}

+(float) maxTextWidth: (id<PElmMessage>) message {
    return [self currentSize].width - bMessageMarginX - ([self profilePictureHidden:message] ? 0 : self.profilePictureDiameter) - [self bubblePadding: message] * 2 + [self profilePicturePadding: message];
}


-(float) bubbleHeight {
    return [BMessageCell bubbleHeight:_message maxWidth:self.maxTextWidth];
}

//+(float) bubbleHeight: (id<PElmMessage>) message {
//
//}

+(float) bubbleHeight: (id<PElmMessage>) message maxWidth: (float) maxWidth {
    return [BMessageCell messageHeight:message maxWidth:maxWidth] + [BMessageCell bubblePadding:message] * 2;
}

-(float) cellHeight {
    return [BMessageCell cellHeight:_message maxWidth:self.maxTextWidth];
}

+(float) cellHeight: (id<PElmMessage>) message maxWidth: (float) maxWidth {
    return [BMessageCell bubbleHeight:message maxWidth:maxWidth] + [self bubbleMargin:message] + [self nameHeight:message];
}

-(float) nameHeight {
    return [BMessageCell nameHeight:_message];
}

+(float) nameHeight: (id<PElmMessage>) message {
    bMessagePos pos = [message messagePosition];
    // Do we want to show the users name label
    if ([message showUserNameLabelForPosition:pos]) {
        return bUserNameHeight;
    }
    return 0;
}

-(float) bubbleWidth {
    return [BMessageCell bubbleWidth:_message maxWidth:self.maxTextWidth];
}

+(float) bubbleWidth: (id<PElmMessage>) message maxWidth: (float) maxWidth {
    return [BMessageCell messageWidth: message maxWidth:maxWidth] + [self bubblePadding: message] * 2;
}

-(float) bubbleMargin {
    return [BMessageCell bubbleMargin:_message];
}

+(float) bubbleMargin: (id<PElmMessage>) message {
    switch ((bMessageType)message.type.intValue) {
        case bMessageTypeText:
        case bMessageTypeImage:
        case bMessageTypeLocation:
        case bMessageTypeAudio:
        case bMessageTypeVideo:
        case bMessageTypeSystem:
        case bMessageTypeSticker:
            return 2.0;
        case bMessageTypeCustom:
        case bMessageTypeFile:
        default:
            return 0;
    }
}

-(float) bubblePadding {
    return [BMessageCell bubblePadding:_message];
}

+(float) bubblePadding: (id<PElmMessage>) message {
    switch ((bMessageType)message.type.intValue) {
        case bMessageTypeText:
            return 12.0;
        case bMessageTypeImage:
        case bMessageTypeLocation:
        case bMessageTypeAudio:
        case bMessageTypeVideo:
            return 3.0;
        case bMessageTypeSystem:
            return 5.0;
        case bMessageTypeSticker:
            return 0.0;
        case bMessageTypeCustom:
        case bMessageTypeFile:
        default:
            return 0;
    }
}

-(float) profilePicturePadding {
    return [BMessageCell profilePicturePadding:_message];
}

+(float) profilePicturePadding: (id<PElmMessage>) message {
    switch ((bMessageType)message.type.intValue) {
        case bMessageTypeText:
        case bMessageTypeImage:
        case bMessageTypeLocation:
        case bMessageTypeAudio:
        case bMessageTypeVideo:
        case bMessageTypeSticker:
        case bMessageTypeSystem:
            return 4.0;
        case bMessageTypeCustom:
        case bMessageTypeFile:
        default:
            return 0;
    }
}

+(float) profilePictureDiameter {
    return bProfilePictureDiameter;
}

-(float) getTextHeightWithWidth: (float) width {
    return [BMessageCell getText:_message.textString heightWithWidth:width];
}

+(float) getText: (NSString *) text heightWithWidth: (float) width {
    return [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:bDefaultFontSize]}
                                             context:Nil].size.height;
}

-(float) getTextHeightWithFont: (UIFont *) font withWidth: (float) width {
    return [BMessageCell getText:_message.textString heightWithFont:font withWidth:width];
}

+(float) getText: (NSString *) text heightWithFont: (UIFont *) font withWidth: (float) width {
    return [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName: font}
                                             context:Nil].size.height;
}

+(CGSize) currentSize
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size;
}



@end
