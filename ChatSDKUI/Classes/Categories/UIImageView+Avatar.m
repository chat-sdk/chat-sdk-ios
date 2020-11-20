//
//  UIImageView+Avatar.m
//  AFNetworking
//
//  Created by ben3 on 28/06/2019.
//

#import "UIImageView+Avatar.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

@implementation UIImageView(Avatar)

-(void) loadAvatar: (id<PUser>) user {
    if (user.imageURL && user.imageURL.length) {
        [self sd_setImageWithURL:[NSURL URLWithString:user.imageURL]
                placeholderImage:user.defaultImage
                         options: SDWebImageLowPriority & SDWebImageScaleDownLargeImages];
    } else {
        [self setImage:user.imageAsImage];
    }
}


@end
