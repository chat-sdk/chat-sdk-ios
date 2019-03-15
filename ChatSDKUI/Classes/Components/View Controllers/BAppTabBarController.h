//
//  BAppTabBarController.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 22/05/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMainControllerLifecycleHelper;

@interface BAppTabBarController : UITabBarController<UITabBarControllerDelegate> {
    UIViewController * _loginViewController;
    BMainControllerLifecycleHelper * _helper;
}

@property (nonatomic, readwrite) BMainControllerLifecycleHelper * lifecycleHelper;


@end
