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
    NSMutableArray * existingHooks = [NSMutableArray arrayWithArray:_hooks[name]];
    if(!existingHooks) {
        existingHooks = [NSMutableArray new];
    }
    if(![existingHooks containsObject:hook]) {
        [existingHooks addObject:hook];
    }
    _hooks[name] = existingHooks;
    return hook;
}

-(void) removeHook: (BHook *) hook {
    for (NSString * name in _hooks.allKeys) {
        NSMutableArray * hooks = [NSMutableArray arrayWithArray:_hooks[name]];
        [hooks removeObject:hook];
        _hooks[name] = hooks;
    }
}

-(void) executeHookWithName: (NSString *) name data: (NSDictionary *) data {
    NSArray * existingHooks = [[NSArray arrayWithArray: _hooks[name]] sortedArrayUsingComparator:^NSComparisonResult(BHook * h1, BHook * h2) {
        return h1.weight - h2.weight;
    }];
    if(existingHooks.count) {
        for(BHook * hook in existingHooks) {
//            NSLog(@"Weight: %i", hook.weight);
            [hook execute:data];
        }
    }
}
@end
