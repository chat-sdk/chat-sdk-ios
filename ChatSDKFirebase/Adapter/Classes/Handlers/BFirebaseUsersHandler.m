//
//  BFirebaseUserHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/07/2017.
//
//

#import "BFirebaseUsersHandler.h"

#import <ChatSDKFirebase/FirebaseAdapter.h>
#import <ChatSDKFirebase/ChatSDKFirebase-Swift.h>

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
            id<PUser> user = [FirebaseNetworkAdapterModule.shared.firebaseProvider userWrapperWithSnapshot:snapshot].model;
            if(user && ![allUsers containsObject:user]) {
                [allUsers addObject:user];
                [BHookNotification notificationUserUpdated:user];
            }
        }];
        [[FIRDatabaseReference usersRef] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * snapshot) {
            [FirebaseNetworkAdapterModule.shared.firebaseProvider userWrapperWithSnapshot:snapshot];
        }];
        [[FIRDatabaseReference usersRef] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * snapshot) {
            id<PUser> user = [FirebaseNetworkAdapterModule.shared.firebaseProvider userWrapperWithSnapshot:snapshot].model;
            if(user && [allUsers containsObject:user]) {
                [allUsers removeObject:user];
                [BHookNotification notificationUserUpdated:user];
            }
        }];
    }
}

-(void) allUsersOff {
    [[FIRDatabaseReference usersRef] removeAllObservers];
    _allUsersOn = NO;
}

@end
