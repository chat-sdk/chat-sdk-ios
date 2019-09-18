//
//  BSyncDataPusher.m
//  ChatSDK Demo
//
//  Created by Ben on 12/4/17.
//  Copyright © 2017 deluge. All rights reserved.
//

#import "BSyncDataPusher.h"
#import "ChatSDKSyncData.h"

#import <ChatSDKFirebase/FirebaseAdapter.h>

@implementation BSyncDataPusher

-(RXPromise *) addItem: (BSyncItem *) item toUser: (id<PUser>) user {
    return [self addItem:item toUser:user pushItem:YES];
}

-(RXPromise *) addItem: (BSyncItem *) item toUser: (id<PUser>) user pushItem: (BOOL) pushItem {
    
    RXPromise * itemPushPromise = Nil;
    if(pushItem) {
        itemPushPromise = [item push];
    }
    else {
        itemPushPromise = [RXPromise resolveWithResult:Nil];
    }
    
    return itemPushPromise.then(^id(id success) {
        RXPromise * promise = [RXPromise new];
        
        // Get the user path
        FIRDatabaseReference * ref = [[self refWithUser: user path:item.path] child:item.entityID];
        [ref setValue:item.entityID withCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
            if(error == Nil) {
                [promise resolveWithResult:Nil];
            }
            else {
                [promise rejectWithReason:error];
            }
        }];
        
        return promise;
    }, Nil);
}

-(RXPromise *) removeItem: (BSyncItem *) item fromUser: (id<PUser>) user {
    
    RXPromise * userAddPromise = [RXPromise new];
    
    // Get the user path
    FIRDatabaseReference * ref = [[self refWithUser: user path:item.path] child:item.entityID];
    [ref removeValueWithCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
        if(error != Nil) {
            [userAddPromise resolveWithResult:Nil];
        }
        else {
            [userAddPromise rejectWithReason:error];
        }
    }];
    
    return userAddPromise;
}

-(FIRDatabaseReference *) refWithUser: (id<PUser>) user path: (NSString *) path {
    return [[FIRDatabaseReference userRef:user.entityID] child: path];
}

@end
