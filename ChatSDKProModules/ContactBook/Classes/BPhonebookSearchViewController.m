//
//  BCustomSearchViewController.m
//  Pods
//
//  Created by Simon Smiley-Andrews on 29/04/2016.
//
//

#import "BPhonebookSearchViewController.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>
#import <ChatSDK/ChatSDK-Swift.h>
#import <ContactBook/ContactBook-Swift.h>

#import "ContactBook.h"

#define bCell @"BCell"

#define bModuleName @"contact_book"

@interface BPhonebookSearchViewController ()

@end

@implementation BPhonebookSearchViewController

@synthesize tableView;
@synthesize addressBookContacts = _addressBookContacts;

- (id)initWithUsersToExclude:(NSArray *)excludedUsers {
    NSBundle * bundle = [NSBundle bundleWithName:[@"Frameworks/ContactBookModule.framework/" stringByAppendingString:bContactBookBundle]];

//    NSBundle * bundle = [NSBundle bundleWithName: bContactBookBundle];
    self = [super initWithNibName:@"BPhonebookSearchViewController" bundle:bundle];
    if (self) {
        self.title = [NSBundle t: bSearch];
        _usersToExclude = excludedUsers;
    }
    return self;
}

-(void) setExcludedUsers: (NSArray *) excludedUsers {
    _usersToExclude = excludedUsers;
}

-(void) setSelectedAction: (void(^)(NSArray * users)) action {
    self.usersSelected = action;
}

- (instancetype)initWithUsersToExclude:(NSArray *)excludedUsers selectedAction:(void (^)(NSArray *))action {
    return [self initWithUsersToExclude:excludedUsers];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSBundle t:bAddUsers];
    
    _selectedUsers = [NSMutableArray new];
    _addressBookContacts = [NSMutableArray new];
    
    NSOperatingSystemVersion version = [[NSProcessInfo processInfo] operatingSystemVersion];
    if (version.majorVersion < 13 || BChatSDK.config.alwaysShowBackButtonOnModalViews) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle t:bBack] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    }
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:bCell];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self searchPhonebook];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _addressBookContacts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView_ dequeueReusableCellWithIdentifier:bCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:bCell];
        cell.imageView.clipsToBounds = YES;
//        cell.imageView.keepSize.equal.value = CGSizeMake(40, 40)

//        cell.imageView.keepWidth.equal = 40;
//        cell.imageView.keepHeight.equal = 40;

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.textColor = [Colors getWithName:Colors.label];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    BPhoneBookUser * user = _addressBookContacts[indexPath.row];
    
    cell.textLabel.text = [user name];
    cell.imageView.image = user.image ? user.image : [Icons getWithName:@"defaultProfile"];
//    cell.imageView.
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.imageView.clipsToBounds = YES;
    cell.imageView.layer.cornerRadius = MAX(cell.frame.size.height/2, 22);
    
    return cell;
}


- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BPhoneBookUser * user = _addressBookContacts[indexPath.row];
    
    UITableViewCell * cell = [tableView_ cellForRowAtIndexPath:indexPath];
    
    // Search for the user
    [ContactBookManager searchForUserWithUser:user].thenOnMain(^id(id<PUser> user) {
        [self showActionSheetToAddToContacts:user cell:cell];
        return user;
    }, ^id(NSError * error) {
        [self showActionSheetToAllowInvite:user cell:cell];
        return error;
    });
//    [self showActionSheetToAllowInvite:user];
    [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) showActionSheetToAllowInvite: (BPhoneBookUser *) user cell: (UITableViewCell *) cell {
    // See if the user exists
    __weak __typeof__(self) weakSelf = self;
    
    UIAlertController * view = [UIAlertController alertControllerWithTitle:[NSBundle t:bInviteContact] message:Nil preferredStyle:UIAlertControllerStyleActionSheet];

    view.popoverPresentationController.sourceView = cell;
//    view.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    
    UIAlertAction * inviteByEmail = [UIAlertAction actionWithTitle:[NSBundle t:bInviteByEmail]
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               [weakSelf inviteByEmail:user];
                                                           }];
    
    UIAlertAction * inviteBySMS = [UIAlertAction actionWithTitle:[NSBundle t:bInviteBySMS]
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             [weakSelf inviteBySMS:user];
                                                         }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:[NSBundle t: bCancel]
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction * action) {
                                                        [view dismissViewControllerAnimated:YES completion:nil];
                                                    }];
    
    if(user.emailAddresses.count > 0) {
        [view addAction:inviteByEmail];
    }
    if(user.phoneNumbers.count > 0 && [MFMessageComposeViewController canSendText]) {
        [view addAction:inviteBySMS];
    }
    [view addAction:cancel];
    
    [self presentViewController:view animated:YES completion:nil];
}

-(void) showActionSheetToAddToContacts: (id<PUser>) user cell: (UITableViewCell *) cell {

    __weak __typeof__(self) weakSelf = self;

    // See if the user exists
    UIAlertController * view = [UIAlertController alertControllerWithTitle:[NSBundle t:bAddContact] message:Nil preferredStyle:UIAlertControllerStyleActionSheet];
    
//    view.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    view.popoverPresentationController.sourceView = cell;

    UIAlertAction * add = [UIAlertAction actionWithTitle:[NSBundle t:bAdd]
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                        [weakSelf addContact:user];
                                                           }];
        
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:[NSBundle t: bCancel]
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction * action) {
                                                        [view dismissViewControllerAnimated:YES completion:nil];
                                                    }];
    
    [view addAction:add];
    [view addAction:cancel];
    
    [self presentViewController:view animated:YES completion:nil];
}

-(void) addContact: (id<PUser>) user {
    __weak __typeof__(self) weakSelf = self;
    [BChatSDK.contact addContact:user withType:bUserConnectionTypeContact].thenOnMain(^id(id success) {
        [weakSelf.view makeToast:[NSBundle t:bSuccess]];
        return nil;
    }, ^id(NSError * error) {
        [weakSelf.view makeToast:error.localizedDescription];
        return nil;
    });
}

-(void) inviteByEmail: (BPhoneBookUser *) user {
    
    NSString *emailTitle = BChatSDK.config.inviteByEmailTitle;
    // Email Content
    NSString *messageBody = BChatSDK.config.inviteByEmailBody;
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:user.emailAddresses.firstObject];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

-(void) inviteBySMS: (BPhoneBookUser *) user {
    MFMessageComposeViewController * vc = [[MFMessageComposeViewController alloc] init];
    vc.messageComposeDelegate = self;
    
    vc.body = BChatSDK.config.inviteBySMSBody;
    vc.recipients = [NSArray arrayWithObjects:user.phoneNumbers.firstObject, nil];
    vc.messageComposeDelegate = self;
    [self presentViewController:vc animated:YES completion:NULL];
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(nullable NSError *)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0) {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void) addUserToAddressBook: (BPhoneBookUser *) user {
    if (user.isContactable) {
        [_addressBookContacts addObject:user];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void) searchPhonebook {
    [_addressBookContacts removeAllObjects];
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.label.text = [NSBundle t:bSearching];
    [tableView reloadData];

    __weak __typeof__(self) weakSelf = self;

    ContactBookManager.getContacts.thenOnMain(^id(NSArray * success) {
        [weakSelf.addressBookContacts addObjectsFromArray:success];
        [weakSelf reloadData];
        [weakSelf hideHUD];
        return success;
    }, ^id(NSError * error) {
        [weakSelf hideHUD];
        return error;
    });

}

-(void) reloadData {
    
    __weak __typeof__(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        [weakSelf.addressBookContacts sortUsingComparator:^NSComparisonResult(BPhoneBookUser * u1, BPhoneBookUser * u2) {
            return [u1.name compare:u2.name];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
        
    });
}

-(void) showHUD: (NSString *) message {
    
    if (!_hud) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        [_hud hideAnimated:NO];
    }
    _hud.label.text = message;
    
    // Sometimes there are operations that take a very small amount of time
    // to complete - this messes up the animation. Really we only want to show the
    // HUD if the user is waiting over a certain amount of time
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(showHudNow) userInfo:Nil repeats:NO];
}

-(void) showHudNow {
    [_hud showAnimated:YES];
}

-(void) hideHUD {
    [self hideHUDWithDuration:0.3];
}

-(void) hideHUDWithDuration: (float) duration {
    [_timer invalidate];
    _timer = Nil;
    
    [_hud hideAnimated:duration == 0 ? NO : YES];
}

- (void)backButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
