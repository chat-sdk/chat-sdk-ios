//
//  BStateManager.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 10/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import "BStateManager.h"

#import <ChatSDKCore/ChatCore.h>
#import <ChatSDKFirebaseAdapter/ChatFirebaseAdapter.h>

@implementation BStateManager

+(void) userOn: (NSString *) entityID {
    
    FIRDatabaseReference * threadsRef = [FIRDatabaseReference userThreadsRef:entityID];
    [threadsRef observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * snapshot) {
        // Returns threads one by one
        if (snapshot.value != [NSNull null]) {
            // Make the new thread
            CCThreadWrapper * thread = [CCThreadWrapper threadWithEntityID:snapshot.key];
            id<PUser> user = [BNetworkManager sharedManager].a.core.currentUserModel;
            if (![thread.model.users containsObject:user]) {
                [thread.model addUser:user];
            }
            
            [thread on];
            [thread messagesOn];
            [thread usersOn];
        }
    }];
    
    [threadsRef observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * snapshot) {
        // Returns threads one by one
        if (snapshot.value != [NSNull null]) {
            // Make the new thread
            CCThreadWrapper * thread = [CCThreadWrapper threadWithEntityID:snapshot.key];
            [thread off];
        }
    }];
    
    FIRDatabaseReference * publicThreadsRef = [FIRDatabaseReference publicThreadsRef];
    [publicThreadsRef observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * snapshot) {
        if (snapshot.value != [NSNull null]) {
            // Make the new thread
            CCThreadWrapper * thread = [CCThreadWrapper threadWithEntityID:snapshot.key];
            id<PUser> user = [BNetworkManager sharedManager].a.core.currentUserModel;
            
            // Make sure that we're not in the thread
            // there's an edge case where the user could kill the app and remain
            // a member of a public thread
            [thread removeUser:[CCUserWrapper userWithModel:user]];
            
            [thread on];
            
            // TODO: Maybe move this so we only listen to a thread when it's open
            [thread messagesOn];
            [thread usersOn];
        }
    }];
    
    id<PUser> user = [[BStorageManager sharedManager].a fetchEntityWithID:entityID withType:bUserEntity];
    
    if ([BNetworkManager sharedManager].a.push && [[BNetworkManager sharedManager].a.push respondsToSelector:@selector(subscribeToPushChannel:)]) {
        [[BNetworkManager sharedManager].a.push subscribeToPushChannel:user.pushChannel];
    }
    
    for (id<PUserConnection> contact in [user connectionsWithType:bUserConnectionTypeContact]) {
        // Turn the contact on
        id<PUser> contactModel = contact.user;
        [[CCUserWrapper userWithModel:contactModel] metaOn];
        [[CCUserWrapper userWithModel:contactModel] onlineOn];
    }
}

+(void) userOff: (NSString *) entityID {

    id<PUser> user = [[BStorageManager sharedManager].a fetchEntityWithID:entityID withType:bUserEntity];
    
    FIRDatabaseReference * publicThreadsRef = [FIRDatabaseReference publicThreadsRef];
    [publicThreadsRef removeAllObservers];
    
    FIRDatabaseReference * threadsRef = [FIRDatabaseReference userThreadsRef:entityID];
    [threadsRef removeAllObservers];
    
    if (user) {
        for (id<PThread> threadModel in user.threads) {
            CCThreadWrapper * thread = [CCThreadWrapper threadWithModel:threadModel];
            [thread off];
        }
    }
    
    for (id<PThread> threadModel in [[BNetworkManager sharedManager].a.core threadsWithType:bThreadTypePublicGroup]) {
        CCThreadWrapper * thread = [CCThreadWrapper threadWithModel:threadModel];
        [thread off];
    }
    
    for (id<PUserConnection> contact in [user connectionsWithType:bUserConnectionTypeContact]) {
        // Turn the contact on
        id<PUser> contactModel = contact.user;
        [[CCUserWrapper userWithModel:contactModel] off];
        [[CCUserWrapper userWithModel:contactModel] onlineOff];
    }

    if ([BNetworkManager sharedManager].a.push && [[BNetworkManager sharedManager].a.push respondsToSelector:@selector(unsubscribeToPushChannel:)]) {
        [[BNetworkManager sharedManager].a.push unsubscribeToPushChannel:user.pushChannel];
    }
}

@end
