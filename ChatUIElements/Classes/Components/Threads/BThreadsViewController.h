//
//  BThreadsViewController.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 24/09/2013.
//  Copyright (c) 2013 chatsdk.co All rights reserved. The Chat SDK is issued under the MIT liceense and is available for free at http://github.com/chat-sdk
//

#import <UIKit/UIKit.h>
#import "PThreadWrapper.h"

@interface BThreadsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UITabBarDelegate, UIAlertViewDelegate> {
    UIBarButtonItem * _editButton;
    
    id _messageObserver;
    id _userObserver;
    id _internetConnectionObserver;
    
    NSMutableArray * _threads;
    BOOL _slideToDeleteDisabled;
    id _typingObserver;
    NSMutableDictionary * _threadTypingMessages;
}

@property (nonatomic, readwrite) UITableView *tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

-(void) pushChatViewControllerWithThread: (id<PThread>) thread;
-(void) reloadData;
-(void) setEditingEnabled: (BOOL) enabled;
-(void) toggleEditing;

@end
