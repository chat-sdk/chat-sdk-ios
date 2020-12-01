//
//  UIButton+Avatar.m
//  AFNetworking
//
//  Created by ben3 on 28/06/2019.
//

#import "UIButton+Avatar.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>
#import <ChatSDK/ChatSDK-Swift.h>

@implementation UIButton(Avatar)

-(void) loadAvatarForUser: (id<PUser>) user forControlState: (UIControlState) state {
    if (user.imageURL && user.imageURL.length) {
        [self sd_setImageWithURL:[NSURL URLWithString:user.imageURL]
                          forState:UIControlStateNormal
                  placeholderImage:self.userDefaultImage
                           options: SDWebImageLowPriority & SDWebImageScaleDownLargeImages];
    }
    else {
        UIImage * image = user.imageAsImage;
        if (image) {
            [self setImage:user.imageAsImage forState:state];
        } else {
            [self setImage:self.userDefaultImage forState:state];
        }
    }
}

-(UIImage *) userDefaultImage {
    return [Icons getWithName:Icons.defaultProfile];
}


@end
