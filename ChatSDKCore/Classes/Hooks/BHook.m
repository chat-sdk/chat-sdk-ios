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
    dispatch_queue_main_t _queue;
    BOOL _queueSet;
    int _weight;
}

+(instancetype) hook: (void(^)(NSDictionary *)) function {
    return [[self alloc] initWithFunction:function weight:0];
}

+(instancetype) hook: (void(^)(NSDictionary *)) function weight: (int) weight {
    return [[self alloc] initWithFunction:function weight:weight];
}

+(instancetype) hookOnMain: (void(^)(NSDictionary *)) function {
    return [[self alloc] initWithFunction:function onQueue:dispatch_get_main_queue() weight:0];
}

+(instancetype) hookOnMain: (void(^)(NSDictionary *)) function weight: (int) weight {
    return [[self alloc] initWithFunction:function onQueue:dispatch_get_main_queue() weight:weight];
}

-(instancetype) initWithFunction: (void(^)(NSDictionary *)) function onQueue: (dispatch_queue_main_t) queue weight: (int) weight {
    if((self = [self init])) {
        _function = function;
        _queue = queue;
        _queueSet = YES;
        _weight = weight;
    }
    return self;
}

-(instancetype) initWithFunction: (void(^)(NSDictionary *)) function  weight: (int) weight {
    if((self = [self init])) {
        _function = function;
        _weight = weight;
    }
    return self;
}


-(void) execute: (NSDictionary *) properties {
    if(_function != Nil) {
        if (_queueSet) {
            dispatch_async(_queue, ^{
                _function(properties);
            });
        } else {
            _function(properties);
        }
    }
}

-(int) weight {
    return _weight;
}

@end
