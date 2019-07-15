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

#define bUserCellIdentifier @"bUserCellIdentifier"

//#define bUserCellIdentifier @"UserCellIdentifier"
#define bLeaveCellIdentifier @"LeaveCellIdentifier"

#define bCell @"BTableCell"

#define bParticipantsSection 0
#define bLeaveConvoSection 1
#define bSectionCount 2

@interface BUsersViewController ()

@end

@implementation BUsersViewController

@synthesize tableView;

-(instancetype) initWithThread: (id<PThread>) thread {

    self = [super initWithNibName:@"BUsersViewController" bundle:[NSBundle uiBundle]];
    if (self) {
        
        _users = [NSMutableArray arrayWithArray: thread.users.allObjects];
        [_users removeObject:BChatSDK.currentUser];
        
        _thread = thread;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSBundle t:bDetails];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle t:bBack]
//                                                                             style:UIBarButtonItemStylePlain
//                                                                            target:self
//                                                                            action:@selector(backButtonPressed)];

//    if(_thread.creator.isMe) {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
//                                                                                               target:self
//                                                                                               action:@selector(addUser)];
//    }

    tableView.separatorColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:204/255.0 alpha:1];
    
   // [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:bUserCellIdentifier];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:bLeaveCellIdentifier];
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:bCell];
    [tableView registerNib:[UINib nibWithNibName:@"BUserCell" bundle:[NSBundle uiBundle]] forCellReuseIdentifier:bUserCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc]
                                      initWithFrame:CGRectZero];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   
    _internetConnectionHook = [BHook hook:^(NSDictionary * data) {
        if(!BChatSDK.connectivity.isConnected) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [BChatSDK.hook addHook:_internetConnectionHook withName:bHookInternetConnectivityDidChange];
    
    _threadUsersObserver = [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationThreadUsersUpdated object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadData];
        });
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [BChatSDK.hook removeHook:_internetConnectionHook];

    [[NSNotificationCenter defaultCenter] removeObserver:_threadUsersObserver];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == bParticipantsSection) {
        return _users.count ? _users.count : 1;
    }
    if (section == bLeaveConvoSection) {
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // We only show the add and leave group for private groups
    return 1;
  //  return _thread.type.intValue == bThreadTypePrivateGroup ? bSectionCount : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView_ dequeueReusableCellWithIdentifier:bCell];
    
    cell.textLabel.textColor = [UIColor blackColor];
    
    if (indexPath.section == bParticipantsSection) {
        
        if (_users.count) {
            
            id<PUser> user = _users[indexPath.row];
            
            BUserCell * cell = [tableView_ dequeueReusableCellWithIdentifier:bUserCellIdentifier];
            [cell setUser:user];
            
            return cell;
            
//            cell.textLabel.text = user.name;
//            cell.imageView.image = user && user.imageAsImage ? user.imageAsImage : [NSBundle uiImageNamed: @"icn_user.png"];
//
//            cell.imageView.layer.cornerRadius = 20;
//            cell.imageView.clipsToBounds = YES;
//
//            CGSize itemSize = CGSizeMake(40, 40);
//
//            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
//            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//            [cell.imageView.image drawInRect:imageRect];
//            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//
//            UIGraphicsEndImageContext();
        }
        else {
            cell.textLabel.text = [NSBundle t:bNoActiveParticipants];
            cell.imageView.image = nil;
        }
        
        cell.textLabel.textAlignment = _users.count ? NSTextAlignmentLeft : NSTextAlignmentCenter;
        cell.selectionStyle = _users.count ? UITableViewCellSelectionStyleDefault :UITableViewCellSelectionStyleNone;
        
        return cell;
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

-(void) addUser {
    // Use initWithThread here to make sure we don't show any users already in the thread
    // Show the friends view controller
    UINavigationController * nav = [BChatSDK.ui friendsNavigationControllerWithUsersToExclude:_thread.users.allObjects onComplete:^(NSArray * users, NSString * groupName){
        [BChatSDK.core addUsers:users toThread:_thread].thenOnMain(^id(id success){
            [UIView alertWithTitle:[NSBundle t:bSuccess] withMessage:[NSBundle t:bAdded]];
            
            [self reloadData];
            return Nil;
        }, Nil);
    }];
    [((id<PFriendsListViewController>) nav.topViewController) setRightBarButtonActionTitle:[NSBundle t: bAdd]];
    [self.navigationController pushViewController:[nav topViewController] animated:YES];

 //   [self presentViewController:nav animated:YES completion:Nil];

}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // The add user button
//    if (indexPath.section == bParticipantsSection) {
//
//        if (_users.count) {
//            id<PUser> user = _users[indexPath.row];
//
//            // Open the users profile
//            UIViewController * profileView = [BChatSDK.ui profileViewControllerWithUser:user];
//            [self.navigationController pushViewController:profileView animated:YES];
//        }
//    }
//    if (indexPath.section == bLeaveConvoSection) {
//
//        [BChatSDK.core deleteThread:_thread];
//        [BChatSDK.core leaveThread:_thread];
//
//        [self.navigationController dismissViewControllerAnimated:NO completion:^{
//            if (self.parentNavigationController) {
//                [self.parentNavigationController popViewControllerAnimated:YES];
//            }
//        }];
//    }
//
//    [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
//    if (section == bParticipantsSection) {
//
//        if (_thread.type.integerValue & bThreadFilterPrivate) {
//            return [NSBundle t:bParticipants];
//        }
//        else {
//            return _thread.users.allObjects.count > 0 ? [NSBundle t:bActiveParticipants] : [NSBundle t:bNoActiveParticipants];
//        }
//    }
//    if (section == bLeaveConvoSection) {
//        return @"";
//    }
    return @"";
}

- (void)reloadData {
    
    _users = [NSMutableArray arrayWithArray: _thread.users.allObjects];
    [_users removeObject:BChatSDK.currentUser];
    
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
