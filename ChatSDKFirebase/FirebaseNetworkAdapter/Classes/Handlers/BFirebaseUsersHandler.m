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
        [[FIRDatabaseReference usersRef] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * snapshot) {
            id<PUser> user = [CCUserWrapper userWithSnapshot:snapshot].model;
            if(user && ![allUsers containsObject:user]) {
                [allUsers addObject:user];
                [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationUserUpdated object:Nil userInfo:@{bNotificationUserUpdated_PUser: user}];
            }
        }];
        [[FIRDatabaseReference usersRef] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * snapshot) {
            [CCUserWrapper userWithSnapshot:snapshot];
        }];
        [[FIRDatabaseReference usersRef] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * snapshot) {
            id<PUser> user = [CCUserWrapper userWithSnapshot:snapshot].model;
            if(user && [allUsers containsObject:user]) {
                [allUsers removeObject:user];
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
