//
//  BBackgroundPushNotificationQueue.h
//  AFNetworking
//
//  Created by Ben on 8/24/18.
//

#import <Foundation/Foundation.h>

@class BBackgroundPushAction;

@interface BBackgroundPushNotificationQueue : NSObject {
    NSMutableArray * _queue;
}

-(void) addToQueue: (BBackgroundPushAction *) action;
-(BBackgroundPushAction *) tryFirst;
-(BBackgroundPushAction *) popFirst;

@end
