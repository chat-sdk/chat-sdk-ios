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

@synthesize lifecycleHelper = _helper;

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
    
    if(!_helper) {
        _helper = [[BMainControllerLifecycleHelper alloc] init];
    }
    
    [_helper viewDidLoad: self];
    
    self.delegate = self;
    
    NSArray * vcs = [[BInterfaceManager sharedManager].a tabBarNavigationViewControllers];
    self.viewControllers = vcs;

    // Listen to see if the user logs out
    [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationLogout
                                                      object:Nil
                                                       queue:Nil
                                                  usingBlock:^(NSNotification * sender) {
        // Resets the view which the tab bar loads on
        [self setSelectedIndex:0];
    }];
    
    __weak __typeof__(self) weakSelf = self;

    // When a message is recieved we increase the messages tab number
    [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationBadgeUpdated object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateBadge];
        });
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationMessageAdded object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateBadge];
        });
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationMessageRemoved object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateBadge];
        });
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationThreadRead object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateBadge];
        });
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationThreadDeleted object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateBadge];
        });
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationPresentChatView object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(BChatSDK.shared.configuration.shouldOpenChatWhenPushNotificationClicked) {
                id<PThread> thread = notification.userInfo[bNotificationPresentChatView_PThread];
                if(thread) {
                    // Set the tab to the private threads screen
                    NSArray * vcs = [[BInterfaceManager sharedManager].a tabBarViewControllers];
                    NSInteger index = [vcs indexOfObject:[BInterfaceManager sharedManager].a.privateThreadsViewController];
                    
                    
                    if(index != NSNotFound) {
                        [self setSelectedIndex:index];
                        UIViewController * chatViewController = [[BInterfaceManager sharedManager].a chatViewControllerWithThread:thread];
                        
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
        });
    }];
    
    NSInteger badge = [[NSUserDefaults standardUserDefaults] integerForKey:bMessagesBadgeValueKey];
    [self setBadge: badge];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateBadge];
    [NM.core saveToStore];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_helper viewDidAppear].thenOnMain(^id(id<PUser> user) {
        [self updateBadge];
        return Nil;
    }, Nil);
}

// #6704 Start bug fix for v3.0.2
// If the user changes tab they must be online
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [NM.core setUserOnline];
    [NM.core saveToStore];
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController * nav = (UINavigationController *) viewController;
        if (nav.viewControllers.count) {
            // Should we enable or disable local notifications? We want to show them on every tab that isn't the thread view
            BOOL showNotification = ![nav.viewControllers.firstObject isEqual:[BInterfaceManager sharedManager].a.privateThreadsViewController] && ![nav.viewControllers.firstObject isEqual:[BInterfaceManager sharedManager].a.publicThreadsViewController];
            [[BInterfaceManager sharedManager].a setShowLocalNotifications:showNotification];
            return;
        }
    }
    [[BInterfaceManager sharedManager].a setShowLocalNotifications:NO];
    
}
// End bug fix for v3.0.2

-(void) updateBadge {
    
    // The message view open with this thread?
    // Get the number of unread messages
    int count = NM.currentUser.unreadMessageCount;
    [self setBadge:count];
    
    [NM.core save];
    // This way does not set the tab bar number
    //[BInterfaceManager sharedManager].a.privateThreadsViewController.tabBarItem.badgeValue = badge;
    
}

// TODO - move this to a more appropriate place in the code
-(void) setBadge: (NSInteger) badge {
    
    NSInteger privateThreadIndex = [[BInterfaceManager sharedManager].a.tabBarViewControllers indexOfObject:[BInterfaceManager sharedManager].a.privateThreadsViewController];

    // Using self.tabbar will correctly set the badge for the specific index
    NSString * badgeString = badge == 0 ? Nil : [NSString stringWithFormat:@"%i", (int) badge];
    [self.tabBar.items objectAtIndex:privateThreadIndex].badgeValue = badgeString;
    
    // Save the value to defaults
    [[NSUserDefaults standardUserDefaults] setInteger:badge forKey:bMessagesBadgeValueKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([[BChatSDK shared].configuration appBadgeEnabled]) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    }
}

-(NSBundle *) uiBundle {
    return [NSBundle uiBundle];
}

@end
