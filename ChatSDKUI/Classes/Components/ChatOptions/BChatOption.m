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
    return [NSBundle uiImageNamed:@"icn_60_sticker.png"];
}

-(NSString *) title {
    return [NSBundle t:bSticker];
}

- (RXPromise * ) execute: (NSString *) threadEntityID {
    return [self execute:Nil threadEntityID:threadEntityID];
}

- (RXPromise * ) execute: (UIViewController *) viewController threadEntityID: (NSString *) threadEntityID {
    return [self execute:threadEntityID];
}

- (RXPromise * ) execute: (UIViewController *) viewController threadEntityID: (NSString *) threadEntityID handler: (id<PChatOptionsHandler>) handler {
    return [self execute:viewController threadEntityID:threadEntityID];
}




@end
