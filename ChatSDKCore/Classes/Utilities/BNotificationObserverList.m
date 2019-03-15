//
//  BNotificationObserverList.m
//  Pods
//
//  Created by Ben on 9/14/17.
//
//

#import "BNotificationObserverList.h"

@implementation BNotificationObserverList

-(instancetype) init {
    if((self = [super init])) {
        _observers = [NSMutableArray new];
    }
    return self;
}

-(void) add: (id) observer {
    [_observers addObject:observer];
}

-(void) remove: (id) observer {
    [_observers removeObject:observer];
}

-(void) dispose {
    for(id observer in _observers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
    [_observers removeAllObjects];
}

@end
