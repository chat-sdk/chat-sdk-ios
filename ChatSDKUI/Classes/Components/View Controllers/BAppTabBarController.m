//
//  BAppTabBarController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 22/05/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "BAppTabBarController.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>


#define bMessagesBadgeValueKey @"bMessagesBadgeValueKey"

@interface BAppTabBarController ()

@end

@implementation BAppTabBarController

-(instancetype) init {
    if((self = [super init])) {
    }
    return self;
}

-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak __typeof__(self) weakSelf = self;
    
    self.delegate = self;
    
    NSArray * vcs = [BChatSDK.ui tabBarNavigationViewControllers];
    self.viewControllers = vcs;
    [self.tabBar setTranslucent:NO];
    
    [self.navigationController setNavigationBarHidden:YES];
    self.navigationController.toolbarHidden = YES;

    [BChatSDK.hook addHook:[BHook hookOnMain:^(NSDictionary * data) {
        [self setSelectedIndex:0];
    }] withName:bHookDidLogout];
        
    [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationPresentChatView object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Only run this code if this view is visible
            if(BChatSDK.config.shouldOpenChatWhenPushNotificationClicked) {
                if (!BChatSDK.config.shouldOpenChatWhenPushNotificationClickedOnlyIfTabBarVisible || (self.viewIfLoaded && self.viewIfLoaded.window)) {
                    id<PThread> thread = notification.userInfo[bNotificationPresentChatView_PThread];
                    [self presentChatViewWithThread:thread];
                }
            }
        });
    }];
    
    [BChatSDK.hook addHook:[BHook hookOnMain:^(NSDictionary * dict) {
        NSString * title = dict[bHook_TitleString];
        NSString * message = dict[bHook_MessageString];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:[NSBundle t:bOk] style:UIAlertActionStyleCancel handler:nil]];
        [self.selectedViewController presentViewController:alert animated:YES completion:nil];
        
    }] withName:bHookGlobalAlertMessage];
    
}

-(void) presentChatViewWithThread: (id<PThread>) thread {
    if(thread) {
        // Set the tab to the private threads screen
        NSArray * vcs = [BChatSDK.ui tabBarViewControllers];
        NSInteger index = [vcs indexOfObject:BChatSDK.ui.privateThreadsViewController];
        
        
        if(index != NSNotFound) {
            [self setSelectedIndex:index];
            UIViewController * chatViewController = [BChatSDK.ui chatViewControllerWithThread:thread];
            
            // Reset navigation stack
            for(UINavigationController * nav in self.viewControllers) {
                if(nav.viewControllers.count) {
                    [nav setViewControllers:@[nav.viewControllers.firstObject] animated: NO];
                }
            }
            
            [((UINavigationController *)self.viewControllers[index]) pushViewController:chatViewController animated:YES];
        }
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Handle push notifications - open the relevant chat
    BBackgroundPushAction * action = BChatSDK.shared.pushQueue.tryFirst;
    if (action && action.type == bPushActionTypeOpenThread) {
        [BChatSDK.shared.pushQueue popFirst];
        NSString * threadEntityID = action.payload[bPushThreadEntityID];
        if (threadEntityID) {
            id<PThread> thread = [BChatSDK.db fetchOrCreateEntityWithID:threadEntityID withType:bThreadEntity];
            [self presentChatViewWithThread:thread];
        }
    }
    
    [BChatSDK.ui setLocalNotificationHandler:^(id<PThread> thread) {
        return NO;
    }];
    [self updateShowLocalNotifications:self.selectedViewController];

    [BChatSDK.core save];
}

-(void) updateShowLocalNotifications: (UIViewController *) viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController * nav = (UINavigationController *) viewController;
        if (nav.viewControllers.count) {
            if ([nav.viewControllers.firstObject respondsToSelector:@selector(updateLocalNotificationHandler)]) {
                [nav.viewControllers.firstObject performSelector:@selector(updateLocalNotificationHandler)];
            } else {
                [BChatSDK.ui setLocalNotificationHandler:^(id<PThread> thread) {
                    return YES;
                }];
            }
        }
    }
}

// If the user changes tab they must be online
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [BChatSDK.core save];
    [self updateShowLocalNotifications:viewController];
}

-(NSBundle *) uiBundle {
    return [NSBundle uiBundle];
}

@end
