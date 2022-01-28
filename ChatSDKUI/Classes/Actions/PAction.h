//
//  PAction.h
//  Pods
//
//  Created by Ben on 12/11/17.
//

#ifndef PAction_h
#define PAction_h

@class RXPromise;

@protocol PAction<NSObject>

-(RXPromise *) execute;

@optional
-(RXPromise *) execute: (UIViewController *) controller;

@end


#endif /* PAction_h */
