//
//  BFirebaseEventHandler.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 10/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import "BFirebaseEventHandler.h"

#import <ChatSDKFirebase/FirebaseAdapter.h>

@implementation BFirebaseEventHandler

-(void) currentUserOn: (NSString *) entityID {
    
    id<PUser> user = [BChatSDK.db fetchEntityWithID:entityID withType:bUserEntity];

    [BHookNotification notificationUserOn:user];
    
    [self threadsOn:user];
    [self publicThreadsOn:user];
    [self contactsOn:user];
    [self moderationOn: user];
    [self onlineOn];

}

-(void) onlineOn {
    [[[[FIRDatabase database] reference] child:@".info/connected"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
        if (![snapshot.value isEqual: NSNull.null]) {
            NSLog(@"Connected");
        } else {
            NSLog(@"Disconnected");
        }
    }];
}

-(void) onlineOff {
    [[[[FIRDatabase database] reference] child:@".info/connected"] removeAllObservers];
}

-(void) threadsOn: (id<PUser>) user {
    NSString * entityID = user.entityID;

    FIRDatabaseReference * threadsRef = [FIRDatabaseReference userThreadsRef:entityID];
    [threadsRef observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * snapshot) {
        // Returns threads one by one
        if (snapshot.value != [NSNull null]) {
            // Make the new thread
            CCThreadWrapper * thread = [CCThreadWrapper threadWithEntityID:snapshot.key];
            if (![thread.model.users containsObject:user]) {
                [thread.model addUser:user];
            }
            
            [thread on];
            [thread messagesOn];
            [thread usersOn];
            [thread lastMessageOn];
            [thread metaOn];
        }
    }];
    
    [threadsRef observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * snapshot) {
        // Returns threads one by one
        if (snapshot.value != [NSNull null]) {
            // Make the new thread
            CCThreadWrapper * thread = [CCThreadWrapper threadWithEntityID:snapshot.key];
            [thread off];
            [thread messagesOff]; // We need to turn the messages off incase we rejoin the thread
            [thread lastMessageOff];
            [thread metaOff];
            
            [BChatSDK.core deleteThread:thread.model];
        }
    }];
}

-(void) publicThreadsOn: (id<PUser>) user {
    FIRDatabaseReference * publicThreadsRef = [FIRDatabaseReference publicThreadsRef];

    // TODO: This may cause issues if the device's clock is wrong
    FIRDatabaseQuery * query = [publicThreadsRef queryOrderedByChild:bCreationDate];
    double loadRoomsSince = ([[NSDate date] timeIntervalSince1970] - BChatSDK.config.publicChatRoomLifetimeMinutes * 60) * 1000;
    [query queryStartingAtValue: @(loadRoomsSince)];
    
    [query observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * snapshot) {
        if (snapshot.value != [NSNull null]) {
            // Make the new thread
            CCThreadWrapper * thread = [CCThreadWrapper threadWithEntityID:snapshot.key];
            
            // Make sure that we're not in the thread
            // there's an edge case where the user could kill the app and remain
            // a member of a public thread
            [thread removeUser:[CCUserWrapper userWithModel:user]];
            
            [thread on];
            
            // TODO: Maybe move this so we only listen to a thread when it's open
            [thread messagesOn];
            [thread usersOn];
            [thread lastMessageOn];
            [thread metaOn];
        }
    }];
}

-(void) contactsOn: (id<PUser>) user {
    
    FIRDatabaseReference * ref = [FIRDatabaseReference userContactsRef:BChatSDK.currentUserID];
    
    [ref observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * snapshot) {
        if(snapshot.value) {
            id<PUser> contact = [BChatSDK.db fetchOrCreateEntityWithID:snapshot.key withType:bUserEntity];
            if ([snapshot.value isKindOfClass: [NSDictionary class]]) {
                NSDictionary * dictionaryValue = (NSDictionary *) snapshot.value;
                NSNumber * type = dictionaryValue[bType];
                if (type) {
                    [BChatSDK.contact addLocalContact:contact withType:type.intValue];
                }
            }
        }
    }];
    
    [ref observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * snapshot) {
        if(snapshot.value) {
            id<PUser> contact = [BChatSDK.db fetchOrCreateEntityWithID:snapshot.key withType:bUserEntity];
            if ([snapshot.value isKindOfClass: [NSDictionary class]]) {
                NSDictionary * dictionaryValue = (NSDictionary *) snapshot.value;
                NSNumber * type = dictionaryValue[bType];
                if (type) {
                    [BChatSDK.contact deleteLocalContact:contact withType:type.intValue];
                }
            }
        }
    }];
}

-(void) moderationOn: (id<PUser>) user {
    if (BChatSDK.config.enableMessageModerationTab) {
        [BChatSDK.moderation on];
    }
}

-(void) currentUserOff: (NSString *) entityID {
    id<PUser> user = [BChatSDK.db fetchEntityWithID:entityID withType:bUserEntity];
    [self threadsOff:user];
    [self publicThreadsOff:user];
    [self contactsOff:user];
    [self moderationOff:user];
    [self onlineOff];
}

-(void) threadsOff: (id<PUser>) user {
    NSString * entityID = user.entityID;
    FIRDatabaseReference * threadsRef = [FIRDatabaseReference userThreadsRef:entityID];
    [threadsRef removeAllObservers];
    
    if (user) {
        for (id<PThread> threadModel in user.threads) {
            CCThreadWrapper * thread = [CCThreadWrapper threadWithModel:threadModel];
            [thread off];
        }
    }
}

-(void) publicThreadsOff: (id<PUser>) user {
    FIRDatabaseReference * publicThreadsRef = [FIRDatabaseReference publicThreadsRef];
    for (id<PThread> threadModel in [BChatSDK.core threadsWithType:bThreadTypePublicGroup]) {
        CCThreadWrapper * thread = [CCThreadWrapper threadWithModel:threadModel];
        [thread off];
    }
    [publicThreadsRef removeAllObservers];
}

-(void) contactsOff: (id<PUser>) user {
    for (id<PUserConnection> contact in [user connectionsWithType:bUserConnectionTypeContact]) {
        // Turn the contact on
        id<PUser> contactModel = contact.user;
        [[CCUserWrapper userWithModel:contactModel] off];
        [[CCUserWrapper userWithModel:contactModel] onlineOff];
    }
}

-(void) moderationOff: (id<PUser>) user {
    if (BChatSDK.config.enableMessageModerationTab) {
        [BChatSDK.moderation off];
    }
}


@end
