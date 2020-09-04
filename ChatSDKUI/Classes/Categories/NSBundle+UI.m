//
//  NSBundle+ChatUI.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 05/04/2015.
//
//

#import "NSBundle+UI.h"
#import <ChatSDK/UI.h>
#import <ChatSDK/ChatSDK-Swift.h>

@implementation NSBundle (ChatUI)

+(NSBundle *) uiBundle {
    return BChatSDK.shared.bundle;
//    return [NSBundle bundleWithName:bUIBundleName];
}

+(UIImage *) uiImageNamed: (NSString *) name {
    return [Icons getWithName:name];
//    return [NSBundle imageNamed:name bundle:bUIBundleName];
}

@end
