//
//  BCustomSearchViewController.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 29/04/2016.
//
//

#import <UIKit/UIKit.h>
#import <ChatSDK/PContactHandler.h>
#import <ChatSDK/PSearchViewController.h>
#import <MessageUI/MessageUI.h>

@class MBProgressHUD;

@interface BPhonebookSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PSearchViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate> {
    
    NSMutableArray * _addressBookContacts; // This is the array of users to be displayed
    
    NSMutableArray * _selectedUsers; // These are the user selected to be added as contacts
    NSArray * _usersToExclude;
    
    MBProgressHUD * _hud;
    NSTimer * _timer;
    
    int _contactCount;
    
}

- (id)initWithUsersToExclude:(NSArray *)excludedUsers;

@property (nonatomic, weak) IBOutlet UITableView * tableView;
@property (nonatomic, readwrite, copy) void(^usersSelected)(NSArray * users);
@property (nonatomic, readwrite) NSMutableArray * addressBookContacts;

@end
