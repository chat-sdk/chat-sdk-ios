//
//  BChatOption.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 17/12/2016.
//
//

#import "BChatOption.h"
#import <ChatSDKCore/ChatCore.h>
#import <ChatSDKUI/ChatUI.h>

@implementation BChatOption

-(UIImage *) icon {
    return [NSBundle chatUIImageNamed:@"icn_60_sticker.png"];
}

-(NSString *) title {
    return [NSBundle t:bSticker];
}

-(RXPromise *) execute {
    return [RXPromise resolveWithResult:Nil];
}

@end
