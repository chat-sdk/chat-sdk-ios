//
//  BLocationOption.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 17/12/2016.
//
//

#import "BLocationChatOption.h"
#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

@implementation BLocationChatOption

@synthesize parent;

-(UIImage *) icon {
    return [NSBundle uiImageNamed:@"icn_60_location.png"];
}

-(NSString *) title {
    return [NSBundle t:bLocation];
}

-(RXPromise *) execute {
    if(_action == Nil) {
        _action = [[BSelectLocationAction alloc] init];
    }
    return [_action execute].thenOnMain(^id(id location) {
        return [self.parent.delegate sendLocationMessage:location];
    }, Nil);
}

@end
