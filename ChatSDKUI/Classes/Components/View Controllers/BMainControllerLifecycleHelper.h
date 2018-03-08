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

@property (nonatomic, readwrite) UIViewController * loginViewController;
@property (nonatomic, readwrite, weak) UIViewController * mainViewController;

-(void) viewDidLoad: (UIViewController *) controller;
-(RXPromise *) viewDidAppear;
-(void) showLoginScreen;

@end
