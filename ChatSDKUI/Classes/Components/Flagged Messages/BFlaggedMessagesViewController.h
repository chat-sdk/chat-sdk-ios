//
//  BFlaggedMessagesViewController.h
//  ChatSDK
//
//  Created by Pepe Becker on 04.04.18.
//

#import <UIKit/UIKit.h>

@class BNotificationObserverList;

@interface BFlaggedMessagesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    
    BNotificationObserverList *notificationList;
    
}

@property (nonatomic, readwrite) UITableView *tableView;

@end
