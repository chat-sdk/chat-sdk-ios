//
//  BAppTabBarController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 22/05/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "BAppTabBarController.h"

#import <ChatSDKCore/ChatCore.h>
#import <ChatSDKUI/ChatUI.h>


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
    
    NSArray * vcs = [[BInterfaceManager sharedManager].a tabBarNavigationViewControllers];
    self.viewControllers = vcs;

    // Listen to see if the user logs out
    [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationLogout
                                                      object:Nil
                                                       queue:Nil
                                                  usingBlock:^(NSNotification * sender) {
        
                                                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                          [self showLoginScreen];
                                                      });
//        [self showLoginScreen];
        
        // Resets the view which the tab bar loads on
        [self setSelectedIndex:0];
    }];
    
    __weak BAppTabBarController * weakSelf = self;
    
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
    
    
    NSNumber * badge = [[NSUserDefaults standardUserDefaults] stringForKey:bMessagesBadgeValueKey];
    [self setBadge: badge.intValue];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateBadge];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [NM.auth authenticateWithCachedToken].thenOnMain(^id(id<PUser> user) {
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
    if (!NM.auth.userAuthenticated) {
        if (!_loginViewController) {
            _loginViewController = NM.auth.challengeViewController;
        }
        [self presentViewController:_loginViewController
                           animated:YES
                         completion:Nil];
    }
    else {
        // Once we are authenticated then start updating the users location
        if(NM.nearbyUsers) {
            [NM.nearbyUsers startUpdatingUserLocation];
        }
    }
}

// #6704 Start bug fix for v3.0.2
// If the user changes tab they must be online
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [NM.core setUserOnline];
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
-(void) setBadge: (int) badge {
    
    NSInteger privateThreadIndex = [[BInterfaceManager sharedManager].a.tabBarViewControllers indexOfObject:[BInterfaceManager sharedManager].a.privateThreadsViewController];

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
