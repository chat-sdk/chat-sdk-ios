//
//  BFriendsListViewController.h
//  NekNominate
//
//  Created by Benjamin Smiley-andrews on 28/01/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <VENTokenField/VENTokenField.h>
#import <ChatSDK/PThread_.h>

@class BSearchIndexViewController;
@class MBProgressHUD;
@protocol  PThread;
@protocol PUser;

@protocol BFriendsListDataSource <NSObject>

-(NSArray *) contacts;

@end

@interface BFriendsListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, VENTokenFieldDelegate, VENTokenFieldDataSource, UITextFieldDelegate> {
    NSMutableArray * _contacts;
    NSMutableArray * _selectedContacts;
    NSMutableArray * _contactsToExclude;
    
    NSString * _filterByName;
    id _internetConnectionObserver;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, readwrite, copy) void (^usersToInvite)(NSArray * users, NSString * groupName);
@property (nonatomic, readwrite) NSString * rightBarButtonActionTitle;
@property (nonatomic, readwrite) NSArray * (^overrideContacts)(void);

@property (weak, nonatomic) IBOutlet VENTokenField * _tokenField;
@property (strong, nonatomic) NSMutableArray * names;
@property (weak, nonatomic) IBOutlet UIView * _tokenView;
@property (weak, nonatomic) IBOutlet UITextField * groupNameTextField;
@property (weak, nonatomic) IBOutlet UIView * groupNameView;

@property (nonatomic, readwrite) int maximumSelectedUsers;

-(instancetype) initWithUsersToExclude: (NSArray *) users;

-(void) setUsersToExclude: (NSArray *) users;
-(void) setSelectedUsers: (NSArray *) users;

@end
