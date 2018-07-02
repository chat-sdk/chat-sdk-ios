//
//  BUser+BUser_Chatcat.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 09/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import <ChatSDK/CCUserWrapper.h>
#import <ChatSDK/FirebaseAdapter.h>

@implementation CCUserWrapper

+(id) userWithAuthUserData: (FIRUser *) data {
    return [[self alloc] initWithAuthUserData:data];
}

-(id) initWithAuthUserData: (FIRUser *) data {
    if((self = [self init])) {
        
        // Get the model from the database if it exists
        _model = [[BStorageManager sharedManager].a fetchOrCreateEntityWithID:data.uid withType:bUserEntity];
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
    id<PUser> user = [[BStorageManager sharedManager].a fetchOrCreateEntityWithID:entityID withType:bUserEntity];
    return [[self alloc] initWithModel: user];
}

+(id) userWithSnapshot: (FIRDataSnapshot *) data {
    return [[self alloc] initWithSnapshot:data];
}

-(id) initWithSnapshot: (FIRDataSnapshot *) data {
    if ((self = [self init])) {
        _model = [[BStorageManager sharedManager].a fetchOrCreateEntityWithID:data.key withType:bUserEntity];
        [self deserialize:data.value];
    }
    return self;
}

-(void) updateUserFromAuthUserData: (FIRUser *) user {
    
    NSArray * dataProvider = user.providerData;
    BOOL profilePictureSet = NO;
    
    for (id<FIRUserInfo> provider in dataProvider) {
        
        //NSDictionary * userData = data.providerData;
        
        //_model.entityID = data.uid;
        //_model.authenticationType = data.provider;
        
            // TODO: Meta data
        NSString * name = provider.displayName;
        if (name && !_model.name) {
            _model.name = name;
        }

        NSString * email = provider.email;
        if (email && !_model.email) {
            [_model setMetaString:email forKey:bEmailKey];
        }

        NSString * phoneNumber = provider.phoneNumber;
        if (phoneNumber && !_model.phoneNumber) {
            [_model setMetaString:phoneNumber forKey:bPhoneKey];
        }

        NSString * profileURL = [provider.photoURL absoluteString];
        if (profileURL && ![self.model metaStringForKey:bPictureURLKey]) {
            
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
//            account = [[BStorageManager sharedManager].a createEntity:bUserAccountEntity];
//            account.type = @(bAccountTypeFacebook);
//            [_model addLinkedAccountsObject:account];
//        }
    }
    
    // Must set name before robot image to ensure they are different
    // Must be set outside of the provider loop as anonymous logins don't user data prodivers
    if (!_model.name) {
        _model.name = [BChatSDK shared].configuration.defaultUserName;
    }
    
    if (!profilePictureSet && ![self.model metaStringForKey:bPictureURLKey]) {
        
        // If the user doesn't have a default profile picture then set it automatically
        UIImage * defaultImage = [self.model.defaultImage resizedImage:bProfilePictureSize interpolationQuality:kCGInterpolationHigh];
        UIImage * thumbnail = [defaultImage resizedImage:bProfilePictureThumbnailSize interpolationQuality:kCGInterpolationHigh];
        
        // Update the user
        [self.model setImage:UIImagePNGRepresentation(defaultImage)];
        [self.model setThumbnail:UIImagePNGRepresentation(thumbnail)];
        
        [self setPersonProfilePicture];
    }
    
    // Setup the message color defaults
    // TODO: Maybe remove this...
    if (!_model.messageColor || !_model.messageColor.length) {
        _model.messageColor = [BCoreUtilities colorToString:[BCoreUtilities colorWithHexString:[BChatSDK shared].configuration.messageColorMe]];
    }
}

- (RXPromise *)setProfilePictureWithImageURL: (NSString *)url {
    
    id<PUser> user = NM.currentUser;
    
    // Only set the user picture if they are logging on the first time
    if (url && !user.thumbnail) {
        
        return [BCoreUtilities fetchImageFromURL:url].thenOnMain(^id(UIImage * image) {
            
            if(image) {
                
                UIImage * thumbnail = [image resizeImageToSize:bProfilePictureThumbnailSize];
                //UIImage * thumbnail = [image resizedImage:bProfilePictureThumbnailSize interpolationQuality:kCGInterpolationHigh];
                
                [user setImage:UIImagePNGRepresentation(image)];
                [user setThumbnail:UIImagePNGRepresentation(thumbnail)];
                
                if(NM.upload) {
                    return [NM.upload uploadImage:image thumbnail:thumbnail].thenOnMain(^id(NSDictionary * urls) {
                        
                        // Set the meta data
                        [user setMetaString:urls[bImagePath] forKey:bPictureURLKey];
                        [user setMetaString:urls[bThumbnailPath] forKey:bPictureURLThumbnailKey];
                        
                        return [user loadProfileImage:NO].thenOnMain(^id(UIImage * image) {
                            
                            return [NM.core pushUser];
                        }, Nil);
                    }, Nil);
                }
                else {
                    return [NM.core pushUser];
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
        
        _model = [[BStorageManager sharedManager].a fetchOrCreateEntityWithID:entityID
                                                                           withType:bUserEntity];
        
    }
    return self;
}


-(RXPromise *) once {
    
    NSString * token = NM.auth.loginInfo[bTokenKey];
    FIRDatabaseReference * ref = [FIRDatabaseReference userRef:self.entityID];

    return [BCoreUtilities getWithPath:[ref.description stringByAppendingString:@".json"] parameters:@{@"auth": token}].thenOnMain(^id(NSDictionary * response) {

        return [self deserialize:response].thenOnMain(^id(id success) {
            return self;
        }, Nil);

    }, Nil);
    
//    FIRDatabaseReference * ref = [FIRDatabaseReference userRef:self.entityID];
//
//    RXPromise * promise = [RXPromise new];
//
//    __block FIRDatabaseHandle handle = 0;
//
//    handle = [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
//        if (handle != 0) {
//            [ref removeObserverWithHandle:handle];
//        }
//        if(![snapshot.value isEqual: [NSNull null]]) {
//            [promise resolveWithResult: [self deserialize:snapshot.value].thenOnMain(^id(id success) {
//                return self;
//            }, Nil)];
//        }
//        else {
//            [promise resolveWithResult:Nil];
//        }
//    } withCancelBlock: ^(NSError * error) {
//        NSLog(@"Error");
//    }];

//    return promise;
}

-(RXPromise *) on {
    RXPromise * promise = [RXPromise new];
    
    if (((NSManagedObject *)_model).on) {
        [promise resolveWithResult:Nil];
        return promise;
    }
    ((NSManagedObject *)_model).on = YES;

    FIRDatabaseReference * ref = [FIRDatabaseReference userRef:self.entityID];
    
    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
        if(![snapshot.value isEqual: [NSNull null]]) {
            [promise resolveWithResult:[self deserialize:snapshot.value].thenOnMain(^id(id success) {
                return self;
            }, Nil)];
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
    RXPromise * promise = [RXPromise new];
    
    if (((NSManagedObject *)_model).metaOn) {
        [promise resolveWithResult:Nil];
        return promise;
    }
    ((NSManagedObject *)_model).metaOn = YES;
    
    FIRDatabaseReference * ref = [FIRDatabaseReference userMetaRef:self.entityID];
    
    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
        if(![snapshot.value isEqual: [NSNull null]]) {
            [promise resolveWithResult:[self deserializeMeta:snapshot.value].thenOnMain(^id(id success) {
                [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationUserUpdated object:Nil userInfo:@{bNotificationUserUpdated_PUser: self.model}];
                return self;
            }, Nil)];
        }
        else {
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
            if (NM.auth.userAuthenticated) {
                [NM.search updateIndexForUser:self.model];
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
    changeRequest.photoURL = [NSURL URLWithString:[self.model metaStringForKey:bPictureURLKey]];
    
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

-(RXPromise *) deserialize: (NSDictionary *) value {
    
    NSNumber * online = value[b_Online];
    if (online) {
        _model.online = online;
    }
        
    return [self deserializeMeta:value[bMetaDataPath]];
}

-(NSDictionary *) serialize {
    return @{b_Meta: _model.metaDictionary};
}

// TODO: Find a way to determine if the meta has actually been updated i.e. is it 
-(RXPromise *) deserializeMeta: (NSDictionary *) value {
    // Get the user's meta data
    NSMutableDictionary * meta = [NSMutableDictionary dictionaryWithDictionary:_model.metaDictionary];
    NSDictionary * newMeta = value;

    // Check to see if the image has changed
    BOOL thumbnailChanged = ![meta[bPictureURLThumbnailKey] isEqualToString:newMeta[bPictureURLThumbnailKey]];
    BOOL imageChanged = ![meta[bPictureURLKey] isEqualToString:newMeta[bPictureURLKey]];
    
    for (NSString * key in [newMeta allKeys]) {
        if (![meta[key] isEqual:newMeta[key]]) {
            meta[key] = newMeta[key];
        }
    }
    
    if (meta) {
        [_model setMetaDictionary:meta];
    }
    
    NSMutableArray * promises = [NSMutableArray new];
    [promises addObject:[_model loadProfileThumbnail:thumbnailChanged]];
    
    if (self.entityID == NM.currentUser.entityID) {
        [promises addObject:[_model loadProfileImage:imageChanged]];
    }
    
    return [RXPromise all:promises];
}

-(FIRDatabaseReference *) ref {
    return [[[FIRDatabaseReference userRef:_model.entityID] child:bUsersPath] child:_model.entityID];
}

-(FIRDatabaseReference *) metaRef {
    return [[self ref] child:bMetaDataPath];
}

-(FIRDatabaseReference *) thumbnailRef {
    return [[self ref] child:bThumbnailPath];
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

    [userThreadsRef setValue:@{b_InvitedBy: NM.currentUser.entityID} withCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
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
