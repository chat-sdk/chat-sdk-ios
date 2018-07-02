//
//  BFirebasePublicThreadHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BFirebasePublicThreadHandler.h"

#import <ChatSDK/FirebaseAdapter.h>

@implementation BFirebasePublicThreadHandler


-(RXPromise *) createPublicThreadWithName:(NSString *)name {
    return [self createPublicThreadWithName:name entityID:Nil isHidden:NO];
}

// The hidden BOOL will create the thread but hide it - generally this should be set to NO
-(RXPromise *) createPublicThreadWithName: (NSString *) name entityID: (NSString *) entityID isHidden: (BOOL) hidden {
    // Before we create the thread start an undo grouping
    // that means that if it fails we can undo changed to the database
    [[BStorageManager sharedManager].a beginUndoGroup];

    id<PThread> threadModel = Nil;

    if(entityID) {
        threadModel = [[BStorageManager sharedManager].a fetchEntityWithID:entityID withType:bThreadEntity];
    }
    
    if(!threadModel) {
        threadModel = [[BStorageManager sharedManager].a createEntity:bThreadEntity];
    }
    
    threadModel.creationDate = [NSDate date];
    
    id<PUser> currentUserModel = NM.currentUser;
    
    threadModel.creator = currentUserModel;
    threadModel.type = @(bThreadTypePublicGroup);
    threadModel.name = name;
    threadModel.entityID = entityID ? entityID : Nil;
    
    [[BStorageManager sharedManager].a endUndoGroup];
    
    // Create the CC object
    CCThreadWrapper * thread = [CCThreadWrapper threadWithModel:threadModel];
    
    return [thread push].thenOnMain(^id(id success) {
        RXPromise * promise = [RXPromise new];
        if(!hidden) {
            
            // Add the thread to the list of public threads
            FIRDatabaseReference * publicThreadsRef = [[FIRDatabaseReference publicThreadsRef] child:thread.entityID];
            [publicThreadsRef setValue:@{bNullString: @""} withCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
                if (!error) {
                    [promise resolveWithResult:thread.model];
                }
                else {
                    [[BStorageManager sharedManager].a undo];
                    [promise rejectWithReason:error];
                }
            }];
        }
        else {
            [promise resolveWithResult: thread.model];
        }
        
        return promise;
        
    },^id(NSError * error) {
        //[[BStorageManager sharedManager].a undo];
        return error;
    });
    
}


@end
