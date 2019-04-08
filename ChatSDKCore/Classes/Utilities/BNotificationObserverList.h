//
//  BNotificationObserverList.h
//  Pods
//
//  Created by Ben on 9/14/17.
//
//

#import <Foundation/Foundation.h>

@class BHook;

@interface BNotificationObserverList : NSObject {
    NSMutableArray * _observers;
}

-(void) add: (id) observer;
-(void) remove: (id) observer;
-(void) dispose;

@end
