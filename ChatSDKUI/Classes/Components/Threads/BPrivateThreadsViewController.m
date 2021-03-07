//
//  BThreadsViewController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 24/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import "BPrivateThreadsViewController.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

@interface BPrivateThreadsViewController ()

@end

@implementation BPrivateThreadsViewController

-(instancetype) init
{
    self = [super initWithNibName:Nil bundle:[NSBundle uiBundle]];
    if (self) {
        self.title = [NSBundle t:bConversations];
        self.tabBarItem.image = [NSBundle uiImageNamed: @"icn_30_chat"];

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    _editButton = [[UIBarButtonItem alloc] initWithTitle:[NSBundle t:bEdit]
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

    __weak __typeof__(self) weakSelf = self;

    UINavigationController * nav = [BChatSDK.ui friendsNavigationControllerWithUsersToExclude:@[] onComplete:^(NSArray * users, NSString * groupName){
        __typeof__(self) strongSelf = weakSelf;
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:strongSelf.view animated:YES];
        hud.label.text = [NSBundle t:bCreatingThread];
        
        // Create group with group name
        [BChatSDK.thread createThreadWithUsers:users name:groupName threadCreated:^(NSError *error, id<PThread> thread) {
            if (!error) {
                [strongSelf pushChatViewControllerWithThread:thread];
            }
            else {
                [strongSelf alertWithTitle:[NSBundle t:bErrorTitle] withMessage:[NSBundle t:bThreadCreationError]];
            }
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        }];
        
    }];
    
    [self presentViewController:nav animated:YES completion:Nil];
}

-(void) editButtonPressed: (UIBarButtonItem *) item {
    [self toggleEditing];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void) loadThreads {
    [_threads removeAllObjects];
    [_threads addObjectsFromArray:[BChatSDK.thread threadsWithType:bThreadFilterPrivateThread includeDeleted:NO]];
}

-(void) updateLocalNotificationHandler {
    [BChatSDK.ui setLocalNotificationHandler:^(id<PThread> thread) {
        BOOL result = !(thread.type.intValue & bThreadFilterPrivate);
        return result;
    }];
}

-(void) updateBadge {
    [BChatSDK.db privateThreadUnreadMessageCount].thenOnMain(^id(NSNumber * result) {
        self.tabBarItem.badgeValue = result.intValue > 0 ? result.stringValue : nil;
        return nil;
    }, nil);
}

@end
