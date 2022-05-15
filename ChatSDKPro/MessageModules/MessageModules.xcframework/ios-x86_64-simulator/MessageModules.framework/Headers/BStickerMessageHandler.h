//
//  BStickerMessageHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 17/12/2016.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PStickerMessageHandler.h>

@interface BStickerMessageHandler : NSObject<PStickerMessageHandler> {
    NSString * _stickerPlistName;
    NSBundle * _bundle;
}

@end
