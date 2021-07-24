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
    return [NSBundle bundleWithName:bCoreBundleName];
}

+(NSString *) localizationFileForLang:(NSString *)lang name: (NSString *) name {
    NSString * filename = [[name stringByAppendingString:@"."] stringByAppendingString:lang];
    if ([[self coreBundle] pathForResource:filename ofType:@"strings"]) {
        return filename;
    }
    return nil;
}

+(NSString *) bestLocalizationFileForLang:(NSString *) lang name: (NSString *) name {
    NSString * exact = [self localizationFileForLang:lang name:name];
    if (exact) return exact;
    lang = [[lang componentsSeparatedByString:@"-"] firstObject];
    NSString * general = [self localizationFileForLang:lang name:name];
    if (general) return general;
    return name;
}

+(NSString *) t:(NSString *) string bundle: (NSBundle *) bundle localizable: (NSString *) localizable {
    NSString * lang = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString * localizableFile = [self bestLocalizationFileForLang:lang name:localizable];
    if (!localizableFile) return string;
    
    NSString * localized = NSLocalizedStringFromTableInBundle(string, localizableFile, bundle, @"");
    if (![localized isEqualToString:string]) return localized;

    return NSLocalizedStringFromTableInBundle(string, localizable, bundle, @"");
}

+(NSString *) t:(NSString *) string {
    return [self t:string bundle:[self coreBundle] localizable:bLocalizableFile];
}

+(NSString *) textForMessage: (id<PMessage>) message {
    NSString * text;
    if (message.isReply) {
        text = message.reply;
    }
    else if (message.type.intValue == bMessageTypeImage) {
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
    else if(message.type.intValue == bMessageTypeFile) {
        text = [self t:bFileMessage];
    }
    else {
        text = message.text;
    }
    return text;
}

@end
