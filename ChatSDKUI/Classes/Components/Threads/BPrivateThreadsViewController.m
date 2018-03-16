//
//  BThreadsViewController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 24/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import "BPrivateThreadsViewController.h"

#import <ChatSDK/ChatCore.h>
#import <ChatSDK/ChatUI.h>

@interface BPrivateThreadsViewController ()

@end

@implementation BPrivateThreadsViewController

-(instancetype) init
{
    self = [super initWithNibName:Nil bundle:[NSBundle chatUIBundle]];
    if (self) {
        //self.title = [NSBundle t:bConversations];
        
        self.tabBarItem.image = [NSBundle chatUIImageNamed: @"icn_30_chat.png"];

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    
   // _editButton = [[UIBarButtonItem alloc] initWithTitle:[NSBundle t:bEdit]
//                                                   style:UIBarButtonItemStylePlain
//                                                  target:self
//                                                  action:@selector(editButtonPressed:)];
//
    // If we have no threads we don't have the edit button
   // self.navigationItem.leftBarButtonItem = _threads.count ? _editButton : nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add new group button
    //self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
//                                                                                            target:self
//                                                                                            action:@selector(createThread)];
    UIView *customView = [[UIView alloc]initWithFrame:(CGRectMake(0.0, 0.0, 100.0, 44.0))];
    customView.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    [button setBackgroundImage:[NSBundle chatUIImageNamed:
                                @"hamburger_menu_outlined"]
                      forState:UIControlStateNormal];
    [button setFrame:CGRectMake(32.0, 20.0, 32.0, 32.0)];
    //[button addTarget:self action:@selector(BackBtn) forControlEvents:UIControlEventTouchUpInside];
    //[button addTarget:self action: forControlEvents:UIControlStateNormal];
    [customView addSubview:button];
    
    CGFloat marginX = (CGFloat)(button.frame.origin.x + button.frame.size.width + 16);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(marginX, 10.0, 200.0, 44.0)];
    label.text = @"Chat";
    label.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0  blue:102.0/255.0  alpha:1];
    if (@available(iOS 8.2, *)) {
        label.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
    } else {
        // Fallback on earlier versions
    }
    label.textAlignment = UITextAlignmentLeft;
    [customView addSubview:label];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:customView];
    [self navigationItem].leftBarButtonItem = leftButton;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setValue:@(YES) forKeyPath:@"hidesShadow"];
}

-(void) setupNavBar {
    
    
    
    
    
    
    
}

-(void) createThread {
    [self createPrivateThread];
}

-(void) createPrivateThread {
    
    BFriendsListViewController * flvc = (BFriendsListViewController *) [[BInterfaceManager sharedManager].a friendsViewControllerWithUsersToExclude:@[]];
    
    // The friends view controller will give us a list of users to invite
    flvc.usersToInvite = ^(NSArray * users, NSString * groupName){
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = [NSBundle t:bCreatingThread];
        
        // Create group with group name
        [NM.core createThreadWithUsers:users name:groupName threadCreated:^(NSError *error, id<PThread> thread) {
            if (!error) {
                [self pushChatViewControllerWithThread:thread];
            }
            else {
                [UIView alertWithTitle:[NSBundle t:bErrorTitle] withMessage:[NSBundle t:bThreadCreationError]];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    };
    
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:flvc];
    
    [self presentViewController:navController animated:YES completion:Nil];
}

-(void) editButtonPressed: (UIBarButtonItem *) item {
    [self toggleEditing];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// TODO: Check this
// Called when a thread is to be deleted
//- (void)tableView:(UITableView *)tableView_ commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *) indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete )
//    {
//        id<PThread> thread = _threads[indexPath.row];
//        [[NMdapter deleteThread:thread];
//        [self reloadData];
//    }
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void) reloadData {
    [_threads removeAllObjects];
    [_threads addObjectsFromArray:[NM.core threadsWithType:bThreadFilterPrivateThread]];
    [super reloadData];
}

@end

