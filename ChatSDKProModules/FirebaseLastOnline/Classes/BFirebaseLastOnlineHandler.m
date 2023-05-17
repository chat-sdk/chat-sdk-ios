//
//  BFirebaseLastOnlineHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 15/11/2016.
//
//

#import "BFirebaseLastOnlineHandler.h"
#import <ChatSDK/Core.h>
#import <ChatSDKFirebase/FirebaseAdapter.h>

@implementation BFirebaseLastOnlineHandler

@synthesize userMap = _userMap;

-(instancetype) init {
    if((self = [super init])) {
        _userMap = [NSMutableDictionary new];
    }
    return self;
}

-(NSDate *) lastOnlineForUser: (id<PUser>) user {
    return _userMap[user.entityID];
}

-(RXPromise *) getLastOnlineForUser: (id<PUser>) user {
    RXPromise * promise = [RXPromise new];

    __weak __typeof(self) weakSelf = self;
    [[self ref: user] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
        __typeof(self) strongSelf = weakSelf;

        if (![snapshot.value isEqual: [NSNull null]]) {
            
            NSDate * date = [BFirebaseCoreHandler timestampToDate:snapshot.value];
            
            strongSelf.userMap[user.entityID] = date;

            [BHookNotification notificationUserLastOnlineUpdated:user date: date];

            [promise resolveWithResult:date];
        }
        else {
            [promise rejectWithReason:Nil];
        }
    }];
    
    return promise;
}

- (RXPromise *)setLastOnlineForUser:(id<PUser>)user {
    RXPromise * promise = [RXPromise new];
    
    if (user) {
        FIRDatabaseReference * ref = [self ref: user];
        [ref setValue:[FIRServerValue timestamp] withCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
            [promise resolveWithResult:Nil];
        }];
        [ref onDisconnectSetValue:FIRServerValue.timestamp];
    }
    else {
        return [RXPromise rejectWithReason:Nil];
    }
    
    return promise;
}

-(FIRDatabaseReference *) ref: (id<PUser>) user {
    return [[FIRDatabaseReference userRef:user.entityID] child:bLastOnlinePath];
}


@end
