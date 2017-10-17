//
//  NSObject+Status.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 18/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import "NSManagedObject+Status.h"
#import <objc/runtime.h>

#define ON_KEY @"on"
#define MESSAGES_ON_KEY @"messagesOn"
#define META_ON_KEY @"metaOn"
#define ONLINE_ON_KEY @"onlineOn"

@implementation NSManagedObject (Status)

-(void) setOn:(BOOL)isOn {
    [self setPath:ON_KEY on:isOn];
}

-(BOOL) on {
    return [self pathOn:ON_KEY];
}

-(void) setMessagesOn:(BOOL)isOn {
    [self setPath:MESSAGES_ON_KEY on:isOn];
}

-(BOOL) messagesOn {
    return [self pathOn:MESSAGES_ON_KEY];
}

-(void) setMetaOn:(BOOL)isOn {
    [self setPath:META_ON_KEY on:isOn];
}

-(BOOL) metaOn {
    return [self pathOn:META_ON_KEY];
}

-(void) setOnlineOn:(BOOL)isOn {
    [self setPath:ONLINE_ON_KEY on:isOn];
}

-(BOOL) onlineOn {
    return [self pathOn:ONLINE_ON_KEY];
}

-(void) setPath: (NSString *) path on: (BOOL) on {
    if (path) {
        objc_setAssociatedObject(self, [path UTF8String], @(on), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

-(BOOL) pathOn: (NSString *) path {
    if (path) {
        NSNumber * isOn = objc_getAssociatedObject(self, [path UTF8String]);
        if (isOn) {
            return [isOn boolValue];
        }
    }
    return NO;
}



@end
