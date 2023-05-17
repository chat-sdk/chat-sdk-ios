//
//  BVideoMessageCell.m
//  Chat SDK
//
//  Created by Simon Smiley-Andrews on 16/07/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "BVideoMessageCell.h"
#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

@implementation BVideoMessageCell

@synthesize coverImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        coverImageView = [[UIImageView alloc] init];
        coverImageView.layer.cornerRadius = 10;
        coverImageView.clipsToBounds = YES;
        coverImageView.userInteractionEnabled = YES;
       
        self.bubbleImageView.layer.cornerRadius = 10;
        self.bubbleImageView.clipsToBounds = YES;
        
        [self.bubbleImageView addSubview:coverImageView];
    }
    return self;
}

-(void) setMessage: (id<PElmMessage>) message isSelected: (BOOL) selected {
    [super setMessage:message isSelected:selected];
    
    if (selected) {
        [self showCheck];
    } else {
        [self hideCheck];
    }
    
    // Get rid of the bubble for images
    self.bubbleImageView.image = Nil;
    
    coverImageView.alpha = [message.delivered boolValue] ? 1 : 0.75;
    coverImageView.contentMode = UIViewContentModeScaleAspectFill;

    NSString * imageURL = [self.message meta][bMessageImageURL];
    
    if (imageURL && imageURL.length) {
        
        UIImage * placeholder = [NSBundle uiImageNamed:@"icn_300_placeholder"];
        
        if (message.placeholder) {
            placeholder = [UIImage imageWithData:message.placeholder];
        }
        
        __weak __typeof__(self) weakSelf = self;
        [coverImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]
                          placeholderImage:placeholder
                                 completed:^(UIImage * image, NSError * error, SDImageCacheType cacheType, NSURL * imageURL) {
                                     __typeof__(self) strongSelf = weakSelf;
                                     UIImage * newImage = [strongSelf drawImage:image withBadge:[NSBundle uiImageNamed:@"play-button"]];
                                     strongSelf.coverImageView.image = newImage;
                                 }];
    }
    else {
        UIImage * image = [UIImage imageWithData:message.placeholder];
        [coverImageView setImage:image];
    }}

-(UIView *) cellContentView {
    return coverImageView;
}

// SS-V
-(UIImage *)drawImage:(UIImage*)profileImage withBadge:(UIImage *)badge {
    
    UIGraphicsBeginImageContextWithOptions(profileImage.size, NO, 0.0f);
    
    // Add the extra image in the centre and make its size a third of the width of the picture
    [profileImage drawInRect:CGRectMake(0, 0, profileImage.size.width, profileImage.size.height)];
    [badge drawInRect:CGRectMake(profileImage.size.width/2 - profileImage.size.width/6, profileImage.size.height/2 - profileImage.size.width/6, profileImage.size.width/3, profileImage.size.width/3)];
    
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
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

