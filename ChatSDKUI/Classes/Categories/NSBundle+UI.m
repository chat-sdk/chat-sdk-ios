//
//  NSBundle+ChatUI.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 05/04/2015.
//
//

#import "NSBundle+UI.h"
#import <ChatSDK/UI.h>

@implementation NSBundle (ChatUI)

+(NSBundle *) uiBundle {
    return [NSBundle bundleWithName:bUIBundleName];
}

+(UIImage *) uiImageNamed: (NSString *) name {
    return [NSBundle imageNamed:name bundle:bUIBundleName];
}

@end
