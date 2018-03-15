//
//  PInterfaceFacade.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 14/12/2016.
//
//

#ifndef PInterfaceFacade_h
#define PInterfaceFacade_h

@protocol PUser;
@protocol PThread;
@protocol PChatOptionsHandler;
@protocol PSearchViewController;
@protocol PSendBar;
@protocol BChatOptionDelegate;
@class BChatViewController;
@class BFriendsListViewController;
@class BChatOption;
@class BTextInputView;

@protocol PInterfaceFacade <NSObject>

-(UIViewController *) privateThreadsViewController;
-(UIViewController *) publicThreadsViewController;
-(UIViewController *) contactsViewController;
-(UIViewController *) profileViewControllerWithUser: (id<PUser>) user ;
-(UIViewController *) appTabBarViewController;
-(UIViewController *) eulaViewController;
-(BFriendsListViewController *) friendsViewControllerWithUsersToExclude: (NSArray *) usersToExclude;
-(BChatViewController *) chatViewControllerWithThread: (id<PThread>) thread;

-(NSArray *) defaultTabBarViewControllers;
-(UIView<PSendBar> *) sendBarView;

-(UIViewController *) searchViewControllerWithType: (NSString *) type excludingUsers: (NSArray *) users usersAdded: (void(^)(NSArray * users)) usersAdded;
-(UIViewController *) searchViewControllerExcludingUsers: (NSArray *) users usersAdded: (void(^)(NSArray * users)) usersAdded;

-(void) addSearchViewController: (UIViewController<PSearchViewController> *) controller withType: (NSString *) type withName: (NSString *) name;
-(void) removeSearchViewControllerWithType: (NSString *) type;

-(void) setChatOptionsHandler: (id<PChatOptionsHandler>) handler;

-(NSArray *) tabBarViewControllers;
-(NSArray *) tabBarNavigationViewControllers;

-(NSMutableArray *) chatOptions;
-(id<PChatOptionsHandler>) chatOptionsHandlerWithDelegate: (id<BChatOptionDelegate>) delegate;
-(UIViewController *) usersViewControllerWithThread: (id<PThread>) thread parentNavigationController: (UINavigationController *) parent;
-(void) addChatOption: (BChatOption *) option;
-(void) removeChatOption: (BChatOption *) option;

-(void) addTabBarViewController: (UIViewController *) controller atIndex: (int) index;
-(void) removeTabBarViewControllerAtIndex: (int) index;

-(NSDictionary *) additionalSearchControllerNames;
-(UIViewController *) settingsViewController;

-(UIColor *) colorForName: (NSString *) name;

@end


#endif /* PInterfaceFacade_h */
