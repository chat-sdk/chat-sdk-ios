//
//  BUser+BUser_Chatcat.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 09/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import <ChatSDKFirebase/FirebaseAdapter.h>

@implementation CCUserWrapper

+(id) userWithAuthUserData: (FIRUser *) data {
    return [[self alloc] initWithAuthUserData:data];
}

-(id) initWithAuthUserData: (FIRUser *) data {
    if((self = [self init])) {
        
        // Get the model from the database if it exists
        _model = [BChatSDK.db fetchOrCreateEntityWithID:data.uid withType:bUserEntity];
        [self updateUserFromAuthUserData:data];
    }
    return self;
}

+(id) userWithModel: (id<PUser>) user {
    return [[self alloc] initWithModel:user];
}

-(id) initWithModel: (id<PUser>) user {
    if ((self = [self init])) {
        _model = user;
    }
    return self;
}

+(id) userWithEntityID: (NSString *) entityID {
    id<PUser> user = [BChatSDK.db fetchOrCreateEntityWithID:entityID withType:bUserEntity];
    return [[self alloc] initWithModel: user];
}

+(id) userWithSnapshot: (FIRDataSnapshot *) data {
    return [[self alloc] initWithSnapshot:data];
}

-(id) initWithSnapshot: (FIRDataSnapshot *) data {
    if ((self = [self init])) {
        _model = [BChatSDK.db fetchOrCreateEntityWithID:data.key withType:bUserEntity];
        [self deserialize:data.value];
    }
    return self;
}

-(void) updateUserFromAuthUserData: (FIRUser *) user {
    
    NSArray * dataProvider = user.providerData;
    BOOL profilePictureSet = NO;
    
    for (id<FIRUserInfo> provider in dataProvider) {
        
        NSString * name = provider.displayName;
        if (name && !_model.name) {
            _model.name = name;
        }

        NSString * email = provider.email;
        if (email && !_model.email) {
            [_model setMetaValue:email forKey:bUserEmailKey];
        }

        NSString * phoneNumber = provider.phoneNumber;
        if (phoneNumber && !_model.phoneNumber) {
            [_model setMetaValue:phoneNumber forKey:bUserPhoneKey];
        }

        NSString * profileURL = [provider.photoURL absoluteString];
        if (profileURL && ![self.model.meta metaStringForKey:bUserImageURLKey]) {
            
            // Only do this for Twitter login
            if ([provider.providerID isEqualToString:@"twitter.com"]) {
                
                // Making a call with the provider URL for Twitter returns a picture which is too small
                // pbs.twimg.com/profile_images/429221067630972928/ABKBUS9o_normal.jpeg returns the image too small
                // We need to return a larger picture to ensure the image is big enough - remove the _normal to return a larger image with the same url
                // pbs.twimg.com/profile_images/429221067630972918/ABLBUS9o.jpeg returns the right sized image
                profileURL = [profileURL stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
            }
            
            [self setProfilePictureWithImageURL:profileURL];
            profilePictureSet = YES;
        }
        
        
//        id<PUserAccount> account = [_model accountWithType:bAccountTypeFacebook];
//        if (!account) {
//            account = [BChatSDK.db createEntity:bUserAccountEntity];
//            account.type = @(bAccountTypeFacebook);
//            [_model addLinkedAccountsObject:account];
//        }
    }
    
    // Must set name before robot image to ensure they are different
    // Must be set outside of the provider loop as anonymous logins don't user data prodivers
    if (!_model.name) {
        _model.name = BChatSDK.shared.configuration.defaultUserName;
    }
    
    if (!profilePictureSet && ![self.model.meta metaStringForKey:bUserImageURLKey]) {
        
        // If the user doesn't have a default profile picture then set it automatically
        UIImage * defaultImage = [self.model.defaultImage resizedImage:bProfilePictureSize interpolationQuality:kCGInterpolationHigh];
        
        // Update the user
        [self.model setImage:UIImagePNGRepresentation(defaultImage)];
        
        [self setPersonProfilePicture];
    }
}

- (RXPromise *)setProfilePictureWithImageURL: (NSString *)url {
    
    id<PUser> user = BChatSDK.currentUser;
    
    // Only set the user picture if they are logging on the first time
    if (url && !user.image) {
        
        return [BCoreUtilities fetchImageFromURL:[NSURL URLWithString:url]].thenOnMain(^id(UIImage * image) {
            
            if(image) {
                
                [user setImage:UIImagePNGRepresentation(image)];
                
                if(BChatSDK.upload) {
                    return [BChatSDK.upload uploadImage:image].thenOnMain(^id(NSDictionary * urls) {
                        
                        // Set the meta data
                        [user updateMeta:@{bUserImageURLKey: urls[bImagePath]}];

                        return [BChatSDK.core pushUser];
                    }, Nil);
                }
                else {
                    return [BChatSDK.core pushUser];
                }
                
            }
            return image;
        }, Nil);
    }
    
    return nil;
}

- (void)setRobotProfilePicture {
    NSString * name = [self.model.name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * url = [@"https://robohash.org/" stringByAppendingFormat:@"%@.png", name];
    [self setProfilePictureWithImageURL:url];
}

-(void) setPersonProfilePicture {
    NSString * name = [self.model.name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * url = [@"http://flathash.com/%@.png" stringByAppendingFormat: @"%@", name];
    [self setProfilePictureWithImageURL:url];
}

-(id) initWithEntityID: (NSString *) entityID {
    if((self = [self init])) {
        _model = [BChatSDK.db fetchOrCreateEntityWithID:entityID withType:bUserEntity];
    }
    return self;
}


-(RXPromise *) once {
    
    NSString * token = BChatSDK.auth.loginInfo[bTokenKey];
    FIRDatabaseReference * ref = [FIRDatabaseReference userRef:self.entityID];

    return [BCoreUtilities getWithPath:[ref.description stringByAppendingString:@".json"] parameters:@{@"auth": token}].thenOnMain(^id(NSDictionary * response) {
        [self deserialize:response];
        return self;
    }, Nil);
}

-(RXPromise *) on {
    
    if (((NSManagedObject *)_model).on) {
        return [RXPromise resolveWithResult:Nil];
    }
    ((NSManagedObject *)_model).on = YES;

    FIRDatabaseReference * ref = [FIRDatabaseReference userRef:self.entityID];
    
    RXPromise * promise = [RXPromise new];
    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
        if(![snapshot.value isEqual: [NSNull null]]) {
            [self deserialize:snapshot.value];
            [promise resolveWithResult:self];
        }
        else {
            [promise resolveWithResult:Nil];
        }
    }];
    return promise;
}

-(void) off {
    
    ((NSManagedObject *)_model).on = NO;
    
    FIRDatabaseReference * ref = [FIRDatabaseReference userRef:self.entityID];
    [ref removeAllObservers];
    [self metaOff];
    [self onlineOff];
}

-(RXPromise *) metaOn {
    
    if (((NSManagedObject *)_model).metaOn) {
        return [RXPromise resolveWithResult:Nil];
    }

    ((NSManagedObject *)_model).metaOn = YES;
    
    FIRDatabaseReference * ref = [FIRDatabaseReference userMetaRef:self.entityID];
    
    RXPromise * promise = [RXPromise new];
    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
        if(![snapshot.value isEqual: [NSNull null]]) {
            [self deserializeMeta:snapshot.value];
            [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationUserUpdated object:Nil userInfo:@{bNotificationUserUpdated_PUser: self.model}];
            [promise resolveWithResult:self];
        } else {
            [promise resolveWithResult:Nil];
        }
    }];
    
    return promise;
}

-(void) metaOff {
    ((NSManagedObject *)_model).metaOn = NO;
    FIRDatabaseReference * ref = [FIRDatabaseReference userMetaRef:self.entityID];
    [ref removeAllObservers];
}

-(RXPromise *) onlineOn {
    
    RXPromise * promise = [RXPromise new];
    
    if (((NSManagedObject *)_model).onlineOn) {
        [promise resolveWithResult:Nil];
        return promise;
    }
    ((NSManagedObject *)_model).onlineOn = YES;
    
    FIRDatabaseReference * ref = [FIRDatabaseReference userOnlineRef:self.entityID];
    
    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
        if(![snapshot.value isEqual: [NSNull null]]) {
            self.model.online = [snapshot.value isEqualToNumber:@1] ? @(YES) : @(NO);
        }
        else {
            self.model.online = @NO;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationUserUpdated
                                                            object:Nil
                                                          userInfo:@{bNotificationUserUpdated_PUser: self.model}];
    }];
    
    return promise;
}

-(void) onlineOff {
    
    ((NSManagedObject *)_model).onlineOn = NO;
    FIRDatabaseReference * userRef = [FIRDatabaseReference userOnlineRef:self.entityID];
    [userRef removeAllObservers];
}

-(RXPromise *) push {
    RXPromise * promise = [RXPromise new];
    
    FIRDatabaseReference * ref = [FIRDatabaseReference userRef:self.entityID];
    
    [self updateFirebaseUser];
    
    [ref updateChildValues:[self serialize] withCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
        if (!error) {
            [BEntity pushUserMetaUpdated:self.model.entityID];
            
            // We only want to do this if we are logged in
            if (BChatSDK.auth.isAuthenticated) {
                [promise resolveWithResult:self.model];
            }
            else {
                [promise rejectWithReason:nil];
            }
        }
        else {
            [promise rejectWithReason:error];
        }
    }];
    
    return promise;
}

-(RXPromise *) updateFirebaseUser {
    
    FIRUser *user = [FIRAuth auth].currentUser;
    FIRUserProfileChangeRequest *changeRequest = [user profileChangeRequest];
    
    changeRequest.displayName = self.model.name;
    changeRequest.photoURL = [NSURL URLWithString:[self.model.meta metaStringForKey:bUserImageURLKey]];
    
    RXPromise * promise = [RXPromise new];
    
    [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
        if (!error) {
            [promise resolveWithResult:Nil];
        } else {
            [promise rejectWithReason:error];
        }
    }];
    
    return promise;
}

-(void) deserialize: (NSDictionary *) value {
    
    NSNumber * online = value[bOnlinePath];
    if (online) {
        _model.online = online;
    }
    [self deserializeMeta:value[bMetaPath]];
}

-(NSDictionary *) serialize {
    NSMutableDictionary * meta = [NSMutableDictionary dictionaryWithDictionary:_model.meta];
    meta[bUserNameLowercase] = _model.name ? [_model.name lowercaseString] : @"";
    return @{bMetaPath: meta};
}

// TODO: Find a way to determine if the meta has actually been updated i.e. is it 
-(void) deserializeMeta: (NSDictionary *) value {
    // Get the user's meta data
    NSMutableDictionary * meta = [NSMutableDictionary dictionaryWithDictionary:_model.meta];
    NSDictionary * newMeta = value;

    // Check to see if the image has changed
    NSString * newURL = newMeta[bUserImageURLKey];
    BOOL imageChanged = ![meta[bUserImageURLKey] isEqualToString:newURL];
    if (imageChanged && newURL && newURL.length) {
        [BCoreUtilities fetchImageFromURL:[NSURL URLWithString:newURL]].thenOnMain(^id(UIImage * image) {
            if(image) {
                [_model setImage:UIImagePNGRepresentation(image)];
            }
            return Nil;
        }, Nil);
    }
    
    for (NSString * key in [newMeta allKeys]) {
        if (![meta[key] isEqual:newMeta[key]]) {
            meta[key] = newMeta[key];
        }
    }
    
    if (meta) {
        [_model setMeta:meta];
    }
}

-(FIRDatabaseReference *) ref {
    return [[[FIRDatabaseReference userRef:_model.entityID] child:bUsersPath] child:_model.entityID];
}

-(FIRDatabaseReference *) metaRef {
    return [[self ref] child:bMetaPath];
}

-(FIRDatabaseReference *) imageRef {
    return [[self ref] child:bImagePath];
}

#pragma PUser protocol

-(NSString *) entityID {
    return _model.entityID;
}

-(id<PUser>) model {
    return _model;
}

-(NSString *) pushChannel {
    return self.model.pushChannel;
}

-(RXPromise *) addThreadWithEntityID: (NSString *) entityID {
    RXPromise * promise = [RXPromise new];
    
    // Get the user's reference
    FIRDatabaseReference * userThreadsRef = [[FIRDatabaseReference userThreadsRef:_model.entityID]child:entityID];

    [userThreadsRef setValue:@{bInvitedBy: BChatSDK.currentUser.entityID} withCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
        if (!error) {
            [BEntity pushUserThreadsUpdated:self.model.entityID];
            [promise resolveWithResult:self];
        }
        else {
            [promise rejectWithReason:error];
        }
    }];
    
    return promise;
}

-(RXPromise *) removeThreadWithEntityID: (NSString *) entityID {
    RXPromise * promise = [RXPromise new];
    
    // Get the user's reference
    FIRDatabaseReference * userThreadsRef = [[[FIRDatabaseReference userRef:_model.entityID] child:bThreadsPath] child:entityID];
    
    [userThreadsRef removeValueWithCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
        if (!error) {
            [BEntity pushUserThreadsUpdated:self.model.entityID];
            [promise resolveWithResult:self];
        }
        else {
            [promise rejectWithReason:error];
        }
    }];
    
    return promise;
}


-(void) goOnline {
    // When the push is complete mark the user as online
    FIRDatabaseReference * userOnlineRef = [FIRDatabaseReference userOnlineRef:self.entityID];
    [userOnlineRef setValue:@YES];
    [userOnlineRef onDisconnectSetValue:@NO];

    FIRDatabaseReference * onlineRef = [FIRDatabaseReference onlineRef:self.entityID];
    [onlineRef setValue:@{bTimeKey: [FIRServerValue timestamp],
                          bUID: _model.entityID}];
    
    [onlineRef onDisconnectRemoveValue];
}

-(void) goOffline {
    [[FIRDatabaseReference userOnlineRef:self.entityID] removeValue];
    [[FIRDatabaseReference onlineRef:self.entityID] removeValue];
//    [userOnlineRef setValue:@NO];
}

-(void) removeThreadOnDisconnect: (NSString *) entityID {
    FIRDatabaseReference * threadUsersRef = [[FIRDatabaseReference userThreadsRef:_model.entityID] child:entityID];
    [threadUsersRef onDisconnectRemoveValue];
}

@end
