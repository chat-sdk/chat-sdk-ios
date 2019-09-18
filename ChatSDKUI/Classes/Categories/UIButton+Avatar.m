//
//  UIButton+Avatar.m
//  AFNetworking
//
//  Created by ben3 on 28/06/2019.
//

#import "UIButton+Avatar.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

@implementation UIButton(Avatar)

-(void) loadAvatarForUser: (id<PUser>) user forControlState: (UIControlState) state {
    if (user.imageAsImage) {
        [self setImage:user.imageAsImage forState:state];
    } else {
        [self sd_setImageWithURL:[NSURL URLWithString:user.imageURL]
                          forState:UIControlStateNormal
                  placeholderImage:user.defaultImage
                           options: SDWebImageLowPriority & SDWebImageScaleDownLargeImages];
    }
}


@end
