//
//  BStickerChatOption.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 17/12/2016.
//
//

#import "BStickerChatOption.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>
#import "StickerMessage.h"
#import <MessageModules/MessageModules-Swift.h>

@implementation BStickerChatOption

-(UIImage *) icon {
    return [StickerMessageModule.shared image:@"icn_60_sticker.png"];
}

-(NSString *) title {
    return [NSBundle t:bSticker];
}

- (RXPromise * ) execute: (UIViewController *) viewController threadEntityID: (NSString *) threadEntityID handler: (id<PChatOptionsHandler>) handler {
    
    RXPromise * promise = [RXPromise new];
   
    _stickerView = [[BStickerView alloc] initWithFrame:CGRectZero];
    _stickerView.sendSticker = ^(NSString * stickerName, NSString * url) {
        if (BChatSDK.stickerMessage) {
            if (url && url.length || stickerName && stickerName.length) {
                [promise resolveWithResult:[BChatSDK.stickerMessage sendMessageWithSticker:stickerName url:url threadEntityID:threadEntityID]];
            } else {
                [promise rejectWithReason:Nil];
            }
        } else {
            [promise rejectWithReason:Nil];

        }
    };
    _stickerView.back = ^(){
        [handler dismissView];
        [promise resolveWithResult:Nil];
    };
   
    [handler presentView:_stickerView];
    
    return promise;
}



@end
