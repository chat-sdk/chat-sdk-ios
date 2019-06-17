//
//  BFirebaseContactHandler.m
//  AFNetworking
//
//  Created by Benjamin Smiley-andrews on 08/02/2019.
//

#import "BFirebaseContactHandler.h"
#import <ChatSDKFirebase/FirebaseAdapter.h>

@implementation BFirebaseContactHandler

-(RXPromise *) addContact: (id<PUser>) contact withType: (bUserConnectionType) type {
    RXPromise * promise = [RXPromise new];
    if (!BChatSDK.currentUserID) {
        return promise;
    }
    FIRDatabaseReference * ref = [[FIRDatabaseReference userContactsRef:BChatSDK.currentUserID] child:contact.entityID];
    [ref setValue:@{bType: @(type)} withCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
        if (!error) {
            [promise resolveWithResult: Nil];
        } else {
            [promise rejectWithReason:error];
        }
    }];
    
    return promise;
}

/**
 * @brief Remove a contact locally and on the server if necessary
 */
-(RXPromise *) deleteContact: (id<PUser>) contact withType:(bUserConnectionType)type {
    RXPromise * promise = [RXPromise new];
    
    FIRDatabaseReference * ref = [[FIRDatabaseReference userContactsRef:BChatSDK.currentUserID] child:contact.entityID];
    [ref removeValueWithCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
        if (!error) {
            [promise resolveWithResult: Nil];
        } else {
            [promise rejectWithReason:error];
        }
    }];
    
    return promise;
}

@end
