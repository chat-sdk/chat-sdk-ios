//
//  BNearbyContactsViewController.m
//  Pods
//
//  Created by Simon Smiley-Andrews on 21/07/2015.
//
//

#import "BNearbyContactsViewController.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>
#import "NearbyUsers.h"

#define bCellIdentifier @"bCellIdentifier"

#define bUserKey @"user"
#define bLocationKey @"location"

#define bUserLocationKey @"bUserLocationKey"

@interface BNearbyContactsViewController ()

@end

@implementation BNearbyContactsViewController

@synthesize tableView;
@synthesize users = _users;
@synthesize onlineUsers = _onlineUsers;
@synthesize usersByBand = _usersByBand;

- (id)init
{
    self = [self initWithNibName:@"BNearbyContactsViewController" bundle:self.bundle];
    if (self) {
        [self initialize];
    }
    return self;
}

-(NSBundle *) bundle {
    return [NSBundle bundleWithName:[@"Frameworks/FirebaseNearbyUsersModule.framework/" stringByAppendingString:bNearbyUsersBundle]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if (!nibNameOrNil) {
        nibNameOrNil = [self bundle];
    }
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

-(void) initialize {
    self.title = [NSBundle t:bNearbyContacts];
    self.tabBarItem.image = [UIImage imageNamed:@"icn_30_glass.png" inBundle:self.bundle withConfiguration:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
        __weak __typeof__(self) weakSelf = self;
        
        // When a user logs out we want to clear the nearby users array for a new user to log in
        [weakSelf.users removeAllObjects];
        [weakSelf.onlineUsers removeAllObjects];
        [weakSelf.usersByBand removeAllObjects];
        
        [weakSelf.tableView reloadData];

    }] withName:bHookDidLogout];
    
    [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
        [self refreshUserDistances];
    }] withName:bHookUserUpdated];
        
    // Change the colour of the navigation bar buttons
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

    _users = [NSMutableArray new];
    _usersByBand = [NSMutableArray new];
    _onlineUsers = [NSMutableArray<PUser> new];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = tableView;
    
    // Initialize the refresh control.
    refreshControl = [[UIRefreshControl alloc] init];
    //refreshControl.backgroundColor = [UIColor purpleColor];
    refreshControl.tintColor = [UIColor lightGrayColor];
    
    NSDictionary * attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor lightGrayColor] forKey:NSForegroundColorAttributeName];
    NSAttributedString * attributedTitle = [[NSAttributedString alloc] initWithString:[NSBundle t:bRefreshingUsers] attributes:attrsDictionary];
    refreshControl.attributedTitle = attributedTitle;
    
    [refreshControl addTarget:self action:@selector(refreshResults) forControlEvents:UIControlEventValueChanged];
    
    tableViewController.refreshControl = refreshControl;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [BGeoFireManager.sharedManager addListener:self];
    
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        
        UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:_activityIndicator];
        self.navigationItem.rightBarButtonItem = barButton;
    }
    [self refreshUserDistances];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [BGeoFireManager.sharedManager removeListener:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_onlineUsers.count) {
        return [_usersByBand[section] count];
    }
    else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // If we have users, we display the users... otherwise we just display the
    // searching indicator
    return _onlineUsers.count ? _usersByBand.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView_ dequeueReusableCellWithIdentifier:bCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:bCellIdentifier];
        cell.imageView.layer.cornerRadius = cell.frame.size.height / 2;
        cell.imageView.clipsToBounds = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_onlineUsers.count) {
        id<PUser> user = _usersByBand[indexPath.section][indexPath.row];
        
        cell.textLabel.text = user.name;

        [cell.imageView loadAvatar:user];

        if (@available(iOS 13.0, *)) {
            cell.textLabel.textColor = [UIColor labelColor];
        } else {
            cell.textLabel.textColor = [UIColor blackColor];
        }

        cell.accessoryView = NULL;
    }
    else {
        if (BNearbyUsersModule.shared.disabled) {
            cell.textLabel.text = [NSBundle t:bNearbyUsersModuleDisabled];
            cell.accessoryView = nil;
        } else {
            cell.textLabel.text = [NSBundle t:bSearching];
            UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [activityView startAnimating];
            [cell setAccessoryView:activityView];
        }
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.imageView.image = nil;
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_onlineUsers.count) {
        
        id<PUser> user = _usersByBand[indexPath.section][indexPath.row];
        
        // Open the users profile
//        if (!_profileView) {
            UIViewController * profileView = [BChatSDK.ui profileViewControllerWithUser:user];
//        }
        [self.navigationController pushViewController:profileView animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString * title = @"";
    
    if (_onlineUsers.count) {
        if (section == 0) {
            title = [NSString stringWithFormat:@"Less than %i km", [BChatSDK.config.nearbyUserDistanceBands[section] intValue]/1000];
        }
        else {
            title = [NSString stringWithFormat:@"%i - %ikm", [BChatSDK.config.nearbyUserDistanceBands[section - 1] intValue]/1000, [BChatSDK.config.nearbyUserDistanceBands[section] intValue]/1000];
        }
        // If there are no users dont make a title
        if ([_usersByBand[section] count] == 0) {
            title = Nil;
        }
    }
    return title;
}

- (void)refreshResults {
    [refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:2.0];
}

-(void) event: (BGeoEvent *) event {
    if ([event.item typeIs:bGeoItemTypeUser]) {
        
        [self refreshUserDistances];
    }
}

- (void)refreshUserDistances {
    
    if (BNearbyUsersModule.shared.disabled) {
        [_users removeAllObjects];
        [_usersByBand removeAllObjects];
        [_onlineUsers removeAllObjects];
        [tableView reloadData];
    }
    
    [_users removeAllObjects];
    for(BGeoItem * item in BGeoFireManager.sharedManager.items) {
        if ([item typeIs:bGeoItemTypeUser]) {
            NSString * entityID = item.entityID;
            id<PUser> user = [BChatSDK.db fetchOrCreateEntityWithID:entityID withType:bUserEntity];
            [BChatSDK.core observeUser:user.entityID];
            if(!user.isMe) {
                [((NSObject *)user) setAssociatedObject:item.location key:bUserLocationKey];
                [_users addObject:user];
            }
        }
    }
    
    CLLocation * currentLocation = BGeoFireManager.sharedManager.currentLocation;
    if (!currentLocation ) {
        return;
    }

    // Sort the users by distance
    [_users sortUsingComparator:^NSComparisonResult(NSObject * u1, NSObject * u2) {
        // Locations
        CLLocation * l1 = [u1 associatedObjectWithKey:bUserLocationKey];
        CLLocation * l2 = [u2 associatedObjectWithKey:bUserLocationKey];
        // Distances
        CLLocationDistance d1 = [currentLocation distanceFromLocation:l1];
        CLLocationDistance d2 = [currentLocation distanceFromLocation:l2];
        
        // TODO: Check this
        return d1 - d2;
    }];

    [_onlineUsers removeAllObjects];
    for (id<PUser> user in _users) {
        if ([user.online boolValue]) {
            [_onlineUsers addObject:user];
        }
    }
    
    [_usersByBand removeAllObjects];
    
    // Now add the users by band
    double lastBand = 0;
    
    NSMutableArray * allocatedUsers = [NSMutableArray new];
    
    for (NSNumber * band in BChatSDK.config.nearbyUserDistanceBands) {
        
        NSMutableArray * inBand = [NSMutableArray new];
        
        for (NSObject<PUser>* user in _onlineUsers) {
            
            if (![allocatedUsers containsObject:user]) {
            
                // Only need to calculate this if the user has not been already added
                CLLocation * l = [user associatedObjectWithKey:bUserLocationKey];
                CLLocationDistance d = [currentLocation distanceFromLocation:l];
                
                if (d >= lastBand && d < [band doubleValue]) {
                    [inBand addObject:user];
                    [allocatedUsers addObject:user];
                    
                    if (![_usersByBand containsObject:inBand]) {
                        [_usersByBand addObject:inBand];
                    }
                    // If this was the last object we also move on...
                    if ([user isEqualToEntity:_onlineUsers.lastObject]) {
                        lastBand = band.doubleValue;
                        break;
                    }
                }
                else {
                    lastBand = band.doubleValue;
                    break;
                }
            }
        }
        
        // If the array is empty then we want to add it - we need the empty arrays to ensure the header titles are correct
        if (!inBand.count) {
            [_usersByBand addObject:inBand];
        }
    }
    
    [tableView reloadData];
}

- (int) userCountForSection: (NSInteger)section {
    return (int) [_usersByBand[section] count];
}

@end
