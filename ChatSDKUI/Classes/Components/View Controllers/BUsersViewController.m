//
//  BUsersViewController.m
//  Chat SDK
//
//  Created by Simon Smiley-Andrews on 05/11/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "BUsersViewController.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

#define bUserCellIdentifier @"UserCellIdentifier"
#define bLeaveCellIdentifier @"LeaveCellIdentifier"

#define bCell @"BTableCell"

#define bParticipantsSection 0
#define bAddParticipantSection 1
#define bLeaveConvoSection 2
#define bSectionCount 3

@interface BUsersViewController ()

@end

@implementation BUsersViewController

@synthesize tableView;

-(instancetype) initWithThread: (id<PThread>) thread {

    self = [super initWithNibName:@"BUsersViewController" bundle:[NSBundle uiBundle]];
    if (self) {
        
        _users = [NSMutableArray arrayWithArray: thread.users.allObjects];
        [_users removeObject:NM.currentUser];
        
        _thread = thread;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSBundle t:bDetails];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle t:bBack]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(backButtonPressed)];
    
    tableView.separatorColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:204/255.0 alpha:1];
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:bUserCellIdentifier];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:bLeaveCellIdentifier];
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:bCell];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _internetConnectionObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kReachabilityChangedNotification object:nil queue:Nil usingBlock:^(NSNotification * notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![Reachability reachabilityForInternetConnection].isReachable) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        });
    }];
    
    _threadUsersObserver = [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationThreadUsersUpdated object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadData];
        });
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:_internetConnectionObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_threadUsersObserver];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == bParticipantsSection) {
        return _users.count ? _users.count : 1;
    }
    if (section == bLeaveConvoSection || section == bAddParticipantSection) {
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // We only show the add and leave group for private groups
    return _thread.type.intValue == bThreadTypePrivateGroup ? bSectionCount : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView_ dequeueReusableCellWithIdentifier:bCell];
    
    cell.textLabel.textColor = [UIColor blackColor];
    
    if (indexPath.section == bParticipantsSection) {
        
        if (_users.count) {
            
            id<PUser> user = _users[indexPath.row];
            
            cell.textLabel.text = user.name;
            cell.imageView.image = user && user.thumbnail ? [UIImage imageWithData:user.thumbnail] : [NSBundle uiImageNamed: @"icn_user.png"];
            
            cell.imageView.layer.cornerRadius = 20;
            cell.imageView.clipsToBounds = YES;
            
            CGSize itemSize = CGSizeMake(40, 40);
            
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
        }
        else {
            cell.textLabel.text = [NSBundle t:bNoActiveParticipants];
            cell.imageView.image = nil;
        }
        
        cell.textLabel.textAlignment = _users.count ? NSTextAlignmentLeft : NSTextAlignmentCenter;
        cell.selectionStyle = _users.count ? UITableViewCellSelectionStyleDefault :UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    if (indexPath.section == bAddParticipantSection) {
        
        // Reset the image view
        cell.imageView.image = nil;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = [NSBundle t:bAddParticipant];
    }
    
    if (indexPath.section == bLeaveConvoSection) {
        
        // Reset the image view
        cell.imageView.image = nil;
        cell.textLabel.text = [NSBundle t:bLeaveConversation];
        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // The add user button
    if (indexPath.section == bParticipantsSection) {
        
        if (_users.count) {
            id<PUser> user = _users[indexPath.row];
            
            // Open the users profile
            UIViewController * profileView = [[BInterfaceManager sharedManager].a profileViewControllerWithUser:user];
            [self.navigationController pushViewController:profileView animated:YES];
        }
    }
    if (indexPath.section == bAddParticipantSection) {
        
        // Use initWithThread here to make sure we don't show any users already in the thread
        // Show the friends view controller
        UINavigationController * nav = [[BInterfaceManager sharedManager].a friendsViewControllerWithUsersToExclude:_thread.users.allObjects onComplete:^(NSArray * users, NSString * groupName){
            
            [NM.core addUsers:users toThread:_thread].thenOnMain(^id(id success){
                [UIView alertWithTitle:[NSBundle t:bSuccess] withMessage:[NSBundle t:bAdded]];
                
                [self reloadData];
                return Nil;
            }, Nil);
        }];
        [((id<PFriendsListViewController>) nav.topViewController) setRightBarButtonActionTitle:[NSBundle t: bAdd]];
        
        [self presentViewController:nav animated:YES completion:Nil];
    }
    if (indexPath.section == bLeaveConvoSection) {
        
        [NM.core deleteThread:_thread];
        [NM.core leaveThread:_thread];
        
        [self.navigationController dismissViewControllerAnimated:NO completion:^{
            if (self.parentNavigationController) {
                [self.parentNavigationController popViewControllerAnimated:YES];
            }
        }];
    }
    
    [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == bParticipantsSection) {
        
        if (_thread.type.integerValue & bThreadFilterPrivate) {
            return [NSBundle t:bParticipants];
        }
        else {
            return _thread.users.allObjects.count > 0 ? [NSBundle t:bActiveParticipants] : [NSBundle t:bNoActiveParticipants];
        }
    }
    if (section == bLeaveConvoSection) {
        return @"";
    }
    return @"";
}

- (void)reloadData {
    
    _users = [NSMutableArray arrayWithArray: _thread.users.allObjects];
    [_users removeObject:NM.currentUser];
    
    [self.tableView reloadData];
}

#pragma TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return NO;
}

- (void)backButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
