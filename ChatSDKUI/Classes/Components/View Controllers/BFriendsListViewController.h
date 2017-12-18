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
#import <TOCropViewController/TOCropViewController.h>

@class BSearchIndexViewController;
@class MBProgressHUD;
@protocol  PThread;
@protocol PUser;

@protocol BFriendsListDataSource <NSObject>

-(NSArray *) contacts;

@end

@interface BFriendsListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, VENTokenFieldDelegate, VENTokenFieldDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate> {
    
    UIImagePickerController * _picker;
    
    NSMutableArray * _contacts;
    NSMutableArray * _selectedContacts;
    NSMutableArray * _contactsToExclude;
    
    NSString * _filterByName;
    id _internetConnectionObserver;
    
    UIImage * groupImage;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, readwrite, copy) void (^usersToInvite)(NSArray * users, NSString * groupName, NSString * imageUrl, NSString * thumbnailUrl);

@property (nonatomic, readwrite) NSString * rightBarButtonActionTitle;
@property (nonatomic, readwrite) NSArray * (^overrideContacts)();

@property (weak, nonatomic) IBOutlet VENTokenField * _tokenField;
@property (strong, nonatomic) NSMutableArray * names;
@property (weak, nonatomic) IBOutlet UIView * _tokenView;
@property (weak, nonatomic) IBOutlet UITextField * groupNameTextField;
@property (weak, nonatomic) IBOutlet UIView * groupNameView;
@property (weak, nonatomic) IBOutlet UIButton * groupImageButton;

@property (nonatomic, readwrite) int maximumSelectedUsers;

-(instancetype) initWithUsersToExclude: (NSArray<PUser> *) users;

-(void) setUsersToExclude: (NSArray *) users;
-(void) setSelectedUsers: (NSArray *) users;

@end
