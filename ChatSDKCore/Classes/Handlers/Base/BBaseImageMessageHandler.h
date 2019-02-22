//
//  BBaseImageMessageHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PImageMessageHandler.h>

@interface BBaseImageMessageHandler : NSObject<PImageMessageHandler>

- (UIImage*)imageWithScaledImage:(UIImage*)image maxDimension: (float) maxDimension;
- (UIImage*)imageWithScaledImage:(UIImage*)image;
@end
