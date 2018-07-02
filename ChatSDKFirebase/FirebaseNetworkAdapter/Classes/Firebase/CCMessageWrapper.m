//
//  CCMessage.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 10/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import "CCMessageWrapper.h"

#import <ChatSDK/FirebaseAdapter.h>

@implementation CCMessageWrapper

+(id) messageWithSnapshot: (FIRDataSnapshot *) snapshot {
    return [[self alloc] initWithSnapshot:snapshot];
}

-(id) initWithSnapshot: (FIRDataSnapshot *) snapshot {
    if ((self = [self init])) {
        NSString * entityID = snapshot.key;
        _model = [[BStorageManager sharedManager].a fetchOrCreateEntityWithID:entityID withType:bMessageEntity];
        [self deserialize:snapshot.value];
    }
    return self;
}

+(id) messageWithModel: (id<PMessage>) model {
    return [[self alloc] initWithModel:model];
}

-(id) initWithModel: (id<PMessage>) model {
    if((self = [super init])) {
        _model = model;
    }
    return self;
}

#pragma DB Methods

+(id) messageWithID: (NSString *) entityID {
    id<PMessage> model = [[BStorageManager sharedManager].a fetchEntityWithID:entityID withType:bMessageEntity];
    if (!model) {
        model = [[BStorageManager sharedManager].a createEntity:bMessageEntity];
    }
    return [[CCMessageWrapper alloc] initWithModel:model];
}

-(void) save {
    
}

#pragma Network Methods

-(RXPromise *) push {
    
    RXPromise * promise = [RXPromise new];

    // Add the message to Firebase
    FIRDatabaseReference * ref = [self ref];
    _model.entityID = ref.key;
    
    [ref setValue:[self serialize] andPriority:[FIRServerValue timestamp] withCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
        if (!error) {
            [promise resolveWithResult:self];
        }
        else {
            _model.entityID = Nil;
            [promise rejectWithReason:error];
        }
    }];
    
    return promise;
}

-(NSDictionary *) lastMessageData {
    NSMutableDictionary * data = self.serialize;
    data[b_UserName] = self.model.userModel.name; // TODO: Remove this
    [data removeObjectForKey:b_ReadPath];
    [data removeObjectForKey:b_Meta];
    return data;
}

-(NSMutableDictionary *) serialize {
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:@{b_Type: _model.type,
                                                                                 b_Date: [FIRServerValue timestamp],
                                                                                 b_UserFirebaseID: _model.userModel.entityID,
                                                                                 b_ReadPath: self.initialReadReceipts,
                                                                                 b_Meta: _model.metaDictionary ? _model.metaDictionary : @{}}];
    if([BChatSDK config].includeMessagePayload) {
        dict[b_Payload] = _model.textString;
    }
    if([BChatSDK config].includeMessageJSON) {
        dict[b_JSON] = _model.text;
    }
    if([BChatSDK config].includeMessageJSONV2) {
        dict[b_JSONV2] = _model.json;
    }

    return dict;
}

-(NSDictionary *) initialReadReceipts {
    // Setup the initial read receipts
    NSMutableDictionary * readReceipts = [NSMutableDictionary new];
    id<PUser> currentUser = NM.currentUser;
    for (id<PUser> user in self.model.thread.users) {
        if (![user isEqual:currentUser]) {
            readReceipts[user.entityID] = @{b_Status: @(bMessageReadStatusNone)};
        }
    }
    return readReceipts;
}

-(void) handlePayload: (NSString *) payload __deprecated_msg("From version 4 onwards messages should be encoded using JSON."); {
    
    NSData *jsonData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&e];
    
    // This is encoded as JSON
    if(dict[@"text"]) {
        [_model setText:payload];
    }
    else {
        [_model setTextAsDictionary:@{bMessageTextKey: payload}];
    }

}

-(RXPromise *) deserialize: (NSDictionary *) value {
    
    RXPromise * promise = [RXPromise new];
    
    NSDictionary * json2 = value[b_JSONV2];
    if(json2) {
        [_model setJson:json2];
    }
    else {
        // Version 4 uses a JSON string so if this property is set, we use it!
        NSString * json = value[b_JSON];
        if (json) {
            [_model setText:json];
        }
        else {
            NSString * payload = value[b_Payload];
            if (payload) {
                [self handlePayload:payload];
            }
        }
    }
    
    NSNumber * messageType = value[b_Type];
    if (messageType) {
        _model.type = messageType;
    }
    
    NSNumber * date = value[b_Date];
    if (date) {
        _model.date = [BFirebaseCoreHandler timestampToDate:date];
    }
    
    NSDictionary * readReceipts = value[b_ReadPath];
    if (readReceipts) {
        [_model setReadStatus:readReceipts];
        // TODO: Remove this
        //[_model setReadReceipts:readReceipts];
    }
    
    NSDictionary * meta = value[b_Meta];
    if (meta) {
        [_model setMetaDictionary:meta];
    }
    
    // Assign this message to a user
    NSString * userID = value[b_UserFirebaseID];
    if (userID) {
        _model.userModel = [[BStorageManager sharedManager].a fetchEntityWithID:userID withType:bUserEntity];
        if(!_model.userModel) {
            id<PUser> user = [[BStorageManager sharedManager].a fetchOrCreateEntityWithID:userID withType:bUserEntity];
            [promise resolveWithResult:[[CCUserWrapper userWithModel:user] once].thenOnMain(^id(id success) {
                _model.userModel = user;
                [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationMessageUpdated
                                                                    object:Nil
                                                                  userInfo:@{bNotificationMessageUpdatedKeyMessage: self.model}];
                return success;
            }, Nil)];
        }
        else {
            [promise resolveWithResult:Nil];
        }
    }
    else {
        [promise resolveWithResult:Nil];
    }
    
    return promise;
}

-(RXPromise *) send {
    if (_model.thread) {
        return [self push].thenOnMain(^id(id success) {
            [[CCThreadWrapper threadWithModel:_model.thread] pushLastMessage:[self lastMessageData]].thenOnMain(^id(id success) {
                return [BEntity pushThreadMessagesUpdated:_model.thread.entityID];
            },Nil);
            return success;
        }, Nil);
    }
    else {
        return [RXPromise rejectWithReason:Nil];
    }
}


-(RXPromise *) flag {
    RXPromise * promise = [RXPromise new];
    
    NSDictionary * data = @{b_CreatorEntityID: NM.currentUser.entityID,
                            b_SenderEntityID: _model.userModel.entityID,
                            b_Message: _model.textString,
                            b_Thread: _model.thread.entityID,
                            b_Date: [FIRServerValue timestamp]};
    
    FIRDatabaseReference * ref = [FIRDatabaseReference flaggedRefWithMessage:_model.entityID];
    [ref setValue:data withCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
        if (!error) {
            _model.flagged = @YES;
            [promise resolveWithResult:Nil];
        }
        else {
            [promise rejectWithReason:error];
        }
    }];
    return promise;
}

-(RXPromise *) unflag {
    RXPromise * promise = [RXPromise new];
    FIRDatabaseReference * ref = [FIRDatabaseReference flaggedRefWithMessage:_model.entityID];
    [ref removeValueWithCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
        if (!error) {
            _model.flagged = @NO;
            [promise resolveWithResult:Nil];
        }
        else {
            [promise rejectWithReason:error];
        }
    }];
    return promise;
}

-(RXPromise *) delete {
    RXPromise * promise = [RXPromise new];
    CCThreadWrapper * threadWrapper = [CCThreadWrapper threadWithModel:self.model.thread];
    
    FIRDatabaseReference *ref = [[FIRDatabaseReference threadMessagesRef:_model.thread.entityID] child:_model.entityID];
    [ref removeValueWithCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
        if (!error) {
            [threadWrapper updateLastMessage].thenOnMain(^id(id success) {
                NSLog(@"–––– Removed message");
                [promise resolveWithResult:Nil];
                return Nil;
            }, ^id(NSError * error) {
                [promise rejectWithReason:error];
                return Nil;
            });
        }
        else {
            [promise rejectWithReason:error];
        }
    }];

    return promise;
}

-(FIRDatabaseReference *) ref {
    if (_model.entityID) {
        // Check to see if this message is a virtual message i.e. it's been threaded
        // from a different thread
        NSString * originalThreadID = [_model metaValueForKey:bMessageOriginalThreadEntityID];
        if(!originalThreadID) {
            originalThreadID = _model.thread.entityID;
        }
        
        return [[FIRDatabaseReference threadMessagesRef:originalThreadID] child: _model.entityID];
    }
    else {
        return [[FIRDatabaseReference threadMessagesRef:_model.thread.entityID] childByAutoId];
    }
}

-(void) setDelivered: (NSNumber *) delivered {
    _model.delivered = delivered;
}

-(id<PMessage>) model {
    return _model;
}

-(NSString *) entityID {
    return _model.entityID;
}


@end
