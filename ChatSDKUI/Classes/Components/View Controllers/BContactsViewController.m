//
//  BContactsViewController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 23/05/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#ifndef PUser_h
#define PUser_h

#import "BContactsViewController.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

#define bCellIdentifier @"bCellIdentifier"

@interface BContactsViewController ()

@end

@implementation BContactsViewController

@synthesize tableView;
@synthesize searchController;

-(instancetype) init
{
    self = [super initWithNibName:@"BContactsViewController" bundle:[NSBundle uiBundle]];
    
    if (self) {
        self.title = [NSBundle t:bContacts];
        self.tabBarItem.image = [NSBundle uiImageNamed: @"icn_30_contact.png"];
        _contacts = [NSMutableArray new];
        _notificationList = [BNotificationObserverList new];
        _initialTableYOffset = -1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add new group button
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                            target:self
                                                                                            action:@selector(addContacts)];
    
    if (!searchController) {
        
        searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        searchController.searchResultsUpdater = self;
        searchController.dimsBackgroundDuringPresentation = NO;
        searchController.searchBar.scopeButtonTitles = @[];
        searchController.searchBar.delegate = self;
        
        self.navigationItem.searchController = searchController;
        self.definesPresentationContext = YES;
    }
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    [tableView registerNib:[UINib nibWithNibName:@"BUserCell" bundle:[NSBundle uiBundle]] forCellReuseIdentifier:bCellIdentifier];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [searchController.searchBar sizeToFit];
    [self reloadData];
}

// This sets up the searchController properly
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self updateButtonStatusForInternetConnection];
    
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationUserUpdated
                                                                             object:Nil
                                                                              queue:Nil
                                                                         usingBlock:^(NSNotification * notification) {
                                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                                 [self reloadData];
                                                                             });
                                                                         }]];

    
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:kReachabilityChangedNotification object:nil queue:Nil usingBlock:^(NSNotification * notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateButtonStatusForInternetConnection];
        });
    }]];
    
    // We need to call this to ensure the search controller is correctly formatted when the view is shown
    [self viewDidLayoutSubviews];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_notificationList dispose];
    
    // This removes the active search once a user goes back to this page
    searchController.active = NO;
}

-(void) addContacts {
    
    __weak __typeof__(self) weakSelf = self;

    NSDictionary * searchControllerNamesForType = [BInterfaceManager sharedManager].a.additionalSearchControllerNames;
    
    if(searchControllerNamesForType.allKeys.count == 0) {
        // Just use name search
        [self openSearchViewWithType:bSearchTypeNameSearch];
        return;
    }
    
    // We want to create an action sheet which will allow users to choose how they add their contacts
    UIAlertController * view = [UIAlertController alertControllerWithTitle:[NSBundle t:bSearch] message:Nil preferredStyle:UIAlertControllerStyleActionSheet];
    view.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    
    UIAlertAction * nameSearch = [UIAlertAction actionWithTitle:[NSBundle t:bSearchWithName]
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
        [weakSelf openSearchViewWithType:bSearchTypeNameSearch];
    }];
    
    // Add additional options
    for (NSString * key in searchControllerNamesForType.allKeys) {
        UIAlertAction * action = [UIAlertAction actionWithTitle:searchControllerNamesForType[key]
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action){
                                                               [weakSelf openSearchViewWithType:key];
                                                           }];
        [view addAction:action];
    }
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:[NSBundle t: bCancel]
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction * action) {
        [view dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [view addAction:nameSearch];
    [view addAction:cancel];
    
    [self presentViewController:view animated:YES completion:nil];
}

- (void)openSearchViewWithType: (NSString *) type {
    
    __weak BContactsViewController * weakSelf = self;
    
    NSMutableArray * excludedUsers = [NSMutableArray new];
    for(id<PUserConnection> connection in NM.contact.contacts) {
        [excludedUsers addObject:connection.user];
    }
    
    UIViewController * vc = [[BInterfaceManager sharedManager].a searchViewControllerWithType:type
                                                                               excludingUsers:excludedUsers
                                                                                   usersAdded:^(NSArray * users) {
                                                                                   [weakSelf addUsers:users];
                                                                                   [weakSelf dismissViewControllerAnimated:YES completion:Nil];
                                                                               }];
    if(vc) {
        [self presentViewController:vc animated:YES completion:Nil];
    }
}

- (void)addUsers: (NSArray *)users {
    if (users.count) {
        
        // Add users to contacts
        for (id<PUser> user in users) {
            
            // Add observers to the user just added
            [NM.core observeUser:user.entityID];
            [NM.contact addContact:user withType:bUserConnectionTypeContact];
        }
    }
    
    [self reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contacts.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return Nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return bUserCellRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BUserCell * cell = [tableView_ dequeueReusableCellWithIdentifier:bCellIdentifier];
    
    id<PUserConnection> connection = _contacts[indexPath.row];
    [cell setUser:connection.user];
    
    return cell;
}

// When the cell is clicked
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<PUserConnection> connection = _contacts[indexPath.row];
    
    // Open the users profile
    UIViewController * profileView = [[BInterfaceManager  sharedManager].a profileViewControllerWithUser:connection.user];
    profileView.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:profileView animated:YES];
    
}

-(void) reloadData {
    
    NSArray * allContacts = [NM.currentUser connectionsWithType:bUserConnectionTypeContact];
    
    [_contacts removeAllObjects];
    [_contacts addObjectsFromArray:allContacts];

    [self sortContacts];
    
    [tableView reloadData];
}

-(void) sortContacts {
    [_contacts sortUsingComparator:^NSComparisonResult(id<PUserConnection> c1, id<PUserConnection> c2) {
        // First compare the online / offline
        if (c1.user.online.boolValue != c2.user.online.boolValue) {
            return !c1.user.online.boolValue ? NSOrderedDescending : NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}

#pragma pulldownSearch

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController_ {
    
    NSString * searchString = searchController_.searchBar.text.lowercaseString;
    
    NSArray * allContacts = [NM.contact connectionsWithType:bUserConnectionTypeContact];
    
    [_contacts removeAllObjects];
    
    for (id<PUserConnection> conn in allContacts) {
        // If the search string is blank then we add all the on and offline users like normal
        if ([conn.user.name.lowercaseString rangeOfString:searchString].location != NSNotFound || !searchString.length) {
            [_contacts addObject:conn];
        }
    }
    
    [self sortContacts];
    
    [tableView reloadData];
}

- (void)updateButtonStatusForInternetConnection {
    
    BOOL connected = [Reachability reachabilityForInternetConnection].isReachable;
    self.navigationItem.rightBarButtonItem.enabled = connected;
}

-(NSMutableArray *) contacts {
    return _contacts;
}

@end

#endif
