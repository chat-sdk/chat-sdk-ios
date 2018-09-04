//
//  PSearchViewController.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/04/2017.
//
//

#ifndef PSearchViewController_h
#define PSearchViewController_h

@protocol PSearchViewController <NSObject>

-(instancetype) initWithUsersToExclude: (NSArray *) excludedUsers selectedAction: (void(^)(NSArray * users)) action;
- (instancetype) initWithUsersToExclude: (NSArray *) excludedUsers;
-(void) setExcludedUsers: (NSArray *) excludedUsers;
-(void) setSelectedAction: (void(^)(NSArray * users)) action;

@end

#endif /* PSearchViewController_h */
