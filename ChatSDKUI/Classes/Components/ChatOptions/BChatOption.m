//
//  BChatOption.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 17/12/2016.
//
//

#import "BChatOption.h"
#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

@implementation BChatOption

-(UIImage *) icon {
    return [NSBundle uiImageNamed:@"icn_60_sticker"];
}

-(NSString *) title {
    return [NSBundle t:bSticker];
}

- (RXPromise * ) execute: (UIViewController *) viewController threadEntityID: (NSString *) threadEntityID handler: (id<PChatOptionsHandler>) handler {
    return nil;
}

@end
