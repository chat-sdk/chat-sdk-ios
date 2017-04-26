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
@class BChatViewController;
@class BFriendsListViewController;
@class BChatOption;

@protocol PInterfaceFacade <NSObject>

-(UIViewController *) privateThreadsViewController;
-(UIViewController *) publicThreadsViewController;
-(UIViewController *) contactsViewController;
-(UIViewController *) profileViewControllerWithUser: (id<PUser>) user ;
-(BFriendsListViewController *) friendsViewControllerWithUsersToExclude: (NSArray *) usersToExclude;
-(UIViewController *) chatViewControllerWithThread: (id<PThread>) thread;

-(UIViewController *) searchViewControllerWithType: (NSString *) type excludingUsers: (NSArray *) users usersAdded: (void(^)(NSArray * users)) usersAdded;

-(void) addSearchViewController: (UIViewController<PSearchViewController> *) controller withType: (NSString *) type withName: (NSString *) name;
-(void) removeSearchViewControllerWithType: (NSString *) type;

-(void) setChatOptionsHandler: (id<PChatOptionsHandler>) handler;

-(NSArray *) tabBarViewControllers;
-(NSArray *) tabBarNavigationViewControllers;

-(NSMutableArray *) chatOptions;
-(id<PChatOptionsHandler>) chatOptionsHandlerWithChatViewController: (BChatViewController *) chatViewController;
-(UIViewController *) usersViewControllerWithThread: (id<PThread>) thread parentNavigationController: (UINavigationController *) parent;
-(void) addChatOption: (BChatOption *) option;
-(void) removeChatOption: (BChatOption *) option;

-(void) addTabBarViewController: (UIViewController *) controller atIndex: (int) index;
-(NSDictionary *) additionalSearchControllerNames;

@end


#endif /* PInterfaceFacade_h */
