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

@interface BUsersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    NSMutableArray * _users;
    id<PThread> _thread;
    
    UIImagePickerController * _picker;
    BProfileNameCell * _profileNameCell;
    
    BHook * _internetConnectionHook;

    id _threadUsersObserver;
}

@property (nonatomic, readwrite) UINavigationController * parentNavigationController;

@property (weak, nonatomic) IBOutlet UITableView * tableView;

-(instancetype) initWithThread: (id<PThread>) thread;

@end
