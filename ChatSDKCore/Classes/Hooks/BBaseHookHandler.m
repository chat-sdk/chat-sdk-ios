//
//  BBaseHookHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 30/05/2017.
//
//

#import "BBaseHookHandler.h"
#import <ChatSDK/Core.h>

@implementation BBaseHookHandler {
    NSMutableDictionary * _hooks;
}

-(instancetype) init {
    if((self = [super init])) {
        _hooks = [NSMutableDictionary new];
    }
    return self;
}

-(BHook *) addHook: (BHook *) hook withNames: (NSArray<NSString *> *) names {
    for (NSString * name in names) {
        [self addHook:hook withName:name];
    }
    return hook;
}

-(BHook *) addHook: (BHook *) hook withName: (NSString *) name {
    NSMutableArray * existingHooks = _hooks[name];
    if(!existingHooks) {
        existingHooks = [NSMutableArray new];
    }
    if(![existingHooks containsObject:hook] && hook != nil) {
        [existingHooks addObject:hook];
    }
    _hooks[name] = existingHooks;
    return hook;
}

-(void) removeHook: (BHook *) hook {
    for (NSString * name in _hooks.allKeys) {
        [_hooks[name] removeObject:hook];
    }
}

-(void) executeHookWithName: (NSString *) name data: (NSDictionary *) data {
    NSArray * existingHooks = _hooks[name];
    if(existingHooks) {
        for(BHook * hook in existingHooks) {
            [hook execute:data];
        }
    }
}

@end
