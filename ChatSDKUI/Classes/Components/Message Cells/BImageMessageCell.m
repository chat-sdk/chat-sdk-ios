//
//  BImageMessageCell.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 26/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import "BImageMessageCell.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/PElmMessage.h>
#import <ChatSDK/UI.h>


@implementation BImageMessageCell

@synthesize imageView;

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        imageView = [[UIImageView alloc] init];
        imageView.layer.cornerRadius = 10;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = NO;
        
        [self.bubbleImageView addSubview:imageView];
        
    }
    return self;
}

-(void) setMessage: (id<PElmMessage>) message withColorWeight:(float)colorWeight {
    [super setMessage:message withColorWeight:colorWeight];
    
    // Get rid of the bubble for images
    self.bubbleImageView.image = Nil;
    
    BOOL isDelivered = [message.delivered boolValue] || !message.senderIsMe;
    if (!isDelivered) {
        [self showActivityIndicator];
        imageView.alpha = 0.75;
    }
    else {
        [self hideActivityIndicator];
        imageView.alpha = 1;
    }
    
    //imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIImage * placeholder = [UIImage imageWithData:message.placeholder];
    if (!placeholder) {
        placeholder = [NSBundle uiImageNamed:bDefaultPlaceholderImage];
    }
        
    [imageView sd_setImageWithURL:message.imageURL
                 placeholderImage:placeholder
                          options:SDWebImageLowPriority & SDWebImageScaleDownLargeImages
                        completed:nil];
}

-(UIView *) cellContentView {
    return imageView;
}

#pragma Cell sizing static methods

+(NSNumber *) messageContentHeight: (id<PElmMessage>) message maxWidth: (float) maxWidth {
    if (message.imageHeight > 0 && message.imageWidth > 0) {
        
        // We want the height to be less than the max height and more than the min height
        // First check if the calculated height is bigger than the max height, we take the smaller of these
        // Next we take the max of this value and the min value, this ensures the image is at least the min height
        return @(MAX(bMinMessageHeight, MIN([self messageContentWidth:message maxWidth:maxWidth].intValue * message.imageHeight / message.imageWidth, bMaxMessageHeight)));
    }
    return @(0);
}

+(NSValue *) messageBubblePadding: (id<PElmMessage>) message {
    return [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(3.0, 3.0, 3.0, 3.0)];
}

@end
