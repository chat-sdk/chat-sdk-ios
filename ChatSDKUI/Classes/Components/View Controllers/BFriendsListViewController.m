//
//  BFriendsListViewController.m
//  NekNominate
//
//  Created by Benjamin Smiley-andrews on 28/01/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "BFriendsListViewController.h"

#import <ChatSDK/ChatCore.h>
#import <ChatSDK/ChatUI.h>

#define bUserCellIdentifier @"bUserCellIdentifier"

#define bContactsSection 0
#define bSectionCount 1
#define bMaxTokenHeight 104

@interface BFriendsListViewController ()

@end

@implementation BFriendsListViewController

@synthesize tableView;
@synthesize usersToInvite;
@synthesize rightBarButtonActionTitle;
@synthesize tokenField;
@synthesize tokenView;
@synthesize groupNameView;
@synthesize groupNameTextField;
@synthesize maximumSelectedUsers;

// If we are creating a thread we want to have the group name field
// If we are adding users we never want to show this field
-(instancetype) initWithUsersToExclude: (NSArray<PUser> *) users {
    if ((self = [self init])) {
        self.title = [NSBundle t:bPickFriends];
        [_contactsToExclude addObjectsFromArray:users];
    }
    return self;
}

-(instancetype) init {
    self = [super initWithNibName:@"BFriendsListViewController" bundle:[NSBundle chatUIBundle]];
    if (self) {
        self.title = [NSBundle t:bPickFriends];
        _contacts = [NSMutableArray new];
        _contactsToExclude = [NSMutableArray new];
        _selectedContacts = [NSMutableArray new];
        _selectedNames = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    groupNameTextField.placeholder = [NSBundle t:bGroupName];
    groupNameTextField.delegate = self;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle t:bBack] style:UIBarButtonItemStylePlain target:self action:@selector(dismissView)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.getRightBarButtonActionTitle style:UIBarButtonItemStylePlain target:self action:@selector(composeMessage)];
    
    // Takes into account the status and navigation bar
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    tokenField.delegate = self;
    tokenField.dataSource = self;
    tokenField.placeholderText = [NSBundle t:bEnterNamesHere];
    tokenField.toLabelText = [NSBundle t:bTo];
    tokenField.userInteractionEnabled = YES;
    tokenField.maxHeight = bMaxTokenHeight;
    
    [tokenField setColorScheme:[UIColor colorWithRed:61/255.0f green:149/255.0f blue:206/255.0f alpha:1.0f]];
    
    tokenView.layer.borderWidth = 0.5;
    tokenView.layer.borderColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0].CGColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:Nil];
    
    [self reloadData];
    
    [tableView registerNib:[UINib nibWithNibName:@"BUserCell" bundle:[NSBundle chatUIBundle]] forCellReuseIdentifier:bUserCellIdentifier];

    [self setGroupNameHidden:YES duration:0];
}

-(NSString *) getRightBarButtonActionTitle {
    if (self.rightBarButtonActionTitle) {
        return self.rightBarButtonActionTitle;
    }
    else if (_selectedContacts.count <= 1) {
        return [NSBundle t: bCompose];
    }
    else {
        return [NSBundle t: bCreateGroup];
    }
}

-(void) updateRightBarButtonActionTitle {
    self.navigationItem.rightBarButtonItem.title = self.getRightBarButtonActionTitle;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    _internetConnectionObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kReachabilityChangedNotification object:nil queue:Nil usingBlock:^(NSNotification * notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![Reachability reachabilityForInternetConnection].isReachable) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        });
    }];
    
    [self reloadData];
}

-(void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.navigationItem.rightBarButtonItem.enabled = newString.length;
    return YES;
}

-(void) setGroupNameHidden: (BOOL) hidden duration: (float) duration {
    [self.view keepAnimatedWithDuration: duration layout:^{
        groupNameView.keepTopInset.equal = hidden ? -46 : 0;
    }];
    if (!hidden) {
        self.navigationItem.rightBarButtonItem.enabled = groupNameTextField.text.length;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:_internetConnectionObserver];
}

-(void) composeMessage {
    
    if (!_selectedContacts.count) {
        [UIView alertWithTitle:[NSBundle t:bInvalidSelection]
                   withMessage:[NSBundle t:bSelectAtLeastOneFriend]];
        return;
    }
    else {
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.usersToInvite != Nil) {
                self.usersToInvite(_selectedContacts, groupNameTextField.text);
            }
        }];
    }
}

#pragma UITableView delegate

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
    
    if (section == bContactsSection) {
        return _contacts.count ? [NSBundle t:bContacts] : @"";
    }
    
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BUserCell * cell = [tableView_ dequeueReusableCellWithIdentifier:bUserCellIdentifier];
    
    id<PUser> user;
    if (indexPath.section == bContactsSection) {
        user = _contacts[indexPath.row];
    }
    
    [cell setUser:user];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == bContactsSection) {
        [self selectUser:_contacts[indexPath.row]];
    }
    
    [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
    
    [UIView animateWithDuration:0.2 animations:^{
        tokenView.keepHeight.equal = tokenField.bounds.size.height;
    }];
    
    [self reloadData];
}

#pragma mark - VENTokenFieldDelegate

- (void)tokenField:(VENTokenField *)tokenField didChangeText:(NSString *)text {
    if (text.length) {
        
        [UIView animateWithDuration:0.2 animations:^{
            tokenView.keepHeight.equal = tokenField.bounds.size.height;
        }];
    }
    _filterByName = text;
    [self reloadData];
}

// This is when we press enter in the text field
- (void)tokenField:(VENTokenField *)tokenField didEnterText:(NSString *)text {
    
    [tokenField reloadData];
    [self reloadData];
    
    [tokenField resignFirstResponder];
}

// This is when we delete a token
- (void)tokenField:(VENTokenField *)tokenField didDeleteTokenAtIndex:(NSUInteger)index {
    
    [self deselectUser:[_selectedContacts objectAtIndex: index]];
    
    [UIView animateWithDuration:0.2 animations:^{
        tokenView.keepHeight.equal = tokenField.bounds.size.height;
    }];
}

#pragma mark - VENTokenFieldDataSource

- (NSString *)tokenField:(VENTokenField *)tokenField titleForTokenAtIndex:(NSUInteger)index {
    return _selectedNames[index];
}

- (NSUInteger)numberOfTokensInTokenField:(VENTokenField *)tokenField {
    return _selectedNames.count;
}

- (void) selectUser: (id<PUser>) user {
    
    if(_selectedContacts.count < maximumSelectedUsers || maximumSelectedUsers <= 0) {
        [_selectedContacts addObject:user];
        [_selectedNames addObject:user.name];
        
        _filterByName = Nil;
        [tokenField reloadData];
        
        // We never want to show this if we are adding users (and therefore have users to exclude)
        [self setGroupNameHidden:_selectedContacts.count < 2 || _contactsToExclude.count duration:0.4];
        
        [self reloadData];
    }
}

- (void) deselectUser: (id<PUser>) user {
    
    if ([_selectedContacts containsObject:user]) {

        // We want to then remove the same index
        NSInteger index = [_selectedContacts indexOfObject:user];
        
        if ([_selectedNames[index] isEqualToString:user.name]) {
            [_selectedNames removeObjectAtIndex:index];
            [_selectedContacts removeObjectAtIndex:index];
        }
        else {
            NSLog(@"Name synchronisation error");
        }
    }
    
    [tokenField reloadData];
    
    // We never want to show this if we are adding users (and therefore have users to exclude)
    [self setGroupNameHidden:_selectedContacts.count < 2 || _contactsToExclude.count duration:0.4];
    
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
        [_contacts addObjectsFromArray:[NM.contact contactsWithType:bUserConnectionTypeContact]];
    }
    else {
        [_contacts addObjectsFromArray: self.overrideContacts()];
    }
    
    [_contacts removeObjectsInArray:_selectedContacts];
    
    // _contactsToExclude is the users already in the thread - make sure we don't include anyone already in the thread
    [_contacts removeObjectsInArray:_contactsToExclude];
    [_contacts sortUsersInAlphabeticalOrder];
    
    if (_filterByName && _filterByName.length) {
        NSPredicate * preda = [NSPredicate predicateWithFormat:@"name contains[c] %@", _filterByName];
        [_contacts filterUsingPredicate:preda];
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
    [self setTableViewBottomContentInset:keyboardBoundsConverted.size.height];
    
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
    
    // Fix - to ensure the tableView can scroll above the keyboard
    [self setTableViewBottomContentInset:0];
    [self.view setNeedsUpdateConstraints];
}

-(void) setTableViewBottomContentInset: (float) inset {
    UIEdgeInsets insets = tableView.contentInset;
    insets.bottom = inset;
    tableView.contentInset = insets;
}

-(void) dismissView {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void)updateButtonStatusForInternetConnection {
    
    BOOL connected = [Reachability reachabilityForInternetConnection].isReachable;
    self.navigationItem.rightBarButtonItem.enabled = connected;
}

@end
