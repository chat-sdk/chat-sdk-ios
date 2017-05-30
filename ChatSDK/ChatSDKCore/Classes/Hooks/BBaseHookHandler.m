//
//  BBaseHookHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 30/05/2017.
//
//

#import "BBaseHookHandler.h"
#import <ChatSDKCore/ChatCore.h>

@implementation BBaseHookHandler {
    NSMutableDictionary * _hooks;
}

-(void) addHook: (BHook *) hook withName: (NSString *) name {
    NSMutableArray * existingHooks = _hooks[name];
    if(!existingHooks) {
        existingHooks = [NSMutableArray new];
    }
    if(![existingHooks containsObject:hook]) {
        [existingHooks addObject:hook];
    }
    _hooks[name] = existingHooks;
}

-(void) removeHook: (BHook *) hook withName: (NSString *) name {
    NSMutableArray * existingHooks = _hooks[name];
    if(!existingHooks) {
        return;
    }
    [existingHooks removeObject:hook];
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
