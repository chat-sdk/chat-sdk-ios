//
//  BMainControllerLifecycleHelper.h
//  AFNetworking
//
//  Created by Ben on 11/8/17.
//

#import <Foundation/Foundation.h>

@class RXPromise;

@interface BMainControllerLifecycleHelper : NSObject {
    __weak UIViewController * _viewController;
    UIViewController * _loginViewController;
}

-(void) viewDidLoad: (UIViewController *) controller;
-(RXPromise *) viewDidAppear;

@end
