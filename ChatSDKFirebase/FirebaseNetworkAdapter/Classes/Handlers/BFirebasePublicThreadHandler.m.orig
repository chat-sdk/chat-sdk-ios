//
//  BFirebasePublicThreadHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BFirebasePublicThreadHandler.h"

#import <ChatSDKFirebase/FirebaseAdapter.h>

@implementation BFirebasePublicThreadHandler


-(RXPromise *) createPublicThreadWithName:(NSString *)name {
    return [self createPublicThreadWithName:name entityID:Nil isHidden:NO];
}

// The hidden BOOL will create the thread but hide it - generally this should be set to NO
-(RXPromise *) createPublicThreadWithName: (NSString *) name entityID: (NSString *) entityID isHidden: (BOOL) hidden {
    return [self createPublicThreadWithName:name entityID:entityID isHidden:hidden meta:Nil];
}

-(RXPromise *) createPublicThreadWithName: (NSString *) name entityID: (NSString *) entityID isHidden: (BOOL) hidden meta: (NSDictionary *) meta {
    // Before we create the thread start an undo grouping
    // that means that if it fails we can undo changed to the database
    [BChatSDK.db beginUndoGroup];

    id<PThread> threadModel = Nil;

    if(entityID) {
        threadModel = [BChatSDK.db fetchEntityWithID:entityID withType:bThreadEntity];
    }
    
    if(!threadModel) {
        threadModel = [BChatSDK.db createThreadEntity];
    }
    
    threadModel.creationDate = [NSDate date];
    
    id<PUser> currentUserModel = BChatSDK.currentUser;
    
    threadModel.creator = currentUserModel;
    threadModel.type = @(bThreadTypePublicGroup);
    threadModel.name = name;
    threadModel.entityID = entityID ? entityID : Nil;
    
    if (meta) {
        [threadModel setMeta:meta];
    }
    
    [BChatSDK.db endUndoGroup];
    
    // Create the CC object
    CCThreadWrapper * thread = [CCThreadWrapper threadWithModel:threadModel];

    return [thread push].then(^id(id success) {
        return [thread pushMeta];
    }, Nil).thenOnMain(^id(id success) {
        RXPromise * promise = [RXPromise new];
        if(!hidden) {
            
            // Add the thread to the list of public threads
            FIRDatabaseReference * publicThreadsRef = [[FIRDatabaseReference publicThreadsRef] child:thread.entityID];
            [publicThreadsRef setValue:@{bCreationDate: FIRServerValue.timestamp} withCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
                if (!error) {
                    [promise resolveWithResult:thread.model];
                }
                else {
                    [BChatSDK.db undo];
                    [promise rejectWithReason:error];
                }
            }];
        }
        else {
            [promise resolveWithResult: thread.model];
        }
        
        return promise;
        
    },^id(NSError * error) {
        //[BChatSDK.db undo];
        return error;
    });
    
}


@end
