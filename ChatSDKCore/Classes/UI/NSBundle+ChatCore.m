//
//  NSBundle+ChatCore.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/07/2017.
//
//

#import "NSBundle+ChatCore.h"
#import <ChatSDK/NSBundle+Additions.h>
#import <ChatSDK/PMessage.h>

@implementation NSBundle(ChatCore)

+(NSBundle *) chatCoreBundle {
    //.return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:bBundleName ofType:@"bundle"]];
    return [NSBundle bundleWithFramework:@"ChatSDK" name:@"ChatCore"];
}

+(NSString *) core_t: (NSString *) string {
    return NSLocalizedStringFromTableInBundle(string, @"ChatCoreLocalizable", [self chatCoreBundle], @"");
}

+(NSString *) textForMessage: (id<PMessage>) message {
    NSString * text;
    if (message.type.intValue == bMessageTypeImage) {
        text = [self core_t:bImageMessage];
    }
    else if(message.type.intValue == bMessageTypeLocation) {
        text = [self core_t:bLocationMessage];
    }
    else if(message.type.intValue == bMessageTypeAudio) {
        text = [self core_t:bAudioMessage];
    }
    else if(message.type.intValue == bMessageTypeVideo) {
        text = [self core_t:bVideoMessage];
    }
    else if(message.type.intValue == bMessageTypeSticker) {
        text = [self core_t:bStickerMessage];
    }
    else {
        text = message.textString;
    }
    return text;
}

@end
