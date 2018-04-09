//
//  NSBundle+ChatCore.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/07/2017.
//
//

#import <Foundation/Foundation.h>

#define bImageMessage @"bImageMessage"
#define bLocationMessage @"bLocationMessage"
#define bAudioMessage @"bAudioMessage"
#define bVideoMessage @"bVideoMessage"
#define bStickerMessage @"bStickerMessage"

@protocol PMessage;

@interface NSBundle(ChatCore)

+(NSBundle *) chatCoreBundle;
+(NSString *) core_t: (NSString *) string;
+(NSString *) textForMessage: (id<PMessage>) message;

@end
