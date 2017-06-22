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

- (id)initWithUsersToExclude: (NSArray *) excludedUsers selectedAction: (void(^)(NSArray * users)) action;
-(void) setExcludedUsers: (NSArray *) excludedUsers;
-(void) setSelectedAction: (void(^)(NSArray * users)) action;
-(NSString *) name;

@end

#endif /* PSearchViewController_h */
