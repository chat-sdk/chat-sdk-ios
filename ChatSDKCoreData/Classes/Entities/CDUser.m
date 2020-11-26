//
//  CDUser.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 18/08/2016.
//
//

#import <ChatSDK/Core.h>
#import <ChatSDK/CoreData.h>
#import <ChatSDK/ChatSDK-Swift.h>

#define bKeyKey @"key"
#define bValueKey @"value"

@implementation CDUser

-(void) setName: (NSString *) name {
    [self setMetaValue:name forKey:bUserNameKey];
}

-(NSString *) name {
    NSString * name = [self.meta metaStringForKey:bNickname];
    if (!name || !name.length) {
        name = [self.meta metaStringForKey:bUserNameKey];
    }
    return name;
}

//-(NSString *) displayName {
//    return self.name && self.name.length : self.name ? @"???";
//}

-(void) setEmail:(NSString *)email {
    [self setMetaValue:email forKey:bUserEmailKey];
}

-(NSString *) email {
    return [self.meta metaStringForKey:bUserEmailKey];
}

-(NSString *) phoneNumber {
    return [self.meta metaStringForKey:bUserPhoneKey];
}

-(void) setPhoneNumber:(NSString *)phoneNumber {
    [self setMetaValue:phoneNumber forKey:bUserPhoneKey];
}

-(NSString *) pushChannel {
    NSString * channel = self.entityID;
    channel = [channel stringByReplacingOccurrencesOfString:@"." withString:@"1"];
    channel = [channel stringByReplacingOccurrencesOfString:@"%2E" withString:@"1"];
    channel = [channel stringByReplacingOccurrencesOfString:@"@" withString:@"2"];
    channel = [channel stringByReplacingOccurrencesOfString:@"%40" withString:@"2"];
    channel = [channel stringByReplacingOccurrencesOfString:@":" withString:@"3"];
    channel = [channel stringByReplacingOccurrencesOfString:@"%3A" withString:@"3"];
    return channel;
}

-(void) updateMeta: (NSDictionary *) dict {
    if (!self.meta) {
        self.meta = @{};
    }
    self.meta = [self.meta updateMetaDict:dict];
}

-(void) setMetaValue: (id) value forKey: (NSString *) key {
    [self updateMeta:@{key: [NSString safe: value]}];
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
    if (![self.userConnections containsObject:connection] && ![self connectionExists:connection] && ![connection isEqualToEntity:self]) {
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
    return [c1 isEqualToEntity:c2] && c1.userConnectionType == c2.userConnectionType;
}

-(void) removeConnection: (id<PUserConnection>) connection {
    [self removeUserConnectionsObject:connection];
}

-(RXPromise *) updateAvatarFromURL {

    // If there's no image set on temporarily
//    if(!self.image) {
//        [self setImage: UIImagePNGRepresentation(self.defaultImage)];
//    }

    // Then try to load the image from the URL
    NSString * imageURL = self.imageURL;
    if (imageURL) {
        return [BCoreUtilities fetchImageFromURL:[NSURL URLWithString:imageURL]].thenOnMain(^id(UIImage * image) {
            if(image) {
                [self setImage:UIImagePNGRepresentation(image)];
            }
            return Nil;
        }, Nil);
    }
    return [RXPromise resolveWithResult:Nil];
}

-(int) unreadMessageCount {
    // Get all the threads
    int i = 0;
    for (id<PThread> thread in self.threads) {
        if (thread.type.intValue & bThreadFilterPrivate) {
            for (id<PMessage> message in thread.messagesOrderedByDateDesc) {
                if (!message.isRead) {
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

-(void) setAvailability: (NSString *) availability {
    [self setMetaValue:availability forKey:bUserAvailabilityKey];
}

-(NSString *) availability {
    return [self.meta valueForKey:bUserAvailabilityKey];
}

-(void) setStatusText: (NSString *) statusText {
    [self setMetaValue:statusText forKey:bUserStatusTextKey];
}

-(NSString *) statusText {
    return [self.meta valueForKey:bUserStatusTextKey];
}

-(UIImage *) imageAsImage {
    if (self.image) {
        UIImage * image = [UIImage imageWithData:self.image];
        if (image.size.height > bProfilePictureSize.height && image.size.width > bProfilePictureSize.width) {
            return [[UIImage imageWithData:self.image] resizedImage:bProfilePictureSize interpolationQuality:kCGInterpolationHigh];
        } else {
            return image;
        }
    }
    return nil;
}

-(NSString *) imageURL {
    return [self.meta metaStringForKey:bUserImageURLKey];
}

-(void) setImageURL: (NSString *) url {
    [self updateMeta:@{bUserImageURLKey: url}];
}

// TODO: Remove UI dependency on CoreData
//-(UIImage *) defaultImage {
//    return [Icons getWithName:Icons.defaultProfile];
//}

-(BOOL) isMe {
    return [self isEqualToEntity:BChatSDK.currentUser];
}

-(BOOL) isEqualToEntity: (id<PEntity>) entity {
    return [self.entityID isEqualToString:entity.entityID];
}

-(void) clearPublicKeys {
    [self setMetaValue:@{} forKey:bUserPublicKeysKey];
}

-(BOOL) addPublicKey: (NSString *) key identifier: (NSString *) identifier {
    [BChatSDK.shared.logger log: @"Public Key - Add - %@, %@, %@", BChatSDK.currentUserID, identifier, key];
    if (!key || !key.length) {
        return false;
    }
    NSMutableDictionary * keys = [NSMutableDictionary dictionaryWithDictionary:self.meta[bUserPublicKeysKey]];
    for (NSString * existing in keys.allValues) {
        if ([existing isEqual:key]) {
            return false;
        }
    }
    [keys setObject:key forKey:identifier];
    [self setMetaValue:keys forKey:bUserPublicKeysKey];
    return true;
}

-(void) removePublicKey: (NSString *) key {
    NSMutableDictionary * keys = [NSMutableDictionary dictionaryWithDictionary:self.meta[bUserPublicKeysKey]];
    NSString * identifier;
    for (NSString * existing in keys.allKeys) {
        if ([keys[existing] isEqual:key]) {
            identifier = existing;
            break;
        }
    }
    [keys removeObjectForKey:identifier];
    [self setMetaValue:keys forKey:bUserPublicKeysKey];
}

-(NSString *) publicKeyForIdentifier: (NSString *) identifier {
    return self.publicKeys[identifier];
}

-(NSDictionary *) publicKeys {
    return self.meta[bUserPublicKeysKey];
}


@end
