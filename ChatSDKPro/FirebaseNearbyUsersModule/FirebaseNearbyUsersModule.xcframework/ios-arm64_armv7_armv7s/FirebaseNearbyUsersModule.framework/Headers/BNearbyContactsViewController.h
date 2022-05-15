//
//  BNearbyContactsViewController.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 21/07/2015.
//
//

#import <UIKit/UIKit.h>
#import <ChatSDK/PNearbyUsersHandler.h>
#import "PNearbyUsersListener.h"

@class BProfileTableViewController;
@class BLocationUpdater;
@protocol PUser;

@interface BNearbyContactsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PNearbyUsersListener> {

    UIActivityIndicatorView * _activityIndicator;
    
    NSMutableArray * _users;
    NSMutableArray<PUser> * _onlineUsers;
    
    NSMutableArray * _usersByBand;
        
    UIRefreshControl * refreshControl;
}

@property (nonatomic, weak) IBOutlet UITableView * tableView;
@property (nonatomic, readwrite) NSMutableArray * users;
@property (nonatomic, readwrite) NSMutableArray * onlineUsers;
@property (nonatomic, readwrite) NSMutableArray * usersByBand;

@end

