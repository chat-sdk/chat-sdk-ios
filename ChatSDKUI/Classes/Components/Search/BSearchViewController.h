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

@interface BSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, PSearchViewController> {
    
    NSMutableArray * _users;
    NSMutableArray * _selectedUsers;
    UITapGestureRecognizer * _tapRecognizer;
    
    NSArray * _usersToExclude;
    
    id _internetConnectionObserver;
    BSearchIndexViewController * _searchTermViewController;
    NSArray * _currentSearchIndex;
    BOOL _showKeyboardOnLoad;
    
    UIBarButtonItem * _addButton;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *searchBox;
@property (nonatomic, readwrite, copy) void(^usersSelected)(NSArray * users);
@property (weak, nonatomic) IBOutlet UIButton *searchTermButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@property (weak, nonatomic) IBOutlet UILabel *noUsersFoundLabel;
@property (weak, nonatomic) IBOutlet UIView *noUsersFoundView;

- (id)initWithUsersToExclude: (NSArray *) excludedUsers;

@end
