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
    
    id<PUser> user = [[BStorageManager sharedManager].a fetchEntityWithID:entityID withType:bUserEntity];
    
    NSDictionary * data = @{bHookUserOn_PUser_User: user};
    [NM.hook executeHookWithName:bHookUserOn data:data];
    
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
        }
    }];
    
    [threadsRef observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * snapshot) {
        // Returns threads one by one
        if (snapshot.value != [NSNull null]) {
            // Make the new thread
            CCThreadWrapper * thread = [CCThreadWrapper threadWithEntityID:snapshot.key];
            [thread off];
            [thread messagesOff]; // We need to turn the messages off incase we rejoin the thread
            
            [NM.core deleteThread:thread.model];
        }
    }];
    
    FIRDatabaseReference * publicThreadsRef = [FIRDatabaseReference publicThreadsRef];
    [publicThreadsRef observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * snapshot) {
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
        }
    }];
    
    if (NM.push && [NM.push respondsToSelector:@selector(subscribeToPushChannel:)]) {
        [NM.push subscribeToPushChannel:user.pushChannel];
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
    
    for (id<PThread> threadModel in [NM.core threadsWithType:bThreadTypePublicGroup]) {
        CCThreadWrapper * thread = [CCThreadWrapper threadWithModel:threadModel];
        [thread off];
    }
    
    for (id<PUserConnection> contact in [user connectionsWithType:bUserConnectionTypeContact]) {
        // Turn the contact on
        id<PUser> contactModel = contact.user;
        [[CCUserWrapper userWithModel:contactModel] off];
        [[CCUserWrapper userWithModel:contactModel] onlineOff];
    }

    if (NM.push && [NM.push respondsToSelector:@selector(unsubscribeToPushChannel:)]) {
        [NM.push unsubscribeToPushChannel:user.pushChannel];
    }
}

@end
