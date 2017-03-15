//
//  PEntity+Chatcat.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 09/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import "BEntity.h"

#import <Firebase/Firebase.h>

#import <ChatSDKCore/ChatCore.h>

#import <ChatSDKFirebaseAdapter/Firebase+Paths.h>

#import <ChatSDKCore/BKeys.h>

@implementation BEntity

-(id) init {
    if((self = [super init])) {
        _pathIsOn = [NSMutableDictionary new];
        _state = [NSMutableDictionary new];
    }
    return self;
}

-(RXPromise *) pathOn: (NSString *) key callback: (void(^)(FIRDataSnapshot * snapshot)) callback {
    
    RXPromise * promise = [RXPromise new];
    
    // Check to see if the path has already been turned on
    if(_pathIsOn[key] && [_pathIsOn[key] intValue]) {
        [promise resolveWithResult:Nil];
        return promise;
    }
    _pathIsOn[key] = @YES;
    
    FIRDatabaseReference * stateRef = [self stateRef: key];
    [stateRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
        
        NSNumber * time = snapshot.value;
        
        // If the state isn't set either locally or remotely
        // or if it is set but the timestamp is lower than the remove value
        // add a listener to the value
        if(!time || !_state[key] || (time && time > _state[key])) {
            
            _state[key] = time;
            
            FIRDatabaseReference * ref = [self pathRef:key];
            
            [ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
                if(callback != Nil) {
                    callback(snapshot);
                }
                [promise resolveWithResult:Nil];
            }];
        }
        else {
            if (callback != Nil) {
                callback(Nil);
            }
            [promise resolveWithResult:Nil];
        }
    }];
    return promise;
}

-(void) updateState: (NSString *) path id: (NSString *) id_ key: (NSString *) key completion: (void(^)(NSError * error)) completion {
    
    FIRDatabaseReference * ref = [[[[[FIRDatabaseReference firebaseRef] child:path]
                                                                        child:id_]
                                                                        child:bStatePath]
                                                                        child:key];
    
    [ref setValue:[FIRServerValue timestamp] withCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
        if (completion != Nil) {
            completion(error);
        }
    }];
}

-(void) pathOff: (NSString *) key {
    _pathIsOn[key] = @(NO);
    
    [[self stateRef:key] removeAllObservers];
    [[self pathRef:key] removeAllObservers];
}

-(FIRDatabaseReference *) ref {
    return [BEntity ref:_path id:self.entityID];
}

-(FIRDatabaseReference *) stateRef: (NSString *) key {
    return [BEntity stateRef:_path id:self.entityID key:key];
}

-(FIRDatabaseReference *) pathRef: (NSString *) key {
    return [[self ref] child:key];
}

+(FIRDatabaseReference *) stateRef: (NSString *) path id: (NSString *) id_ key: (NSString *) key {
    return [[[self ref:path id:id_] child:bStatePath] child:key];
}

+(FIRDatabaseReference *) ref: (NSString *) path id: (NSString *) id_ {
    return [[[FIRDatabaseReference firebaseRef] child:path] child:id_];
}

// This should be overridden
-(NSString *) entityID {
    NSLog(@"This method should be overridden");
    assert(1 == 2);
}

@end
