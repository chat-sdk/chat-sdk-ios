//
//  BAppTabBarController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 22/05/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "BAppTabBarController.h"

#import <ChatSDK/ChatCore.h>
#import <ChatSDK/ChatUI.h>

#define bMessagesBadgeValueKey @"bMessagesBadgeValueKey"

@interface BAppTabBarController ()

@end

@implementation BAppTabBarController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    self.viewControllers = [[BInterfaceManager sharedManager].a tabBarNavigationViewControllers];

    // Listen to see if the user logs out
    [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationLogout
                                                      object:Nil
                                                       queue:Nil
                                                  usingBlock:^(NSNotification * sender) {
        
        [self showLoginScreen];
        
        // Resets the view which the tab bar loads on
        [self setSelectedIndex:0];
    }];
    
    __weak BAppTabBarController * weakSelf = self;
    
    // When a message is recieved we increase the messages tab number
    [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationBadgeUpdated object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        [weakSelf updateBadge];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationMessageAdded object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        [weakSelf updateBadge];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationThreadRead object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        [weakSelf updateBadge];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationThreadDeleted object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        [weakSelf updateBadge];
    }];
    
    
    NSNumber * badge = [[NSUserDefaults standardUserDefaults] stringForKey:bMessagesBadgeValueKey];
    [self setBadge: badge.intValue];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateBadge];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[BNetworkManager sharedManager].a.auth authenticateWithCachedToken].thenOnMain(^id(id<PUser> user) {
        if (!user) {
            [self showLoginScreen];
        }
        [self updateBadge];
        
        return Nil;
    },^id(NSError * error) {
        [self showLoginScreen];
        return Nil;
    });
}

-(void) showLoginScreen {
    if (![BNetworkManager sharedManager].a.auth.userAuthenticated) {
        if (!_loginViewController) {
            _loginViewController = [BNetworkManager sharedManager].a.auth.challengeViewController;
        }
        [self presentViewController:_loginViewController
                           animated:YES
                         completion:Nil];
    }
    else {
        // Once we are authenticated then start updating the users location
        if([BNetworkManager sharedManager].a.nearbyUsers) {
            [[BNetworkManager sharedManager].a.nearbyUsers startUpdatingUserLocation];
        }
    }
}

// #6704 Start bug fix for v3.0.2
// If the user changes tab they must be online
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [[BNetworkManager sharedManager].a.core setUserOnline];
}
// End bug fix for v3.0.2

-(void) updateBadge {
    
    // The message view open with this thread?
    // Get the number of unread messages
    int count = [BNetworkManager sharedManager].a.core.currentUserModel.unreadMessageCount;
    [self setBadge:count];
    
    // This way does not set the tab bar number
    //[BInterfaceManager sharedManager].a.privateThreadsViewController.tabBarItem.badgeValue = badge;
    
}

// TODO - move this to a more appropriate place in the code
-(void) setBadge: (int) badge {
    NSInteger privateThreadIndex = [self.tabBarController.viewControllers indexOfObject:[BInterfaceManager sharedManager].a.privateThreadsViewController];
    // Using self.tabbar will correctly set the badge for the specific index
    NSString * badgeString = badge == 0 ? Nil : [NSString stringWithFormat:@"%i", badge];
    [self.tabBar.items objectAtIndex:privateThreadIndex].badgeValue = badgeString;
    
    // Save the value to defaults
    [[NSUserDefaults standardUserDefaults] setObject:@(badge) forKey:bMessagesBadgeValueKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([BSettingsManager appBadgeEnabled]) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    }
}

-(NSBundle *) uiBundle {
    return [NSBundle chatUIBundle];
}

@end
