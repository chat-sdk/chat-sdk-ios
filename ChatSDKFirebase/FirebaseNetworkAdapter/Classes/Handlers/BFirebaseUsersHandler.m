//
//  BFirebaseUserHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/07/2017.
//
//

#import "BFirebaseUsersHandler.h"

#import <ChatSDKFirebase/FirebaseAdapter.h>

@implementation BFirebaseUsersHandler

@synthesize allUsers;

-(instancetype) init {
    if((self = [super init])) {
        allUsers = [NSMutableArray new];
    }
    return self;
}

-(void) allUsersOn {
    if(!_allUsersOn) {
        _allUsersOn = YES;
        __weak __typeof(self) weakSelf = self;
        [[FIRDatabaseReference usersRef] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * snapshot) {
            __typeof(self) strongSelf = weakSelf;
            id<PUser> user = [CCUserWrapper userWithSnapshot:snapshot].model;
            if(user && ![strongSelf.allUsers containsObject:user]) {
                [strongSelf.allUsers addObject:user];
                [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationUserUpdated object:Nil userInfo:@{bNotificationUserUpdated_PUser: user}];
            }
        }];
        [[FIRDatabaseReference usersRef] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * snapshot) {
            [CCUserWrapper userWithSnapshot:snapshot];
        }];
        [[FIRDatabaseReference usersRef] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * snapshot) {
            __typeof(self) strongSelf = weakSelf;
            id<PUser> user = [CCUserWrapper userWithSnapshot:snapshot].model;
            if(user && [strongSelf.allUsers containsObject:user]) {
                [strongSelf.allUsers removeObject:user];
                [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationUserUpdated object:Nil userInfo:@{bNotificationUserUpdated_PUser: user}];
            }
        }];
    }
}

-(void) allUsersOff {
    [[FIRDatabaseReference usersRef] removeAllObservers];
    _allUsersOn = NO;
}

@end
