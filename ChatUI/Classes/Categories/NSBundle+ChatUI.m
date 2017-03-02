//
//  NSBundle+ChatUI.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 05/04/2015.
//
//

#import "NSBundle+ChatUI.h"

//#define bBundleName @"ChatUI"
#define bBundleName @"ChatSDK-ChatUI"

@implementation NSBundle (ChatUI)

+(NSBundle *) chatUIBundle {
    return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:bBundleName ofType:@"bundle"]];
}

+(NSString *) t: (NSString *) string {
    return NSLocalizedStringFromTableInBundle(string, @"ChatUILocalizable", [self chatUIBundle], @"");
}

+(NSString *) res: (NSString *) name {
    return [bBundleName stringByAppendingFormat:@".bundle/%@", name];
}

@end
