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
        //Changed
        self.title = [NSBundle t: NSLocalizedString(@"Chat", nil)];
        self.tabBarItem.image = [NSBundle uiImageNamed:@"chat_icon_unSelected@2x.png"];
        self.tabBarItem.selectedImage = [NSBundle uiImageNamed:@"chat_icon@2x.png"];
        self.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4.0);

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    _editButton = [[UIBarButtonItem alloc] initWithTitle:[NSBundle t: NSLocalizedString(bEdit, nil)]
                                                   style:UIBarButtonItemStylePlain
                                                  target:self
                                                  action:@selector(editButtonPressed:)];
    
    // If we have no threads we don't have the edit button
    self.navigationItem.leftBarButtonItem = _threads.count ? _editButton : nil;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add new group button
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                            target:self
                                                                                            action:@selector(createThread)];
    [self setExtendedLayoutIncludesOpaqueBars:YES];
}

-(void) createThread {
    [self createPrivateThread];
}

-(void) createPrivateThread {
//    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isPoped"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    

    __weak __typeof__(self) weakSelf = self;
    
    UINavigationController * nav = [BChatSDK.ui friendsNavigationControllerWithUsersToExclude:@[] onComplete:^(NSArray * users, NSString * groupName){
        __typeof__(self) strongSelf = weakSelf;
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        hud.label.text = [NSBundle t:bCreatingThread];
        
        // Create group with group name
        [BChatSDK.core createThreadWithUsers:users name:groupName threadCreated:^(NSError *error, id<PThread> thread) {
            if (!error) {
                [strongSelf pushChatViewControllerWithThread:thread];
            }
            else {
                [UIView alertWithTitle:[NSBundle t:bErrorTitle] withMessage:[NSBundle t:bThreadCreationError]];
            }
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        }];
        
    }];
    
    
    [[self navigationController] pushViewController:nav.viewControllers[0] animated:true];
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

-(void) reloadData {
    [_threads removeAllObjects];
    [_threads addObjectsFromArray:[BChatSDK.core threadsWithType:bThreadFilterPrivateThread includeDeleted:NO]];
    [super reloadData];
    
}

@end
