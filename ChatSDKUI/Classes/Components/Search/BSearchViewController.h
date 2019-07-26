//
//  BSearchViewController.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 27/05/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChatSDK/PSearchViewController.h>

@class MBProgressHUD;
@class BSearchIndexViewController;
@class BHook;

@interface BSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PSearchViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate> {
    
    NSMutableArray * _users;
    NSMutableArray * _selectedUsers;
    UITapGestureRecognizer * _tapRecognizer;
    
    NSArray * _usersToExclude;
    
    id _internetConnectionObserver;
    UINavigationController * _searchTermNavigationController;
    NSArray * _currentSearchIndex;
    
    UIBarButtonItem * _addButton;
    UISearchController * _searchController;
    
    UIActivityIndicatorView * _activityIndicator;
    UIView * _searchTextFieldRightView;
    
    NSArray * _searchIndexes;
    BHook * _internetConnectionHook;

}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, readwrite) NSArray * selectedUsers;

@property (nonatomic, readwrite) UINavigationController * searchTermNavigationController;
@property (nonatomic, readwrite) NSArray * currentSearchIndex;

@property (nonatomic, readwrite, copy) void(^usersSelected)(NSArray * users);

@property (weak, nonatomic) IBOutlet UILabel *noUsersFoundLabel;
@property (weak, nonatomic) IBOutlet UIView *noUsersFoundView;

@property (nonatomic, readwrite) UIBarButtonItem * addButton;

-(void) addButtonPressed;
-(void) clearAndReload;
-(void) searchWithText: (NSString *) text;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
