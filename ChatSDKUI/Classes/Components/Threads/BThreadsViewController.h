//
//  BThreadsViewController.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 24/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChatSDK/PThreadWrapper.h>

@class BNotificationObserverList;
@class BHook;
@interface BThreadsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UITabBarDelegate, UIAlertViewDelegate> {
    UIBarButtonItem * _editButton;
    
    NSMutableArray * _threads;
    BOOL _slideToDeleteDisabled;
    id _typingObserver;
    NSMutableDictionary * _threadTypingMessages;
    
    BNotificationObserverList * _notificationList;

}

@property (nonatomic, readwrite) UITableView *tableView;
@property (nonatomic, readwrite) NSMutableArray * threads;

-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

-(void) pushChatViewControllerWithThread: (id<PThread>) thread;
-(void) reloadData;
-(void) setEditingEnabled: (BOOL) enabled;
-(void) toggleEditing;
-(void) createThread;

@end
