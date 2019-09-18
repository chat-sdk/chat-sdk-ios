//
//  PFriendsListViewController.h
//  Pods
//
//  Created by Ben on 8/8/18.
//

#ifndef PFriendsListViewController_h
#define PFriendsListViewController_h

@protocol PFriendsListViewController

-(void) setUsersToInvite: (void(^)(NSArray * users, NSString * groupName)) usersToInvite;
-(void) setRightBarButtonActionTitle: (NSString *) rightBarButtonActionTitle;
-(void) setOverrideContacts: (void(^)(void)) overrideContacts;

@end

#endif /* PFriendsListViewController_h */
