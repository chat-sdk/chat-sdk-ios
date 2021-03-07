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
#import <ChatSDK/ChatSDK-Swift.h>

#define bUserCellIdentifier @"UserCellIdentifier"
#define bCell @"BTableCell"

#define bMeSection 0
#define bParticipantsSection 1

typedef void(^Action)();

@interface BSection: NSObject

@property (nonatomic, readwrite) NSString * title;
@property (nonatomic, readwrite) Action action;
@property (nonatomic, readwrite) UIColor * textColor;
@property (nonatomic, readwrite) UIColor * legacyTextColor;

-(UIColor *) color;

@end

@implementation BSection

-(instancetype) init: (NSString *) title action: (Action) action color: (UIColor *) color legacyColor: (UIColor *) legacy {
    if ((self = [super init])) {
        self.title = title;
        self.action = action;
        self.textColor = color;
        self.legacyTextColor = legacy;
    }
    return self;
}

-(UIColor *) color {
    if (@available(iOS 13.0, *)) {
        return self.textColor;
    } else {
        return self.legacyTextColor;
    }
}

@end

@interface BUsersViewController () {
    NSMutableArray<BSection *> * _sections;
}

@end

@implementation BUsersViewController

@synthesize tableView;
@synthesize thread = _thread;

-(instancetype) initWithThread: (id<PThread>) thread {

    self = [super initWithNibName:@"BUsersViewController" bundle:[NSBundle uiBundle]];
    if (self) {
        _users = [NSMutableArray new];
        _sections = [NSMutableArray new];
        _thread = thread;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * title = _thread.displayName;
    self.title = title;
    
    NSOperatingSystemVersion version = [[NSProcessInfo processInfo] operatingSystemVersion];
    if (version.majorVersion < 13) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle t:bBack]
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(backButtonPressed)];
    }
    

    NSMutableArray * rightItems = [NSMutableArray new];

    if (self.settingsActions.count) {
        UIBarButtonItem * settings = [[UIBarButtonItem alloc] initWithImage:[NSBundle uiImageNamed:@"icn_75_dots"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(settingsButtonPressed)];
        [rightItems addObject:settings];
    }
    if ([BChatSDK.thread rolesEnabled:_thread.entityID] && [BChatSDK.thread respondsToSelector:@selector(refreshRoles:)]) {
        UIBarButtonItem * refresh = [[UIBarButtonItem alloc] initWithImage:[NSBundle uiImageNamed:@"icn_75_refresh"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(refreshRolesAndReload)];
        [rightItems addObject:refresh];
        [self refreshRolesAndReload];
    }
    
    self.navigationItem.rightBarButtonItems = rightItems;
    self.navigationController.presentationController.delegate = self;

    if (@available(iOS 13.0, *)) {
        tableView.separatorColor = UIColor.systemGray2Color;
    } else {
        tableView.separatorColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:204/255.0 alpha:1];
    }
    
    [tableView registerNib:[UINib nibWithNibName:@"BUserCell" bundle:[NSBundle uiBundle]] forCellReuseIdentifier:bUserCellIdentifier];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:bCell];
    
    __weak __typeof(self) weakSelf = self;
    _internetConnectionHook = [BHook hookOnMain:^(NSDictionary * data) {
        if(!BChatSDK.connectivity.isConnected) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [BChatSDK.hook addHook:_internetConnectionHook withName:bHookInternetConnectivityDidChange];
        
    _threadUsersHook = [BHook hookOnMain:^(NSDictionary * data) {
        [weakSelf reloadOptions];
    }];
    
    [BChatSDK.hook addHook:_threadUsersHook withNames:@[bHookThreadUsersUpdated, bHookThreadUserRoleUpdated]];
    
    [self reloadOptions];
}

-(void) reloadOptions {
    __weak __typeof(self) weakSelf = self;
    
    [_sections removeAllObjects];
    
    if ([BChatSDK.thread canAddUsers:_thread.entityID]) {
        [_sections addObject: [[BSection alloc] init:bAddUsers action:^{
            [weakSelf addUser];
        } color:UIColor.systemBlueColor legacyColor:UIColor.blueColor]];

    }
    
    // Sections
    if ([_thread typeIs:bThreadFilterGroup]) {
        [_sections addObject:[[BSection alloc] init:bLeaveConversation action:^{
            [BChatSDK.thread deleteThread:_thread];
            [BChatSDK.thread leaveThread:_thread];
            
            [weakSelf.navigationController dismissViewControllerAnimated:NO completion:^{
                if (weakSelf.parentNavigationController) {
                    [weakSelf.parentNavigationController popViewControllerAnimated:YES];
                }
            }];
        } color:UIColor.systemRedColor legacyColor:UIColor.redColor]];
    }
    
    if ([BChatSDK.thread canDestroyThread:_thread.entityID]) {
        [_sections addObject:[[BSection alloc] init:bDestroy action:^{
            
            UIAlertAction * deleteAction = [UIAlertAction actionWithTitle:[NSBundle t:bOk] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                [BChatSDK.thread destroyThread:weakSelf.thread];
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                }];
            }];
            
            [weakSelf alertWithTitle:[NSBundle t:bDestroy] withMessage:[NSBundle t:bDestroyAndDelete] actions:@[deleteAction]];
            
        } color:UIColor.systemRedColor legacyColor:UIColor.redColor]];
    }
    [self reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshRolesAndReload];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [BChatSDK.hook removeHook:_internetConnectionHook];
//    [BChatSDK.hook removeHook:_threadUsersHook];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == bMeSection) {
        return 1;
    }
    else if (section == bParticipantsSection) {
        return MAX(_users.count, 1);
    } else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 + _sections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView_ dequeueReusableCellWithIdentifier:bCell];
            
    // Reset the image view
    cell.imageView.image = nil;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.section == bMeSection || indexPath.section == bParticipantsSection) {
        id<PUser> user = [self userForIndexPath:indexPath];

        if(user) {
            BUserCell * userCell = [tableView_ dequeueReusableCellWithIdentifier:bUserCellIdentifier];
            
            [userCell setUser:user];

            userCell.statusImageView.hidden = true;
            [userCell.stateLabel keepVerticallyCentered];
            userCell.stateLabel.text = @"";

            // Get the user connection
            if ([BChatSDK.thread rolesEnabled:_thread.entityID]) {
                NSString * role = [BChatSDK.thread role:_thread.entityID forUser:user.entityID];
                userCell.subtitle.text = [NSBundle t:role];
                
                // Check if the user is active
                id<PUserConnection> connection = [_thread connection:user.entityID];
                if (connection && connection.isActive) {
                    userCell.stateLabel.text = [NSBundle t:bActive];
                }
            }

            cell = userCell;
        } else {
            if (@available(iOS 13.0, *)) {
                cell.textLabel.textColor = [UIColor labelColor];
            } else {
                cell.textLabel.textColor = [UIColor blackColor];
            }
            cell.textLabel.text = [NSBundle t:bNoActiveParticipants];
        }

        return cell;
    }
            
    if (@available(iOS 13.0, *)) {
        cell.textLabel.textColor = [UIColor systemRedColor];
    } else {
        cell.textLabel.textColor = [UIColor redColor];
    }
    BSection * section = _sections[indexPath.section - 2];

    cell.textLabel.textColor = section.color;
    cell.textLabel.text = [NSBundle t:section.title];
    
    return cell;
}

-(id<PUser>) userForIndexPath: (NSIndexPath *) indexPath {
    if (indexPath.section == bMeSection) {
        return BChatSDK.currentUser;
    } else if (indexPath.section == bParticipantsSection && _users.count) {
        return _users[indexPath.row];
    }
    return nil;
}

-(void) addUser {
    // Use initWithThread here to make sure we don't show any users already in the thread
    // Show the friends view controller
    __weak __typeof(self) weakSelf = self;

    BFriendsListViewController * friendsListVC = [BChatSDK.ui friendsViewControllerWithUsersToExclude:_users onComplete:^(NSArray * users, NSString * groupName){
        [BChatSDK.thread addUsers:users toThread:_thread].thenOnMain(^id(id success){
            [weakSelf refreshRolesAndReload];
            return success;
        }, Nil);
    }];
    
    [friendsListVC setRightBarButtonActionTitle:[NSBundle t:bAdd]];
    friendsListVC.hideGroupNameView = YES;
    friendsListVC.maximumSelectedUsers = 0;
        
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:friendsListVC] animated:YES completion:Nil];

}

-(void) refreshRolesAndReload {
    if ([BChatSDK.thread respondsToSelector:@selector(refreshRoles:)]) {
        __weak __typeof(self) weakSelf = self;
        [BChatSDK.thread refreshRoles:_thread.entityID].thenOnMain(^id(id success) {
            // Is this needed because if we refresh, then the updates should be made using notifications
            [weakSelf reloadData];
            return success;
        }, nil);
    } else {
        [self reloadData];
    }
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // The add user button
    if (indexPath.section == bParticipantsSection || indexPath.section == bMeSection) {
        id<PUser> user = [self userForIndexPath:indexPath];
        
        if (user) {
            
            // Launch the moderation view controller if:
            // - User is not me
            // - Roles are enabled
            // - We can moderate that user i.e.
            // -- We can change their role
            // -- We can change moderator
            // -- We can change voice
            
            id<PThreadHandler> th = BChatSDK.thread;
            
            BOOL showModerationView = !user.isMe;
            showModerationView = showModerationView && [th rolesEnabled:_thread.entityID];
            
            if (showModerationView) {
                BOOL canModerateUser = [th canChangeRole:_thread.entityID forUser:user.entityID] || [th canChangeModerator:_thread.entityID forUser:user.entityID] || [th canChangeVoice:_thread.entityID forUser: user.entityID] || [th canRemoveUser:user.entityID fromThread:_thread.entityID];
                showModerationView = showModerationView && canModerateUser;
            }

            if (showModerationView) {
                UIViewController<PModerationViewController> * moderationViewController = [BChatSDK.ui moderationViewControllerWithThread:_thread withUser:user];
                [moderationViewController setDelegate: self];
//                [moderationViewController setDelegateWithDelegate:self];
//                SEL selector = NSSelectorFromString(@"setDelegate:");
//                if ([moderationViewController respondsToSelector:selector]) {
//                    NSInvocation * inv = [NSInvocation invocationWithMethodSignature:[moderationViewController methodSignatureForSelector:selector]];
//                    [inv setSelector:selector];
//                    [inv setTarget:moderationViewController];
//                    [inv setArgument:&(self) atIndex:2];
//                    [inv invoke];
//                }
                [self presentViewController:[[UINavigationController alloc] initWithRootViewController:moderationViewController] animated:YES completion:nil];
            } else {
                // Open the users profile
                UIViewController * profileView = [BChatSDK.ui profileViewControllerWithUser:user];
                [self presentViewController:[[UINavigationController alloc] initWithRootViewController:profileView] animated:YES completion:nil];
            }
            
        }
    } else {
        _sections[indexPath.section - 2].action();
    }
    
    [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) moderationViewWillDisappear {
    [self refreshRolesAndReload];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == bParticipantsSection) {
        return [NSBundle t:bParticipants];
    }
    if (section == bMeSection) {
        return [NSBundle t:bMe];
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)reloadData {
    [_users removeAllObjects];
    for (id<PUser> user in _thread.members) {
        if (!user.isMe) {
            [_users addObject:user];
        }
    }
    
    [_users sortAlphabetical];
    
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

- (void)settingsButtonPressed {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:Nil
                                                                   message:Nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    alert.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;

    for (UIAlertAction * action in self.settingsActions) {
        [alert addAction:action];
    }
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:[NSBundle t:bCancel] style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:Nil];
}

-(NSArray<UIAlertAction *> *) settingsActions {
    NSMutableArray * items = [NSMutableArray new];
    
    __weak __typeof(self) weakSelf = self;
    if (BChatSDK.thread.canMuteThreads) {
        NSString * text = _thread.meta[bMute] ? bUnmute : bMute;
        UIAlertAction *mute = [UIAlertAction actionWithTitle:[NSBundle t:text] style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
            [weakSelf muteUnmuteThread];
        }];
        [items addObject:mute];
    }
    
    return items;
}

-(void) muteUnmuteThread {
    if (_thread.meta[bMute]) {
        [BChatSDK.thread unmuteThread:_thread];
    } else {
        [BChatSDK.thread muteThread:_thread];
    }
}


@end
