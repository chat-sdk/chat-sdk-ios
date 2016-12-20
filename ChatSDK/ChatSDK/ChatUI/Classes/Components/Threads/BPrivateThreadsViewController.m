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

- (id)init
{
    self = [super initWithNibName:Nil bundle:[NSBundle chatUIBundle]];
    if (self) {
        self.title = [NSBundle t:bConversations];
        self.tabBarItem.image = [UIImage imageNamed: [NSBundle res: @"icn_30_chat.png"]];

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    _editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                   style:UIBarButtonItemStylePlain
                                                  target:self
                                                  action:@selector(editButtonPressed:)];
    
    // If we have no threads we don't have the edit button
    self.navigationItem.leftBarButtonItem = _threads.count ? _editButton : nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add new group button
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                            target:self
                                                                                            action:@selector(createThread)];
}

-(void) createThread {
    [self createPrivateThread];
}

-(void) createPrivateThread {
    
    BFriendsListViewController * flvc = [[BInterfaceManager sharedManager].a friendsViewControllerWithUsersToExclude:@[]];
    
    // The friends view controller will give us a list of users to invite
    flvc.usersToInvite = ^(NSArray * users, NSString * groupName){
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = [NSBundle t:bCreatingThread];
        
        // Create group with group name
        [[BNetworkManager sharedManager].a.core createThreadWithUsers:users name:groupName threadCreated:^(NSError *error, id<PThread> thread) {
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
//        [[BNetworkManager sharedManager].adapter deleteThread:thread];
//        [self reloadData];
//    }
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void) reloadData {
    [_threads removeAllObjects];
    [_threads addObjectsFromArray:[[BNetworkManager sharedManager].a.core threadsWithType:bThreadTypePrivateGroup]];
    [_threads addObjectsFromArray:[[BNetworkManager sharedManager].a.core threadsWithType:bThreadType1to1]];
    [super reloadData];
}

@end
