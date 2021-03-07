//
//  BBaseContactHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BBaseContactHandler.h"

#import <ChatSDK/Core.h>

@implementation BBaseContactHandler

-(NSArray *) contacts {
    return [BChatSDK.currentUser connectionsWithType:bUserConnectionTypeContact];
}

-(NSArray *) contactsWithType: (bUserConnectionType) type {
    return [BChatSDK.currentUser contactsWithType: type];
}

-(NSArray *) connectionsWithType: (bUserConnectionType) type {
    return [BChatSDK.currentUser connectionsWithType:type];
}

-(RXPromise *) addContact: (id<PUser>) contact withType: (bUserConnectionType) type {
    return [self addLocalContact:contact withType:type];
}

-(RXPromise *) addLocalContact: (id<PUser>) contact withType: (bUserConnectionType) type {

    [BHookNotification notificationContactWillBeAdded:contact];
    
    RXPromise * promise = [RXPromise new];
    [BChatSDK.db performOnMain:^{
        id<PUserConnection> connection = [BChatSDK.db fetchOrCreateUserConnectionWithID:contact.entityID withType:bUserConnectionTypeContact];
        
        id<PUser> currentUser = [BChatSDK.db fetchOrCreateEntityWithID:BChatSDK.auth.currentUserID withType:bUserEntity];
        [currentUser addConnection:connection];
        [BChatSDK.core observeUser:contact.entityID];
        [BHookNotification notificationContactWasAdded:contact];
        [promise resolveWithResult:nil];
    }];
//    [BChatSDK.db performOnMainAndSave:^{
//        id<PUserConnection> connection = [BChatSDK.db fetchOrCreateUserConnectionWithID:contact.entityID withType:bUserConnectionTypeContact];
//
//        id<PUser> currentUser = [BChatSDK.db fetchOrCreateEntityWithID:BChatSDK.auth.currentUserID withType:bUserEntity];
//        [currentUser addConnection:connection];
//    } finally:^{
//        [BChatSDK.core observeUser:contact.entityID];
//        [BHookNotification notificationContactWasAdded:contact];
//        [promise resolveWithResult:nil];
//    }];
    return promise;
}

/**
 * @brief Remove a contact locally and on the server if necessary
 */
-(RXPromise *) deleteContact: (id<PUser>) user withType: (bUserConnectionType) type {
    return [self deleteLocalContact:user withType:type];
}

-(RXPromise *) deleteLocalContact: (id<PUser>) user withType: (bUserConnectionType) type {
    
    [BHookNotification notificationContactWillBeDeleted:user];
    
    RXPromise * promise = [RXPromise new];
    [BChatSDK.db performOnMain:^{
        NSArray * connections = [BChatSDK.db fetchUserConnectionsWithType:type entityID:user ? user.entityID : Nil];
        id<PUser> currentUser = [BChatSDK.db fetchOrCreateEntityWithID:BChatSDK.auth.currentUserID withType:bUserEntity];

        for (id<PUserConnection> connection in connections) {
            [currentUser removeConnection:connection];
        }
        
        [BChatSDK.db deleteEntities:connections];
        [BHookNotification notificationContactWasDeleted:user];
        [promise resolveWithResult:nil];
    }];

//    [BChatSDK.db performOnMainAndSave:^{
//        // Clear down the old blocking list
//        NSArray * connections = [BChatSDK.db fetchUserConnectionsWithType:type entityID:user ? user.entityID : Nil];
//        id<PUser> currentUser = [BChatSDK.db fetchOrCreateEntityWithID:BChatSDK.auth.currentUserID withType:bUserEntity];
//
//        for (id<PUserConnection> connection in connections) {
//            [currentUser removeConnection:connection];
//        }
//
//        [BChatSDK.db deleteEntities:connections];
//    } finally:^{
//        [BHookNotification notificationContactWasDeleted:user];
//        [promise resolveWithResult:nil];
//    }];

    return promise;
}

@end
