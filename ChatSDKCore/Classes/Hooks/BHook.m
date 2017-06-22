//
//  BHook.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 30/05/2017.
//
//

#import "BHook.h"

@implementation BHook {
    void(^_function)(NSDictionary * properties);
}

+(id) hook: (void(^)(NSDictionary *)) function {
    return [[self alloc] initWithFunction:function];
}

-(id) initWithFunction: (void(^)(NSDictionary *)) function {
    if((self = [self init])) {
        _function = function;
    }
    return self;
}

-(void) execute: (NSDictionary *) properties {
    if(_function != Nil) {
        _function(properties);
    }
}


@end
