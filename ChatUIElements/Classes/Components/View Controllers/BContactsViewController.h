//
//  BContactsViewController.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 23/05/2014.
//  Copyright (c) 2014 chatsdk.co All rights reserved. The Chat SDK is issued under the MIT liceense and is available for free at http://github.com/chat-sdk
//

#import <UIKit/UIKit.h>


@class BSearchViewController;
@protocol PUserConnection;

@interface BContactsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating> {
    NSMutableArray<PUserConnection> * _contacts;
    __strong BSearchViewController * _searchViewController;
    
    id _internetConnectionObserver;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UISearchController * searchController;

-(NSMutableArray *) contacts;
-(void) sortContacts;

@end
