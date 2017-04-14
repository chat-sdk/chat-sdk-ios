//
//  NSBundle+ChatUI.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 05/04/2015.
//
//

#import "NSBundle+ChatUI.h"
#import <ChatSDKCore/NSBundle+Additions.h>

#define bBundleName @"Frameworks/ChatSDKUI.framework/ChatUI"

@implementation NSBundle (ChatUI)

+(NSBundle *) chatUIBundle {
    //.return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:bBundleName ofType:@"bundle"]];
    return [NSBundle bundleWithFramework:@"ChatSDKUI" name:@"ChatUI"];
}

+(NSString *) t: (NSString *) string {
    return NSLocalizedStringFromTableInBundle(string, @"ChatUILocalizable", [self chatUIBundle], @"");
}

+(NSString *) res: (NSString *) name {
    return [bBundleName stringByAppendingFormat:@".bundle/%@", name];
}

+(NSBundle *) chatUIImageNamed: (NSString *) name {
    return [NSBundle imageNamed:name framework:@"ChatSDKUI" bundle:@"ChatUI"];
}

@end
