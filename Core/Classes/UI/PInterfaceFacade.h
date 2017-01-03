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
@class BChatViewController;
@class BFriendsListViewController;

@protocol PInterfaceFacade <NSObject>

-(UIViewController *) privateThreadsViewController;
-(UIViewController *) publicThreadsViewController;
-(UIViewController *) contactsViewController;
-(UIViewController *) profileViewControllerWithUser: (id<PUser>) user ;
-(BFriendsListViewController *) friendsViewControllerWithUsersToExclude: (NSArray *) usersToExclude;
-(UIViewController *) chatViewControllerWithThread: (id<PThread>) thread;
-(UIViewController *) searchViewControllerExcludingUsers: (NSArray *) users usersAdded: (void(^)(NSArray * users)) usersAdded;

-(NSArray *) tabBarViewControllers;
-(NSArray *) tabBarNavigationViewControllers;

-(NSMutableArray *) chatOptions;
-(id<PChatOptionsHandler>) chatOptionsHandlerWithChatViewController: (BChatViewController *) chatViewController;
-(UIViewController *) usersViewControllerWithThread: (id<PThread>) thread parentNavigationController: (UINavigationController *) parent;

@end


#endif /* PInterfaceFacade_h */
