//
//  BFriendsListViewController.m
//  NekNominate
//
//  Created by Benjamin Smiley-andrews on 28/01/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "BFriendsListViewController.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>
#import "EmptyChatView.h"

#define bUserCellIdentifier @"bUserCellIdentifier"

#define bContactsSection 0
#define bSectionCount 1

@interface BFriendsListViewController ()

@end

@implementation BFriendsListViewController

@synthesize tableView;
@synthesize usersToInvite;
@synthesize rightBarButtonActionTitle;
@synthesize _tokenField;
@synthesize _tokenView;
@synthesize groupNameView;
@synthesize groupNameTextField;
@synthesize maximumSelectedUsers;

// If we create it with a thread then we look at who is in the thread and make sure they don't come up on the lists
// If we are creating a new thread then we don't mind

-(instancetype) initWithUsersToExclude: (NSArray *) users onComplete: (void(^)(NSArray * users, NSString * name)) action {
    if ((self = [self init])) {
        
        //  BOOL isPoped = [[NSUserDefaults standardUserDefaults]
        // boolForKey:@"isPoped"];
        if (users.count == 0)
        {
            self.title =  [NSBundle t: NSLocalizedString(bPickFriends, nil)];//[NSBundle t:bPickFriends];
        }
        else
        {
            self.title =  [NSBundle t: NSLocalizedString(bInviteFriend, nil)];
        }
       [_contactsToExclude addObjectsFromArray:users];
        self.usersToInvite = action;
    }
    return self;
}



- (BOOL)isModal {
    if([[self presentingViewController] presentedViewController] == self)
        return YES;
    if([[[self navigationController] presentingViewController] presentedViewController] == [self navigationController])
        return YES;
    if([[[self tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]])
        return YES;
    
    return NO;
}


-(instancetype) init {
    self = [super initWithNibName:@"BFriendsListViewController" bundle:[NSBundle uiBundle]];
    if (self) {
        
        //     BOOL isPoped = [[NSUserDefaults standardUserDefaults]
        //  boolForKey:@"isPoped"];
        if ([self isModal])
        {
            self.title =  [NSBundle t: NSLocalizedString(bPickFriends, nil)];//[NSBundle t:bPickFriends];
        }
        else
        {
            self.title =  [NSBundle t: NSLocalizedString(bInviteFriend, nil)];
        }
        
        _selectedContacts = [NSMutableArray new];
        _contacts = [NSMutableArray new];
        _contactsToExclude = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    groupNameTextField.placeholder = [NSBundle t:bGroupName];
    groupNameTextField.delegate = self;
    
    if ([self isMovingFromParentViewController]){
        
    }
    //  BOOL isPoped = [[NSUserDefaults standardUserDefaults]
    //     boolForKey:@"isPoped"];
    if ([self isModal])
    {
        UIImage *image = [[UIImage imageNamed:@"cross"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(dismissView)];
    }
    
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle t:bImageSaved] style:UIBarButtonItemStylePlain target:self action:@selector(dismissView)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.getRightBarButtonActionTitle style:UIBarButtonItemStylePlain target:self action:@selector(composeMessage)];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: [NSBundle t: NSLocalizedString(bBack, nil)]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:@selector(backButtonPressed)];
    
    // Takes into account the status and navigation bar
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.names = [NSMutableArray array];
    _tokenField.delegate = self;
    //  _tokenField.inputTextFieldAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
    
    _tokenField.dataSource = self;
    _tokenField.placeholderText =[NSBundle t: NSLocalizedString(bEnterNamesHere, nil)]; // [NSBundle t:bEnterNamesHere];
    _tokenField.toLabelText = [NSBundle t: NSLocalizedString(bTo, nil)];
    _tokenField.userInteractionEnabled = YES;
    
    [_tokenField setColorScheme:[UIColor colorWithRed:61/255.0f green:149/255.0f blue:206/255.0f alpha:1.0f]];
    
    _tokenView.layer.borderWidth = 0.5;
    _tokenView.layer.borderColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0].CGColor;
    
    //Add empty view
    EmptyChatView *emptyView = [[EmptyChatView alloc] initWithNibName:@"EmptyChatView" bundle:[NSBundle uiBundle]];
    [self.view insertSubview:emptyView.view atIndex:0];
   // [self.view insertSubview:emptyView.view belowSubview:self.tableView];
    //[self.view addSubview:emptyView.view];
    emptyView.view.keepInsets.equal = 0;
    [emptyView setText:NSLocalizedString(@"contacts_empty_view_title_text", nil) setSubTitle:NSLocalizedString(@"contacts_empty_view_subtitle_text", nil) setEmptyImage:[NSBundle uiImageNamed: @"empty_chat_view@2x.png"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:Nil];
    
    [self reloadData];
    
    [tableView registerNib:[UINib nibWithNibName:@"BUserCell" bundle:[NSBundle uiBundle]] forCellReuseIdentifier:bUserCellIdentifier];
    
    [self setGroupNameHidden:YES duration:0];
}

-(NSString *) getRightBarButtonActionTitle {
    if (self.rightBarButtonActionTitle) {
        return self.rightBarButtonActionTitle;
    }
     return [NSBundle t: NSLocalizedString(bCompose, nil)];
//    else if (_selectedContacts.count <= 1) {
//        return [NSBundle t: bCompose];
//    }
//    else {
//        return [NSBundle t: bCreateGroup];
//    }
}

-(void) updateRightBarButtonActionTitle {
    self.navigationItem.rightBarButtonItem.title = self.getRightBarButtonActionTitle;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

    __weak __typeof__(self) weakSelf = self;
    _internetConnectionHook = [BHook hook:^(NSDictionary * data) {
        __typeof__(self) strongSelf = weakSelf;
        if (!BChatSDK.connectivity.isConnected) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [BChatSDK.hook addHook:_internetConnectionHook withName:bHookInternetConnectivityDidChange];

    [self reloadData];
}

-(void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

-(void) showEmptyView:(BOOL)showView {
    [self.tableView setHidden:showView];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.navigationItem.rightBarButtonItem.enabled = newString.length;
    return YES;
}

-(void) setGroupNameHidden: (BOOL) hidden duration: (float) duration {
    [self.view keepAnimatedWithDuration: duration layout:^{
        groupNameView.keepTopInset.equal = hidden ? -46 : 0;
        groupNameView.alpha = hidden ? 0 : 1;
    }];
    if (!hidden) {
        self.navigationItem.rightBarButtonItem.enabled = groupNameTextField.text.length;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [BChatSDK.hook removeHook:_internetConnectionHook];
}

-(void) composeMessage {
    
    if (!_selectedContacts.count) {
        [UIView alertWithTitle:[NSBundle t:bInvalidSelection]
                   withMessage:[NSBundle t:bSelectAtLeastOneFriend]];
        return;
    }
    else {
        //Create Group
        if (_selectedContacts.count > 1)
        {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Group Name"
                                                                                      message: nil
                                                                               preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"Group Name";
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            }];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSArray * textfields = alertController.textFields;
                UITextField * groupName = textfields[0];
                self.usersToInvite(_selectedContacts, groupName.text);
                [self dismissViewControllerAnimated:YES completion:^{
//                    if (self.usersToInvite != Nil) {
                    
//                    }
                }];
                
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else //1-1 chat
        {
            [self.navigationController popViewControllerAnimated:true];
            if (self.usersToInvite != Nil) {
                self.usersToInvite(_selectedContacts, groupNameTextField.text);
            }
//                        [self dismissViewControllerAnimated:YES completion:^{
//                            if (self.usersToInvite != Nil) {
//                                self.usersToInvite(_selectedContacts, groupNameTextField.text);
//                            }
//                        }];
        }
        
        
    }
}

#pragma UITableView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_tokenField resignFirstResponder];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return bSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == bContactsSection) {
        return _contacts.count;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
//    if (section == bContactsSection) {
//        return _contacts.count ? [NSBundle t:bContacts] : @"";
//    }
    
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
 
    BUserCell * cell = [tableView_ dequeueReusableCellWithIdentifier:bUserCellIdentifier];
    
    
    id<PUser> user;
    if (indexPath.section == bContactsSection) {
        user = _contacts[indexPath.row];
    }
    if ([_selectedContacts containsObject:user] || [_contactsToExclude containsObject:user]){
        [cell setSelectedImage];
    }
    else{
        [cell setDeSelectedImage];
    }
    [cell setUser:user];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 71;
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<PUser> user;
//    if ([_contactsToExclude containsObject:user]){
//        return;
//    }
    
    if (indexPath.section == bContactsSection) {
        user = _contacts[indexPath.row];
    }
    
    BOOL value = [[user.meta metaValueForKey:@"can_message"] boolValue];
    if (value == false){
        [self showAlertMessage];
        return;
    }
    if (indexPath.section == bContactsSection) {
        [self selectUser:user];
    }
    self.navigationItem.rightBarButtonItem.enabled = _selectedContacts.count;
    [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
    [tableView_ reloadData];
    
    //    [UIView animateWithDuration:0.2 animations:^{
    //        _tokenView.keepHeight.equal = _tokenField.bounds.size.height;
    //    }];
    
   // [self reloadData];
}

-(void) showAlertMessage {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:NSLocalizedString(@"unavailable", nil)
                                 message:NSLocalizedString(@"application_not_installed", nil)
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Ok", nil)
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - VENTokenFieldDelegate

- (void)tokenField:(VENTokenField *)tokenField didChangeText:(NSString *)text {
    if (text.length) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _tokenView.keepHeight.equal = _tokenField.bounds.size.height;
        }];
        
    }
    _filterByName = text;
    [self reloadData];
}

// This is when we press enter in the text field
- (void)tokenField:(VENTokenField *)tokenField didEnterText:(NSString *)text {
    
   // [_tokenField reloadData];
    [self reloadData];
    
    [_tokenField resignFirstResponder];
}

// This is when we delete a token
- (void)tokenField:(VENTokenField *)tokenField didDeleteTokenAtIndex:(NSUInteger)index {
    
    [self deselectUserWithName:[self.names objectAtIndex:index]];
    
    [UIView animateWithDuration:0.2 animations:^{
        _tokenView.keepHeight.equal = _tokenField.bounds.size.height;
    }];
}

#pragma mark - VENTokenFieldDataSource

- (NSString *)tokenField:(VENTokenField *)tokenField titleForTokenAtIndex:(NSUInteger)index {
    return self.names[index];
}

- (NSUInteger)numberOfTokensInTokenField:(VENTokenField *)tokenField {
    return self.names.count;
}

- (void) selectUser: (id<PUser>) user {
    // for 1-1 chat
    
    // if(_selectedContacts.count < maximumSelectedUsers || maximumSelectedUsers <= 0) {
    if ([_selectedContacts containsObject:user]){
        [_selectedContacts removeObject:user];
    }
    else{
        [_selectedContacts removeAllObjects];
        [_selectedContacts addObject:user];
    }
    //   [self.names addObject:user.name];
    
    _filterByName = Nil;
   // [_tokenField reloadData];
    
    //        [self setGroupNameHidden:_selectedContacts.count < 2 || _contactsToExclude.count > 0 duration:0.4];
    
  //  [self reloadData];
    //   }
    
}

// TODO: This will fail if there are two users with the same name...
- (void) deselectUserWithName: (NSString *) name {
    
    // Get the user we are removing
    for (id<PUser> user in _selectedContacts) {
        if ([name caseInsensitiveCompare:user.name] == NSOrderedSame) {
            [_selectedContacts removeObject:user];
            break;
        }
    }
    
    [self.names removeObject:name];
    [_tokenField reloadData];
    
    [self setGroupNameHidden:_selectedContacts.count + _contactsToExclude.count < 2 duration:0.4];
    
    [self reloadData];
}


#pragma Search functionality

-(void) clearAndReload {
    [tableView reloadData];
}

-(void) reloadData {
    
    // Load contacts
    [_contacts removeAllObjects];
    
    if(_overrideContacts == Nil) {
        [_contacts addObjectsFromArray:[BChatSDK.contact contactsWithType:bUserConnectionTypeContact]];
    }
    else {
        [_contacts addObjectsFromArray: self.overrideContacts()];
    }
    
    //  [_contacts removeObjectsInArray:_selectedContacts];
    
    // _contactsToExclude is the users already in the thread - make sure we don't include anyone already in the thread
//    [_contacts removeObjectsInArray:_contactsToExclude];
//    [_contacts sortOnlineThenAlphabetical];
    [_contacts sortAlphabetical];

    if (_filterByName && _filterByName.length) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", _filterByName];
        [_contacts filterUsingPredicate:predicate];
    }
    
    //Show empty View
    if ([_contacts count] > 0) {
        [self showEmptyView:false];
    }
    else {
        [self showEmptyView:true];
    }
    [tableView reloadData];
    [self updateRightBarButtonActionTitle];
    self.navigationItem.rightBarButtonItem.enabled = _selectedContacts.count;
}


-(void) setUsersToExclude: (NSArray *) users {
    [_contactsToExclude removeAllObjects];
    [_contactsToExclude addObjectsFromArray:users];
    [self reloadData];
}

-(void) setSelectedUsers: (NSArray *) users {
    [_selectedContacts removeAllObjects];
    [_selectedContacts addObjectsFromArray:users];
    [self reloadData];
}


#pragma keyboard notifications

-(void) keyboardWillShow: (NSNotification *) notification {
    
    // Get the keyboard size
    CGRect keyboardBounds = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBoundsConverted = [self.view convertRect:keyboardBounds toView:Nil];
    
    // Get the duration and curve from the notification
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Set the new constraints
    tableView.keepBottomInset.equal = keyboardBoundsConverted.size.height;
    [self.view setNeedsUpdateConstraints];
    
    // Animate using this style because for some reason using blocks doesn't give a smooth animation
    [UIView beginAnimations:Nil context:Nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration.doubleValue];
    [UIView setAnimationCurve:curve.integerValue];
    
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

-(void) keyboardWillHide: (NSNotification *) notification {
    
    // Reduced code as there were slight issues with teh table reloading
    tableView.keepBottomInset.equal = 0;
    [self.view setNeedsUpdateConstraints];
}

-(void) dismissView {
    [self dismissViewControllerAnimated:YES completion:Nil];
}
- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:true];
}
- (void)updateButtonStatusForInternetConnection {
    BOOL connected = BChatSDK.connectivity.isConnected;
    self.navigationItem.rightBarButtonItem.enabled = connected;
}



@end

