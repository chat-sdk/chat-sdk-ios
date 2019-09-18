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

    [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
        [self setSelectedIndex:0];
    }] withName:bHookDidLogout];
    
    [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
        [weakSelf updateBadge];
    }] withNames:@[bHookMessageRecieved, bHookMessageWasDeleted]];

    // When a message is recieved we increase the messages tab number
    [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationBadgeUpdated object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateBadge];
        });
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationThreadRead object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateBadge];
        });
    }];
    
    [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * dict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateBadge];
        });
    }] withNames: @[bHookThreadAdded, bHookThreadRemoved]];
    
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
    
    NSInteger badge = [[NSUserDefaults standardUserDefaults] integerForKey:bMessagesBadgeValueKey];
    [self setPrivateThreadsBadge:badge];
    
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
    [self updateBadge];
    [BChatSDK.core save];
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
    
    [self updateBadge];
}

// If the user changes tab they must be online
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [BChatSDK.core setUserOnline];
    [BChatSDK.core save];
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController * nav = (UINavigationController *) viewController;
        if (nav.viewControllers.count) {
            // Should we enable or disable local notifications? We want to show them on every tab that isn't the thread view
            BOOL showNotification = ![nav.viewControllers.firstObject isEqual:BChatSDK.ui.privateThreadsViewController] && ![nav.viewControllers.firstObject isEqual:BChatSDK.ui.publicThreadsViewController];
            [BChatSDK.ui setShowLocalNotifications:showNotification];
            return;
        }
    }
    [BChatSDK.ui setShowLocalNotifications:NO];
    
}

-(void) updateBadge {
    
    // The message view open with this thread?
    // Get the number of unread messages
    int privateThreadsMessageCount = [self unreadMessagesCount:bThreadFilterPrivate];
    [self setPrivateThreadsBadge:privateThreadsMessageCount];

    if(BChatSDK.config.showPublicThreadsUnreadMessageBadge) {
        int publicThreadsMessageCount = [self unreadMessagesCount:bThreadFilterPublic];
        [self setBadge:publicThreadsMessageCount forViewController:BChatSDK.ui.publicThreadsViewController];
    }
    
    [BChatSDK.core save];
}

-(int) unreadMessagesCount: (bThreadType) type {
    // Get all the threads
    int i = 0;
    NSArray * threads = [BChatSDK.core threadsWithType:type];
    for (id<PThread> thread in threads) {
        for (id<PMessage> message in thread.allMessages) {
            if (!message.isRead) {
                i++;
                break;
            }
        }
    }
    return i;
}

// TODO - move this to a more appropriate place in the code
-(void) setBadge: (int) badge forViewController: (UIViewController *) controller {
    NSInteger index = [BChatSDK.ui.tabBarViewControllers indexOfObject:controller];
    if (index != NSNotFound) {
        // Using self.tabbar will correctly set the badge for the specific index
        NSString * badgeString = badge == 0 ? Nil : [NSString stringWithFormat:@"%i", badge];
       [self.tabBar.items objectAtIndex:index].badgeValue = badgeString;
    }
}

-(void) setPrivateThreadsBadge: (NSInteger) badge {
   [self setBadge:badge forViewController:BChatSDK.ui.privateThreadsViewController];
    
    // Save the value to defaults
    [[NSUserDefaults standardUserDefaults] setInteger:badge forKey:bMessagesBadgeValueKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([BChatSDK.shared.configuration appBadgeEnabled]) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    }
}

-(NSBundle *) uiBundle {
    return [NSBundle uiBundle];
}

@end
