//
//  CDUser.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 18/08/2016.
//
//

#import <ChatSDK/Core.h>
#import <ChatSDK/CoreData.h>

#define bKeyKey @"key"
#define bValueKey @"value"

@implementation CDUser

-(void) setName: (NSString *) name {
    [self setMetaString:name forKey:bUserNameKey];
}

-(NSString *) name {
    return [self metaStringForKey:bUserNameKey];
}

-(void) setEmail:(NSString *)email {
    [self setMetaString:email forKey:bUserEmailKey];
}

-(NSString *) email {
    return [self metaStringForKey:bUserEmailKey];
}

-(NSString *) phoneNumber {
    return [self metaStringForKey:bUserPhoneKey];
}

-(void) setPhoneNumber:(NSString *)phoneNumber {
    [self setMetaString:phoneNumber forKey:bUserPhoneKey];
}

-(NSString *) pushChannel {
    return [[NSString stringWithFormat:@"%@_%@", bUserPrefixKey, [self.entityID stringByReplacingOccurrencesOfString:@":" withString:@"_"]] stringByReplacingOccurrencesOfString:@"%3A" withString:@"_"];
}


-(CDUserAccount *) accountWithType: (bAccountType) type {
    for (CDUserAccount * account in self.linkedAccounts) {
        if (account.type.intValue == type) {
            return account;
        }
    }
    return Nil;
}

//-(void) addContact: (id<PUser>) user {
//    [self addConnection:user withType:bUserConnectionTypeContact];
//}

// TODO: Do we need this?
-(NSArray *) contactsWithType: (bUserConnectionType) type {
    NSMutableArray * users = [NSMutableArray new];
    for (id<PUserConnection> c in [self connectionsWithType:type]) {
        [users addObject: c.user];
    }
    return users;
}

-(NSArray<PUserConnection> *) connectionsWithType: (bUserConnectionType) type {
    NSMutableArray * connections = [NSMutableArray new];
    for (CDUserConnection * c in self.userConnections) {
        if (c.entityID && c.userConnectionType == type) {
            [connections addObject:c];
        }
    }
    [connections sortUsingComparator:^NSComparisonResult(id<PUserConnection> uc1, id<PUserConnection> uc2) {
        return [uc1.user.name compare:uc2.user.name];
    }];
    return connections;
    
}

-(void) addConnection: (id<PUserConnection>) connection {
    if (![self.userConnections containsObject:connection] && ![self connectionExists:connection] && ![connection.entityID isEqualToString:self.entityID]) {
        [self addUserConnectionsObject:connection];
    }
}

-(BOOL) connectionExists: (CDUserConnection *) connection {
    for (CDUserConnection * conn in self.userConnections) {
        if([self connection:connection isEqual:conn]) {
            return YES;
        }
    }
    return NO;
}

-(BOOL) connection: (CDUserConnection *) c1 isEqual: (CDUserConnection *) c2 {
    return [c1.entityID isEqualToString:c2.entityID] && c1.userConnectionType == c2.userConnectionType;
}

-(void) removeConnection: (id<PUserConnection>) connection {
    for (CDUserConnection * c in self.userConnections) {
        if ([self connection:connection isEqual:c]) {
            [self removeConnection:c];
        }
    }
}

-(RXPromise *) loadProfileImage: (BOOL) force __attribute__((deprecated)) {
    
    if (!self.image || force) {
        
        // If there's no image set on temporarily
        if(!self.image) {
            [self setImage: UIImagePNGRepresentation(self.defaultImage)];
        }
        
        // Then try to load the image from the URL
        NSString * imageURL = [self metaStringForKey:bUserPictureURLKey];
        if (imageURL) {
            return [BCoreUtilities fetchImageFromURL:imageURL].thenOnMain(^id(UIImage * image) {
                if(image) {
                    [self setImage:UIImagePNGRepresentation(image)];
                }
                return image;
            }, Nil);
        }
    }
    RXPromise * promise = [RXPromise new];
    [promise resolveWithResult:[UIImage imageWithData:self.image]];
    return promise;
}

// TODO: Check this
-(RXPromise *) loadProfileThumbnail: (BOOL) force {
    
    if (!self.thumbnail || force) {
        
        // If there's no image set on temporarily
        if(!self.thumbnail) {
            [self setThumbnail: UIImagePNGRepresentation(self.defaultImage)];
        }
        
        // Then try to load the image from the URL
        NSString * imageURL = [self metaStringForKey:bUserPictureURLKey];
        if (imageURL) {
            return [BCoreUtilities fetchImageFromURL:imageURL].thenOnMain(^id(UIImage * image) {
                if(image) {
                    [self setThumbnail:UIImagePNGRepresentation(image)];
                }
                return image;
            }, Nil);
        }
    }
    RXPromise * promise = [RXPromise new];
    [promise resolveWithResult:[UIImage imageWithData:self.thumbnail]];
    return promise;
}

-(int) unreadMessageCount {
    // Get all the threads
    int i = 0;
    for (id<PThread> thread in self.threads) {
        if (thread.type.intValue & bThreadFilterPrivate) {
            for (id<PMessage> message in thread.messagesOrderedByDateDesc) {
                if (!message.read.boolValue) {
                    i++;
                }
            }
        }
    }
    return i;
}

-(id<PUser>) model {
    return self;
}

+(NSString *) firebaseUIDFromFacebookID: (NSString *) fid {
    return [@"facebook:" stringByAppendingString:fid];
}

-(void) setStatusDictionary: (NSDictionary *) dictionary {
    self.status = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
}

-(NSDictionary *) getStatusDictionary {
    return self.status ? [NSKeyedUnarchiver unarchiveObjectWithData:self.status] : Nil;
}

-(void) setStatusValue: (id) value forKey: (NSString *) key {
    NSDictionary * status = self.getStatusDictionary ? self.getStatusDictionary : [NSDictionary new];
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:status];
    [dict setValue:value forKey:key];
    [self setStatusDictionary:dict];
}

-(void) setState: (NSString *) state {
    [self setStatusValue:state forKey:bUserStateKey];
}

-(NSString *) state {
    return self.getStatusDictionary[bUserStateKey];
}

-(void) setStatusText: (NSString *) statusText {
    [self setStatusValue:statusText forKey:bUserStatusTextKey];
}

-(NSString *) statusText {
    return self.getStatusDictionary[bUserStatusTextKey];
}

-(UIImage *) thumbnailAsImage {
    return [[self imageAsImage] resizedImage:bProfilePictureThumbnailSize interpolationQuality:kCGInterpolationHigh];
}

-(UIImage *) imageAsImage {
    if (self.image) {
        return [[UIImage imageWithData:self.image] resizedImage:bProfilePictureSize interpolationQuality:kCGInterpolationHigh];
    }
    else {
        return [self defaultImage];
    }
}

-(NSString *) imageURL {
    return [self metaStringForKey:bUserPictureURLKey];
}

-(void) setImageURL: (NSString *) url {
    [self setMetaString:url forKey:bUserPictureURLKey];
    [self setMetaString:url forKey:bUserPictureURLThumbnailKey];
}

// TODO: Remove UI dependency on CoreData
-(UIImage *) defaultImage {
    return [BChatSDK config].defaultBlankAvatar;
}

-(BOOL) isMe {
    return [self.entityID isEqualToString:NM.currentUser.entityID];
}

-(void) optimize {
    for (CDThread * thread in self.threads) {
        [thread optimize];
    }
}

@end
