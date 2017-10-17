//
//  NSBundle+ChatCore.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/07/2017.
//
//

#import "NSBundle+ChatCore.h"
#import <ChatSDK/NSBundle+Additions.h>

@implementation NSBundle(ChatCore)

+(NSBundle *) chatCoreBundle {
    //.return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:bBundleName ofType:@"bundle"]];
    return [NSBundle bundleWithFramework:@"ChatSDK" name:@"ChatCore"];
}

+(NSString *) core_t: (NSString *) string {
    return NSLocalizedStringFromTableInBundle(string, @"ChatCoreLocalizable", [self chatCoreBundle], @"");
}


@end
