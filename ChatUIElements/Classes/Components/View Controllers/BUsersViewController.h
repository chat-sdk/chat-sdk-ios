//
//  BUsersViewController.h
//  Chat SDK
//
//  Created by Simon Smiley-Andrews on 05/11/2014.
//  Copyright (c) 2014 chatsdk.co All rights reserved. The Chat SDK is issued under the MIT liceense and is available for free at http://github.com/chat-sdk
//

#import <UIKit/UIKit.h>

@class BProfileNameCell;
@protocol PThread;

@interface BUsersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    NSMutableArray * _users;
    id<PThread> _thread;
    
    UIImagePickerController * _picker;
    BProfileNameCell * _profileNameCell;
    
    id _internetConnectionObserver;
    id _threadUsersObserver;
}

@property (nonatomic, readwrite) UINavigationController * parentNavigationController;

@property (weak, nonatomic) IBOutlet UITableView * tableView;

- (id)initWithThread: (id<PThread>) thread;

@end
