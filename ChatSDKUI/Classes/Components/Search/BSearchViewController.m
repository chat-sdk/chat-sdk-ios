//
//  BSearchViewController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 27/05/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "BSearchViewController.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

#define bCellIdentifier @"bCellIdentifier"

@interface BSearchViewController ()

@end

@implementation BSearchViewController

@synthesize tableView;
@synthesize searchBox;
@synthesize searchTermButton;
@synthesize activityView;
@synthesize usersSelected;
@synthesize addButton = _addButton;
@synthesize selectedUsers = _selectedUsers;
@synthesize currentSearchIndex = _currentSearchIndex;
@synthesize searchTermNavigationController = _searchTermNavigationController;

-(instancetype) initWithUsersToExclude: (NSArray *) excludedUsers {
    return [self initWithUsersToExclude:excludedUsers selectedAction:Nil];
}

-(instancetype) initWithUsersToExclude: (NSArray *) excludedUsers selectedAction: (void(^)(NSArray * users)) action {
    
    self = [super initWithNibName:@"BSearchViewController" bundle:[NSBundle uiBundle]];
    if (self) {
        _users = [NSMutableArray new];
        _selectedUsers = [NSMutableArray new];
        
        self.title = [NSBundle t: bSearch];
       
        _usersToExclude = excludedUsers;
        self.usersSelected = action;
        _showKeyboardOnLoad = YES;
        
//        _searchController = [[UISearchController alloc] initWithSearchResultsController:Nil];
//        _searchController.searchResultsUpdater = self;
//        _searchController.delegate = self;
//        _searchController.searchBar.delegate = self;
//
//        _searchController.hidesNavigationBarDuringPresentation = NO;
//        _searchController.dimsBackgroundDuringPresentation = YES;
        
//        self.navigationItem.titleView = _searchController.searchBar;
//        self.definesPresentationContext = YES;
        
        
    }
    return self;
}

//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//    NSLog(@"Now");
//}

-(void) setExcludedUsers: (NSArray *) excludedUsers {
    _usersToExclude = excludedUsers;
}

-(void) showKeyboardOnLoad: (BOOL) showKeyboard {
    _showKeyboardOnLoad = showKeyboard;
}

-(void) setSelectedAction: (void(^)(NSArray * users)) action {
    self.usersSelected = action;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([NM.search respondsToSelector:@selector(availableIndexes)]) {
        // Get the search terms...
        [self startActivityIndicator];
        
        __weak __typeof__(self) weakSelf = self;

        [NM.search availableIndexes].thenOnMain(^id(NSArray * indexes) {
            __typeof__(self) strongSelf = weakSelf;
            
            NSMutableArray * nonRequiredIndexes = [NSMutableArray new];
            
            for(NSArray * index in indexes) {
                if(![index required]) {
                    [nonRequiredIndexes addObject:index];
                }
            }
            
            strongSelf.searchTermButton.hidden = !indexes.count;
           
            strongSelf.searchTermNavigationController = [[BInterfaceManager sharedManager].a searchIndexNavigationControllerWithIndexes:nonRequiredIndexes withCallback:^(NSArray * index) {
                [strongSelf.searchTermButton setTitle:index.key forState:UIControlStateNormal];
                strongSelf.currentSearchIndex = index;
            }];
            
            [self stopActivityIndicator];
            return Nil;
        }, Nil);
    }
    else {
        [self stopActivityIndicator];
        searchTermButton.hidden = YES;
    }

    // Fix for the iPhone X
    // For some reason, the text view has no border...
//    if([UIScreen mainScreen].nativeBounds.size.height == 2436) {
//        self.searchBox.layer.borderColor = [BCoreUtilities colorWithHexString:@"e2e2e2"].CGColor;
//        self.searchBox.layer.borderWidth = 1;
//        self.searchBox.layer.cornerRadius = 5;
//    }

    self.searchBox.keepTopInset.equal = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height + 10 + keepRequired;
    self.searchBox.placeholder = [NSBundle t:bSearch];
    
    // Add a tap recognizer to dismiss the keyboard
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle t:bBack] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];

    _addButton = [[UIBarButtonItem alloc] initWithTitle:[NSBundle t:bAdd] style:UIBarButtonItemStylePlain target:self action:@selector(addButtonPressed)];
    self.navigationItem.rightBarButtonItem = _addButton;
    
    //[self updateAddressBook];
    [tableView registerNib:[UINib nibWithNibName:@"BUserCell" bundle:[NSBundle uiBundle]] forCellReuseIdentifier:bCellIdentifier];
    
    self.noUsersFoundLabel.text = [NSBundle t:bNoNewUsersFoundForThisSearch];
    self.noUsersFoundView.hidden = YES;
    
    [self updateAddButton];
}

-(void) updateAddButton {
    _addButton.enabled = _selectedUsers.count;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_selectedUsers removeAllObjects];
    
    // Observe for keyboard appear and disappear notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:Nil];
    
    [self clearAndReload];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_users.count && _showKeyboardOnLoad) {
        [searchBox becomeFirstResponder];
    }
    
    _internetConnectionObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kReachabilityChangedNotification object:nil queue:Nil usingBlock:^(NSNotification * notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![Reachability reachabilityForInternetConnection].isReachable) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        });
    }];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void) startActivityIndicator {
    // TODO: make this better i.e. what to do while we're loading the search terms
    //searchBox.userInteractionEnabled = NO;
    self.activityView.hidden = NO;
    [self.activityView startAnimating];
    self.searchTermButton.hidden = YES;
}

-(void) stopActivityIndicator {
    //searchBox.userInteractionEnabled = YES;
    self.activityView.hidden = YES;
    [self.activityView stopAnimating];
    self.searchTermButton.hidden = !_currentSearchIndex;
}

-(void) backButtonPressed {
    if (usersSelected != Nil) {
        usersSelected(@[]);
    }
}

-(void) addButtonPressed {
    if (usersSelected != Nil) {
        usersSelected(_selectedUsers);
    }
}

-(void) viewTapped {
    [searchBox resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BUserCell * cell = [tableView_ dequeueReusableCellWithIdentifier:bCellIdentifier];

    // Get the user
    id<PUser> user = _users[indexPath.row];
    [cell setUser:user];
    cell.statusImageView.hidden = YES;
        
    if ([_selectedUsers containsObject:user]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<PUser> user = _users[indexPath.row];
    
    if ([_selectedUsers containsObject:user]) {
        [_selectedUsers removeObject:user];
    }
    else {
        [_selectedUsers addObject:user];
    }
    [tableView_ reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self updateAddButton];
}

-(void) searchWithText: (NSString *) text {
    
    [self clearAndReload];
    [self startActivityIndicator];
    
    NSArray * indexes = _currentSearchIndex.value ? @[_currentSearchIndex.value] : Nil;

    __weak __typeof__(self) weakSelf = self;

    [NM.search usersForIndexes:indexes withValue:text limit: 10 userAdded: ^(id<PUser> user) {
        __typeof__(self) strongSelf = weakSelf;

        // Make sure we run this on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (user != NM.currentUser) {
                // Only display a user if they have a name set
            
                // Check the users entityID to make sure they're not in the exclude list
                if (!strongSelf->_usersToExclude || ![strongSelf->_usersToExclude containsObject:user]) {
                    if (user.name.length) {
                        if (![strongSelf->_users containsObject:user]) {
                            [strongSelf->_users addObject:user];
                        }
                    }
                }
            }
            [strongSelf->_users sortUsersInAlphabeticalOrder];
            
            [strongSelf.tableView reloadData];
            
        });
        
    }].thenOnMain(^id(id success) {
        __typeof__(self) strongSelf = weakSelf;

        strongSelf.noUsersFoundView.hidden = strongSelf->_users.count > 0;
        
        [strongSelf.tableView reloadData];
        [strongSelf stopActivityIndicator];
        return Nil;
    }, ^id(NSError * error) {
        __typeof__(self) strongSelf = weakSelf;
        [strongSelf stopActivityIndicator];
        return error;
    });
}

#pragma TextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // New string
    NSString * newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    BOOL shouldSearch = [newString stringByReplacingOccurrencesOfString:@" " withString:@""].length;
    
    if (shouldSearch && newString.length > 2) {
        [self searchWithText:newString];
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self clearAndReload];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchWithText:textField.text];
    return NO;
}

-(void) clearAndReload {
    [_users removeAllObjects];
    [_selectedUsers removeAllObjects];
    [tableView reloadData];
}

- (IBAction)searchTermButtonPressed:(id)sender {
    [self presentViewController:_searchTermNavigationController
                       animated:YES
                     completion:Nil];
}

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
    
    // Animate using this style because for some reason
    // using blocks doesn't give a smooth animation
    [UIView beginAnimations:Nil context:Nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration.doubleValue];
    [UIView setAnimationCurve:curve.integerValue];
    
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

-(void) keyboardWillHide: (NSNotification *) notification {
    
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    tableView.keepBottomInset.equal = 0;
    [self.view setNeedsUpdateConstraints];
    
    [UIView beginAnimations:Nil context:Nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration.doubleValue];
    [UIView setAnimationCurve:curve.integerValue];
    
    [self.view layoutIfNeeded];
    
    // Set the inset so it's correct when we animate back to normal
    [self setTableViewBottomContentInset:0];
    
    [UIView commitAnimations];
}

-(void) setTableViewBottomContentInset: (float) inset {
    UIEdgeInsets insets = tableView.contentInset;
    insets.bottom = inset;
    tableView.contentInset = insets;
}

@end
