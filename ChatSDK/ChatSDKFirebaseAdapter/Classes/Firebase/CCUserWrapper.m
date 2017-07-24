//
//  BUser+BUser_Chatcat.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 09/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import "CCUserWrapper.h"

#import <ChatSDKFirebaseAdapter/NSManagedObject+Status.h>

#import <ChatSDKFirebaseAdapter/ChatFirebaseAdapter.h>
#import <ChatSDKCore/ChatCore.h>


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
        NSString * tempName = [@"User " stringByAppendingFormat:@"%i", arc4random() % 9999];
        _model.name = tempName;
    }
    
    if (!profilePictureSet && ![self.model metaStringForKey:bPictureURLKey]) {
        
        // If the user doesn't have a default profile picture then set it automatically
        UIImage * defaultImage = [self.model.defaultImage resizedImage:bProfilePictureSize interpolationQuality:kCGInterpolationHigh];
        UIImage * thumbnail = [defaultImage resizedImage:bProfilePictureThumbnailSize interpolationQuality:kCGInterpolationHigh];
        
        // Update the user
        [self.model setImage:UIImagePNGRepresentation(defaultImage)];
        [self.model setThumbnail:UIImagePNGRepresentation(thumbnail)];
        
        //[self setRobotProfilePicture];
    }
    
    // Setup the message color defaults
    if (!_model.messageColor || !_model.messageColor.length) {
        _model.messageColor = [BCoreUtilities colorToString:[BCoreUtilities colorWithHexString:bDefaultMessageColorMe]];
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
                
                return [NM.upload uploadImage:image thumbnail:thumbnail].thenOnMain(^id(NSDictionary * urls) {
                    
                    // Set the meta data
                    [user setMetaString:urls[bImagePath] forKey:bPictureURLKey];
                    [user setMetaString:urls[bThumbnailPath] forKey:bPictureURLThumbnailKey];
                    
                    return [user loadProfileImage:NO].thenOnMain(^id(UIImage * image) {
                        
                        return [NM.core pushUser];
                    }, Nil);
                }, Nil);
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
                [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationUserUpdated object:Nil userInfo:Nil];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationUserUpdated object:Nil userInfo:Nil];
        }
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
    
    NSString * uid = value[b_AuthenticationID];
    if (uid) {
        _model.entityID = uid;
    }
    
    NSNumber * online = value[b_Online];
    if (online) {
        _model.online = online;
    }
        
    return [self deserializeMeta:value[bMetaDataPath]];
}

-(NSDictionary *) serialize {

    return @{b_AuthenticationID: self.entityID,
             
             b_Meta: _model.metaDictionary};
}

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

    [userThreadsRef setValue:@{bNullString: @""} withCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
        if (!error) {
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
}

-(void) goOffline {
    FIRDatabaseReference * userOnlineRef = [FIRDatabaseReference userOnlineRef:self.entityID];
    [userOnlineRef setValue:@NO];
}

-(void) removeThreadOnDisconnect: (NSString *) entityID {
    FIRDatabaseReference * threadUsersRef = [[FIRDatabaseReference userThreadsRef:_model.entityID] child:entityID];
    [threadUsersRef onDisconnectRemoveValue];
}

@end
