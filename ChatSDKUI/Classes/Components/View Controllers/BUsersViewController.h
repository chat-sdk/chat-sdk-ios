//
//  BUsersViewController.h
//  Chat SDK
//
//  Created by Simon Smiley-Andrews on 05/11/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BProfileNameCell;
@protocol PThread;
@class BHook;
@protocol ModerationViewControllerDelegate;

@interface BUsersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, ModerationViewControllerDelegate> {
    
    NSMutableArray * _users;
    id<PThread> _thread;
    
    UIImagePickerController * _picker;
    BProfileNameCell * _profileNameCell;
    
    BHook * _internetConnectionHook;

    BHook * _threadUsersHook;
}

@property (nonatomic, readwrite) UINavigationController * parentNavigationController;

@property (weak, nonatomic) IBOutlet UITableView * tableView;
@property (nonatomic, readwrite) id<PThread> thread;

-(instancetype) initWithThread: (id<PThread>) thread;

@end
