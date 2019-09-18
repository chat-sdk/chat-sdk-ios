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
        
        if (@available(iOS 11.0, *)) {
            self.navigationItem.searchController = searchController;
        }
        
        self.definesPresentationContext = YES;
    }
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    [tableView registerNib:[UINib nibWithNibName:@"BUserCell" bundle:[NSBundle uiBundle]] forCellReuseIdentifier:bCellIdentifier];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [searchController.searchBar sizeToFit];
}

// This sets up the searchController properly
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    __weak __typeof__(self) weakSelf = self;

    [self updateButtonStatusForInternetConnection];

    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationUserUpdated
                                                                             object:Nil
                                                                              queue:Nil
                                                                         usingBlock:^(NSNotification * notification) {
                                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                                 __typeof__(self) strongSelf = weakSelf;
                                                                                 [strongSelf reloadData];
                                                                             });
                                                                         }]];
    
    [_notificationList add:[BChatSDK.hook addHook:[BHook hook:^(NSDictionary * dict) {
        __typeof__(self) strongSelf = weakSelf;
        [strongSelf reloadData];
    }] withNames:@[bHookContactWasAdded, bHookContactWasDeleted]]];
    
    [_notificationList add:[BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
        __typeof__(self) strongSelf = weakSelf;
        [strongSelf updateButtonStatusForInternetConnection];
    }] withName:bHookInternetConnectivityDidChange]];

    [self reloadData];
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

    NSDictionary * searchControllerNamesForType = BChatSDK.ui.additionalSearchControllerNames;
    
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
    for(id<PUserConnection> connection in BChatSDK.contact.contacts) {
        [excludedUsers addObject:connection.user];
    }
    
    UIViewController * vc = [BChatSDK.ui searchViewControllerWithType:type
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
            [BChatSDK.core observeUser:user.entityID];
            [BChatSDK.contact addContact:user withType:bUserConnectionTypeContact];
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
    UIViewController * profileView = [BChatSDK.ui profileViewControllerWithUser:connection.user];
    profileView.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:profileView animated:YES];
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// Called when a thread is to be deleted
- (void)tableView:(UITableView *)tableView_ commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *) indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete )
    {
        id<PUser> user = _contacts[indexPath.row];
        [BChatSDK.contact deleteContact:user withType:bUserConnectionTypeContact];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

-(void) reloadData {
    
    NSArray * allContacts = [BChatSDK.currentUser connectionsWithType:bUserConnectionTypeContact];
    
    [_contacts removeAllObjects];
    [_contacts addObjectsFromArray:allContacts];
    [_contacts sortOnlineThenAlphabetical];
    
    [tableView reloadData];
}


#pragma pulldownSearch

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController_ {
    
    NSString * searchString = searchController_.searchBar.text.lowercaseString;
    
    NSArray * allContacts = [BChatSDK.contact connectionsWithType:bUserConnectionTypeContact];
    
    [_contacts removeAllObjects];
    
    for (id<PUserConnection> conn in allContacts) {
        // If the search string is blank then we add all the on and offline users like normal
        if ([conn.user.name.lowercaseString rangeOfString:searchString].location != NSNotFound || !searchString.length) {
            [_contacts addObject:conn];
        }
    }
    
    [_contacts sortOnlineThenAlphabetical];
    
    [tableView reloadData];
}

- (void)updateButtonStatusForInternetConnection {
    
    BOOL connected = BChatSDK.connectivity.isConnected;
    self.navigationItem.rightBarButtonItem.enabled = connected;
}

-(NSMutableArray *) contacts {
    return _contacts;
}

@end

#endif
