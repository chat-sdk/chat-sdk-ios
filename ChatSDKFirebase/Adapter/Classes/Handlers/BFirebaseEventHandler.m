//
//  BFirebaseEventHandler.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 10/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import "BFirebaseEventHandler.h"

#import <ChatSDKFirebase/FirebaseAdapter.h>
#import <ChatSDKFirebase/ChatSDKFirebase-Swift.h>

@implementation BFirebaseEventHandler

-(void) currentUserOn: (NSString *) entityID {
        
    id<PUser> user = [BChatSDK.db fetchEntityWithID:entityID withType:bUserEntity];
    
    if (!user.entityID) {
        NSLog(@"");
    }

    [BHookNotification notificationUserOn:user];
    
    [self threadsOn:user];
    if (!BChatSDK.config.disablePublicThreads) {
        [self publicThreadsOn:user];
    }
    [self contactsOn:user];
//    [self moderationOn: user];
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
            CCThreadWrapper * thread = [FirebaseNetworkAdapterModule.shared.firebaseProvider threadWrapperWithEntityID:snapshot.key];
            if (![thread.model.users containsObject:user]) {
                [thread.model addUser:user];
            }
            
            [thread on].thenOnMain(^id(id success) {
                [BHookNotification notificationThreadAdded:thread.model];
                return success;
            }, nil);

        }
    }];
    
    [threadsRef observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * snapshot) {
        // Returns threads one by one
        if (snapshot.value != [NSNull null]) {
            // Make the new thread
            CCThreadWrapper * thread = [FirebaseNetworkAdapterModule.shared.firebaseProvider threadWrapperWithEntityID:snapshot.key];

            [thread off];
            [thread messagesOff]; // We need to turn the messages off incase we rejoin the thread
            
            [BChatSDK.thread deleteThread:thread.model];
        }
    }];
}

-(void) publicThreadsOn: (id<PUser>) user {
    FIRDatabaseReference * publicThreadsRef = [FIRDatabaseReference publicThreadsRef];

    // TODO: This may cause issues if the device's clock is wrong
    FIRDatabaseQuery * query = [publicThreadsRef queryOrderedByChild:bCreationDate];
    
    if (BChatSDK.config.publicChatRoomLifetimeMinutes != 0) {
            double loadRoomsSince = ([[NSDate date] timeIntervalSince1970] - BChatSDK.config.publicChatRoomLifetimeMinutes * 60) * 1000;
            query = [query queryStartingAtValue: @(loadRoomsSince)];
    }

    [query observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * snapshot) {
        if (snapshot.value != [NSNull null]) {
            // Make the new thread
            CCThreadWrapper * thread = [FirebaseNetworkAdapterModule.shared.firebaseProvider threadWrapperWithEntityID:snapshot.key];
            
            // Make sure that we're not in the thread
            // there's an edge case where the user could kill the app and remain
            // a member of a public thread
            if (!BChatSDK.config.publicChatAutoSubscriptionEnabled) {
                [thread removeUser:[FirebaseNetworkAdapterModule.shared.firebaseProvider userWrapperWithModel:user]];
            }
            
            [thread on].thenOnMain(^id(id success) {
                [BHookNotification notificationThreadAdded:thread.model];
                return success;
            }, nil);

            // TODO: Maybe move this so we only listen to a thread when it's open
//            [thread messagesOn];
//            [thread usersOn];
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

//-(void) moderationOn: (id<PUser>) user {
//    if (BChatSDK.config.enableMessageModerationTab) {
//        [BChatSDK.moderation on];
//    }
//}

-(void) currentUserOff: (NSString *) entityID {
    id<PUser> user = [BChatSDK.db fetchEntityWithID:entityID withType:bUserEntity];
    [self threadsOff:user];
    
    if (!BChatSDK.config.disablePublicThreads) {
        [self publicThreadsOff:user];
    }

    [self contactsOff:user];
//    [self moderationOff:user];
    [self onlineOff];
}

-(void) threadsOff: (id<PUser>) user {
    NSString * entityID = user.entityID;
    FIRDatabaseReference * threadsRef = [FIRDatabaseReference userThreadsRef:entityID];
    [threadsRef removeAllObservers];
    
    if (user) {
        for (id<PThread> threadModel in user.threads) {
            CCThreadWrapper * thread = [FirebaseNetworkAdapterModule.shared.firebaseProvider threadWrapperWithModel: threadModel];
            [thread off];
        }
    }
}

-(void) publicThreadsOff: (id<PUser>) user {
    FIRDatabaseReference * publicThreadsRef = [FIRDatabaseReference publicThreadsRef];
    for (id<PThread> threadModel in [BChatSDK.thread threadsWithType:bThreadTypePublicGroup]) {
        CCThreadWrapper * thread = [FirebaseNetworkAdapterModule.shared.firebaseProvider threadWrapperWithModel: threadModel];
        [thread off];
    }
    [publicThreadsRef removeAllObservers];
}

-(void) contactsOff: (id<PUser>) user {
    for (id<PUserConnection> contact in [user connectionsWithType:bUserConnectionTypeContact]) {
        // Turn the contact on
        id<PUser> contactModel = contact.user;
        CCUserWrapper * wrapper = [FirebaseNetworkAdapterModule.shared.firebaseProvider userWrapperWithModel:contactModel];
        
        [wrapper off];
        [wrapper onlineOff];
    }
}

//-(void) moderationOff: (id<PUser>) user {
//    if (BChatSDK.config.enableMessageModerationTab) {
//        [BChatSDK.moderation off];
//    }
//}


@end
