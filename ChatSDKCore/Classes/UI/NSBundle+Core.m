//
//  NSBundle+ChatCore.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/07/2017.
//
//

#import "NSBundle+Core.h"
#import <ChatSDK/Core.h>

#define bLocalizableFile @"ChatSDKLocalizable"

@implementation NSBundle(Core)

+(NSBundle *) coreBundle {
    //.return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:bBundleName ofType:@"bundle"]];
    return [NSBundle bundleWithName:bCoreBundleName];
}

+(NSString *) t: (NSString *) string {
    return NSLocalizedStringFromTableInBundle(string, bLocalizableFile, [self coreBundle], @"");
}

+(NSString *) textForMessage: (id<PMessage>) message {
    NSString * text;
    if (message.type.intValue == bMessageTypeImage) {
        text = [self t:bImageMessage];
    }
    else if(message.type.intValue == bMessageTypeLocation) {
        text = [self t:bLocationMessage];
    }
    else if(message.type.intValue == bMessageTypeAudio) {
        text = [self t:bAudioMessage];
    }
    else if(message.type.intValue == bMessageTypeVideo) {
        text = [self t:bVideoMessage];
    }
    else if(message.type.intValue == bMessageTypeSticker) {
        text = [self t:bStickerMessage];
    }
    else {
        text = message.textString;
    }
    return text;
}

@end
