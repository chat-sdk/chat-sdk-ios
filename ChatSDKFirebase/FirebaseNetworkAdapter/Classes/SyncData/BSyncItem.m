//
//  BSyncData.m
//  ChatSDK Demo
//
//  Created by Ben on 12/4/17.
//  Copyright © 2017 deluge. All rights reserved.
//

#import "BSyncItem.h"

#import <ChatSDKFirebase/FirebaseAdapter.h>

#define bBaseDataPath @"data"

@implementation BSyncItem

@synthesize entityID = _entityID;

+(instancetype) itemWithEntityID: (NSString *) entityID {
    return [[self alloc] initWithEntityID: entityID];
}

+(instancetype) item {
    return [[self alloc] init];
}

-(instancetype) initWithEntityID: (NSString *) entityID {
    if((self = [self init])) {
        _entityID = entityID;
    }
    return self;
}

-(FIRDatabaseReference *) ref {
    FIRDatabaseReference * ref = [[[FIRDatabaseReference firebaseRef] child: bBaseDataPath] child:[self path]];
    if(_entityID) {
        return [ref child:_entityID];
    }
    else {
        ref = [ref childByAutoId];
        _entityID = ref.key;
        return ref;
    }
}

-(NSDictionary *) serialize {
    assert(NO);
}

-(void) deserialize: (NSDictionary *) dict {
    assert(NO);
}

-(NSString *) path {
    assert(NO);
}

-(RXPromise *) on {
    RXPromise * promise = [RXPromise new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[self ref] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
            if(snapshot.value) {
                [self deserialize:snapshot.value];
                [promise resolveWithResult:Nil];
            }
            else {
                // TODO: Localize
                [promise rejectWithReason:[NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey: @"Item data is null"}]];
            }
        }];
    });
    return promise;
}

-(void) off {
    [[self ref] removeAllObservers];
}

// Add to the user's path
-(RXPromise *) push {
    RXPromise * promise = [RXPromise new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[self ref] setValue:[self serialize] withCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
            if(!error) {
                [promise resolveWithResult:Nil];
            }
            else {
                [promise rejectWithReason:error];
            }
        }];
    });
    return promise;
}

-(RXPromise *) delete {
    RXPromise * promise = [RXPromise new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[self ref] removeValueWithCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
            if(!error) {
                [promise resolveWithResult:Nil];
            }
            else {
                [promise rejectWithReason:error];
            }
        }];
    });
    return promise;
}

@end
