//
//  UIImageView+Avatar.h
//  AFNetworking
//
//  Created by ben3 on 28/06/2019.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PUser;
@protocol PElmUser;
@protocol PThread;

@interface UIImageView(Avatar)

-(void) loadAvatar: (id<PElmUser>) user;
-(UIImage *) userDefaultImage;
-(void) setDefaultUserImage;
-(void) loadThreadImage: (id<PThread>) thread;

@end

NS_ASSUME_NONNULL_END
