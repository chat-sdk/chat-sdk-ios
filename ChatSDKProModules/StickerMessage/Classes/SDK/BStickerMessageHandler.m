//
//  BStickerMessageHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 17/12/2016.
//
//

#import "BStickerMessageHandler.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>
#import "BStickerMessageCell.h"
#import "StickerMessage.h"
#import <MessageModules/MessageModules-Swift.h>

#define bMessageSticker @"sticker"
#define bStickerPlistName @"default-stickers"


@implementation BStickerMessageHandler

-(RXPromise *) sendMessageWithSticker: (NSString *) stickerName url: (NSString *) url threadEntityID: (NSString *) threadID {
    
//    [BChatSDK.db beginUndoGroup];
   
    id<PMessage> message = [[[[BMessageBuilder message] type:bMessageTypeSticker] thread:threadID] build];
    
    [message setMeta:@{bMessageText: stickerName,
                       bMessageSticker: stickerName}];
    
    if (url && url.length) {
        [message setMetaValue:url forKey:bMessageImageURL];
    }

    return [BChatSDK.thread sendMessage:message];
}

-(Class) cellClass {
    return [BStickerMessageCell class];
}

-(UIImage *) imageForName: (NSString *) name {
    return [[StickerMessageModule shared] image:name];
}

@end
