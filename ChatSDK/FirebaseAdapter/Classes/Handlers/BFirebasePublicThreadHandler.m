//
//  BFirebasePublicThreadHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BFirebasePublicThreadHandler.h"

#import <ChatSDK/ChatFirebaseAdapter.h>
#import <ChatSDK/ChatCore.h>

@implementation BFirebasePublicThreadHandler

-(RXPromise *) createPublicThreadWithName:(NSString *)name {
    
    // Before we create the thread start an undo grouping
    // that means that if it fails we can undo changed to the database
    [[BStorageManager sharedManager].a beginUndoGroup];
    id<PThread> threadModel = [[BStorageManager sharedManager].a createEntity:bThreadEntity];
    
    threadModel.creationDate = [NSDate date];
    
    id<PUser> currentUserModel = [BNetworkManager sharedManager].a.core.currentUserModel;
    
    threadModel.creator = currentUserModel;
    threadModel.type = @(bThreadTypePublic);
    threadModel.name = name;
    
    [[BStorageManager sharedManager].a endUndoGroup];
    
    // Create the CC object
    CCThreadWrapper * thread = [CCThreadWrapper threadWithModel:threadModel];
    
    return [thread push].thenOnMain(^id(id success) {
        
        RXPromise * promise = [RXPromise new];
        
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
        
        return promise;
        
    },^id(NSError * error) {
        [[BStorageManager sharedManager].a undo];
        return error;
    });
    
}


@end
