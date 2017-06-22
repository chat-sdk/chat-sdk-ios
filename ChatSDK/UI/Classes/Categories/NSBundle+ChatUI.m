//
//  NSBundle+ChatUI.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 05/04/2015.
//
//

#import "NSBundle+ChatUI.h"
#import <ChatSDK/NSBundle+Additions.h>

#define bBundleName @"Frameworks/ChatSDKUI.framework/ChatUI"

@implementation NSBundle (ChatUI)

+(NSBundle *) chatUIBundle {
    //.return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:bBundleName ofType:@"bundle"]];
    return [NSBundle bundleWithFramework:@"ChatSDKUI" name:@"ChatUI"];
}

+(NSString *) t: (NSString *) string {
    return NSLocalizedStringFromTableInBundle(string, @"ChatUILocalizable", [self chatUIBundle], @"");
}

//+(NSString *) res: (NSString *) name {
//    return [bBundleName stringByAppendingFormat:@".bundle/%@", name];
//}

+(UIImage *) chatUIImageNamed: (NSString *) name {
    return [NSBundle imageNamed:name framework:@"ChatSDKUI" bundle:@"ChatUI"];
}

+(NSString *) chatUIFilePath: (NSString *) name {
    return [NSBundle filePathWithFramework:@"ChatSDKUI" name:@"ChatUI"];
}


@end
