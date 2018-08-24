//
//  BBackgroundPushNotificationQueue.m
//  AFNetworking
//
//  Created by Ben on 8/24/18.
//

#import "BBackgroundPushNotificationQueue.h"
#import <ChatSDK/Core.h>

@implementation BBackgroundPushNotificationQueue


-(instancetype) init {
    if ((self = [super init])) {
        _queue = [NSMutableArray new];
    }
    return self;
}

-(void) addToQueue: (BBackgroundPushAction *) action {
    if (![_queue containsObject:action]) {
        [_queue addObject:action];
    }
}

-(BBackgroundPushAction *) tryFirst {
    if (_queue.count > 0) {
        return _queue.firstObject;
    }
    return Nil;
}

-(BBackgroundPushAction *) popFirst {
    BBackgroundPushAction * action = self.tryFirst;
    if (action) {
        [_queue removeObject:action];
        return action;
    }
    return Nil;
}

@end
