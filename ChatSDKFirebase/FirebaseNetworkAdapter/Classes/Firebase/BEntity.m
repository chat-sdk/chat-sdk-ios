//
//  PEntity+Chatcat.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 09/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import "BEntity.h"

#import <ChatSDKFirebase/FirebaseAdapter.h>

@implementation BEntity

+(RXPromise *) pushThreadDetailsUpdated: (NSString *) threadID {
    return [self pushUpdated:bThreadsPath entityID:threadID key:bDetailsPath];
}

+(RXPromise *) pushThreadUsersUpdated: (NSString *) threadID {
    return [self pushUpdated:bThreadsPath entityID:threadID key:bUsersPath];
}

+(RXPromise *) pushThreadMessagesUpdated: (NSString *) threadID {
    return [self pushUpdated:bThreadsPath entityID:threadID key:bMessagesPath];
}

+(RXPromise *) pushUserMetaUpdated: (NSString *) userID {
    return [self pushUpdated:bUsersPath entityID:userID key:bMetaPath];
}

+(RXPromise *) pushUserThreadsUpdated: (NSString *) userID {
    return [self pushUpdated:bUsersPath entityID:userID key:bThreadsPath];
}

+(RXPromise *) pushUpdated: (NSString *) path entityID: (NSString *) entityID key: (NSString *) key {
    RXPromise * promise = [RXPromise new];
    FIRDatabaseReference * ref = [[[[[FIRDatabaseReference firebaseRef] child:path]
                                                                        child:entityID]
                                                                        child:bUpdatedPath]
                                                                        child:key];
    
    [ref setValue:[FIRServerValue timestamp] withCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
        if(!error) {
            [promise resolveWithResult:Nil];
        }
        else {
            [promise rejectWithReason:error];
        }
    }];
    return promise;
}

@end
