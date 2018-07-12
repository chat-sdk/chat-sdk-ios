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
    
    imageView.alpha = [message.delivered boolValue] ? 1 : 0.75;
    //imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIImage * placeholder = [UIImage imageWithData:message.placeholder];
    if (!placeholder) {
        placeholder = [NSBundle uiImageNamed:bDefaultPlaceholderImage];
    }
        
    [imageView sd_setImageWithURL:message.thumbnailURL
                 placeholderImage:placeholder
                          options:SDWebImageLowPriority & SDWebImageScaleDownLargeImages
                        completed:nil];
}

-(UIView *) cellContentView {
    return imageView;
}

@end
