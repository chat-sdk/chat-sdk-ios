//
//  BLocationOption.m
//  ChatSDK
//
//  Created by Benjamin Smiley-andrews on 17/12/2016.
//
//

#import "BLocationChatOption.h"
#import <ChatSDK/ChatCore.h>
#import <ChatSDK/ChatUI.h>

@class BLocationPickerControllerDelegate;

@interface BLocationChatOption() {
    BSelectLocationAction * action;
}
@end

@implementation BLocationChatOption

@synthesize parent;

-(UIImage *) icon {
    return [NSBundle chatUIImageNamed:@"icn_60_location.png"];
}

-(NSString *) title {
    return [NSBundle t:bLocation];
}

-(RXPromise *) execute {
    if (!action) {
        action = [[BSelectLocationAction alloc] initWithViewController:self.parent.delegate.currentViewController];
    }

    return [action execute].thenOnMain(^id(CLLocation * location) {
        return [self.parent.delegate sendLocationMessage:location];
    }, Nil);
}

@end
