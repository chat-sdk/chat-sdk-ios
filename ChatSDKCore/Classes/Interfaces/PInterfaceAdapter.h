//
//  PInterfaceAdapter.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 14/12/2016.
//
//

#ifndef PInterfaceAdapter_h
#define PInterfaceAdapter_h

@protocol PUser;
@protocol PThread;
@protocol PChatOptionsHandler;
@protocol PSearchViewController;
@protocol PSendBar;
@protocol BChatOptionDelegate;
@protocol PImageViewController;
@protocol PLocationViewController;
@protocol PSplashScreenViewController;
@protocol PProvider;

@class BChatViewController;
@class BFriendsListViewController;
@class BChatOption;
@class BTextInputView;

@protocol PInterfaceAdapter <NSObject>

-(void) setPrivateThreadsViewController: (UIViewController *) controller;
-(UIViewController *) privateThreadsViewController;

-(void) setPublicThreadsViewController: (UIViewController *) controller;
-(UIViewController *) publicThreadsViewController;

-(void) setContactsViewController: (UIViewController *) controller;
-(UIViewController *) contactsViewController;

-(void) setProfileViewController: (UIViewController * (^)(id<PUser> user)) provider;
-(UIViewController *) profileViewControllerWithUser: (id<PUser>) user;

-(void) setProfilePicturesViewController: (UIViewController * (^)(id<PUser> user)) provider;
-(UIViewController *) profilePicturesViewControllerWithUser: (id<PUser>) user;

/**
 * @deprecated Use mainViewController method instead
 */
-(UIViewController *) appTabBarViewController __deprecated;

-(void) setMainViewController: (UIViewController *) controller;
-(UIViewController *) mainViewController;

-(void) setTermsOfServiceViewController: (UIViewController *) controller;
-(UIViewController *) termsOfServiceViewController;
-(UINavigationController *) termsOfServiceNavigationController;

// Use termsOfServiceViewController instead
-(UIViewController *) eulaViewController __deprecated;

// Use termsOfServiceNavigationController instead
-(UINavigationController *) eulaNavigationController __deprecated;

-(void) setFriendsListViewController: (BFriendsListViewController * (^)(NSArray * usersToExclude, void(^onComplete)(NSArray * users, NSString * groupName))) provider;
-(BFriendsListViewController *) friendsViewControllerWithUsersToExclude: (NSArray *) usersToExclude onComplete: (void(^)(NSArray * users, NSString * name)) action;
-(UINavigationController *) friendsNavigationControllerWithUsersToExclude: (NSArray *) usersToExclude onComplete: (void(^)(NSArray * users, NSString * name)) action;

-(void) setChatViewController: (BChatViewController * (^)(id<PThread> thread)) provider;
-(UIViewController *) chatViewControllerWithThread: (id<PThread>) thread;

-(NSArray *) defaultTabBarViewControllers;
-(UIView<PSendBar> *) sendBarView;

-(void) setSearchViewController: (UIViewController * (^)(NSArray * usersToExclude, void(^usersAdded)(NSArray * users))) provider;
-(UIViewController *) searchViewControllerWithType: (NSString *) type excludingUsers: (NSArray *) users usersAdded: (void(^)(NSArray * users)) usersAdded;
-(UIViewController<PSearchViewController> *) searchViewControllerExcludingUsers: (NSArray *) users usersAdded: (void(^)(NSArray * users)) usersAdded;

-(void) addSearchViewController: (UIViewController<PSearchViewController> *) controller withType: (NSString *) type withName: (NSString *) name;
-(void) removeSearchViewControllerWithType: (NSString *) type;

-(void) setChatOptionsHandler: (id<PChatOptionsHandler>) handler;

-(NSArray *) tabBarViewControllers;
-(NSArray *) tabBarNavigationViewControllers;

-(NSMutableArray *) chatOptions;
-(id<PChatOptionsHandler>) chatOptionsHandlerWithDelegate: (id<BChatOptionDelegate>) delegate;

-(void) setUsersViewController: (UIViewController * (^)(id<PThread> thread, UINavigationController * parent)) provider;
-(UIViewController *) usersViewControllerWithThread: (id<PThread>) thread parentNavigationController: (UINavigationController *) parent;
-(UINavigationController *) usersViewNavigationControllerWithThread: (id<PThread>) thread parentNavigationController: (UINavigationController *) parent;

-(void) addChatOption: (BChatOption *) option;
-(void) removeChatOption: (BChatOption *) option;

-(void) addTabBarViewController: (UIViewController *) controller atIndex: (int) index;
-(void) removeTabBarViewControllerAtIndex: (int) index;

-(NSDictionary *) additionalSearchControllerNames;
-(UIViewController *) settingsViewController;

-(UIColor *) colorForName: (NSString *) name;

-(BOOL) showLocalNotification: (id) notification;
-(void) setShowLocalNotifications: (BOOL) shouldShow;

-(void) setImageViewController: (UIViewController *) controller;
-(UIViewController<PImageViewController> *) imageViewController;
-(UINavigationController *) imageViewNavigationController;

-(void) setLocationViewController: (UIViewController *) controller;
-(UIViewController<PLocationViewController> *) locationViewController;
-(UINavigationController *) locationViewNavigationController;

-(void) setSearchIndexViewController: (UIViewController * (^)(NSArray * indexes, void(^callback)(NSArray *))) provider;
-(UIViewController *) searchIndexViewControllerWithIndexes: (NSArray *) indexes withCallback: (void(^)(NSArray *)) callback;
-(UINavigationController *) searchIndexNavigationControllerWithIndexes: (NSArray *) indexes withCallback: (void(^)(NSArray *)) callback;

-(void) setSplashScreenViewController: (UIViewController<PSplashScreenViewController> *) controller;
-(UIViewController<PSplashScreenViewController> *) splashScreenViewController;
-(UINavigationController *) splashScreenNavigationController;

-(void) setLoginViewController: (UIViewController *) controller;
-(UIViewController *) loginViewController;

-(void) registerMessageWithCellClass: (Class) cellClass messageType: (NSNumber *) type;
-(NSArray *) messageCellTypes;
-(Class) cellTypeForMessageType: (NSNumber *) messageType;

-(id<PProvider>) providerForName: (NSString *) name;
-(void) setProvider: (id<PProvider>) provider forName: (NSString *) name;

@end


#endif /* PInterfaceAdapter_h */
