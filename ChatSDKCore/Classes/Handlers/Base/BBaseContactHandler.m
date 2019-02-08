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

    id<PUserConnection> connection = [BChatSDK.db fetchOrCreateEntityWithID:contact.entityID withType:bUserConnectionEntity];
    [connection setType:@(bUserConnectionTypeContact)];
    [connection setEntityID:contact.entityID];
    [BChatSDK.currentUser addConnection:connection];
    
    return [BChatSDK.db save].thenOnMain(^id(id success) {
        [BChatSDK.core observeUser:contact.entityID];
        [BHookNotification notificationContactWasAdded:contact];
        return Nil;
    }, Nil);
}

/**
 * @brief Remove a contact locally and on the server if necessary
 */
-(RXPromise *) deleteContact: (id<PUser>) user withType: (bUserConnectionType) type {
    return [self deleteLocalContact:user withType:type];
}

-(RXPromise *) deleteLocalContact: (id<PUser>) user withType: (bUserConnectionType) type {
    
    [BHookNotification notificationContactWillBeDeleted:user];
    
    // Clear down the old blocking list
    NSArray * connections = [BChatSDK.db fetchUserConnectionsWithType:type entityID:user ? user.entityID : Nil];
    
    for (id<PUserConnection> connection in connections) {
        [BChatSDK.currentUser removeConnection:connection];
    }
    
    [BChatSDK.db deleteEntities:connections];
    
    return [BChatSDK.db save].thenOnMain(^id(id success) {
        [BHookNotification notificationContactWasDeleted:user];
        return Nil;
    }, Nil);
}

@end
