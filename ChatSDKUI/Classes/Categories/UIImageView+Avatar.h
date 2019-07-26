//
//  UIImageView+Avatar.h
//  AFNetworking
//
//  Created by ben3 on 28/06/2019.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PUser;

@interface UIImageView(Avatar)

-(void) loadAvatar: (id<PUser>) user;

@end

NS_ASSUME_NONNULL_END
