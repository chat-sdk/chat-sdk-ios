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
    id<PUserConnection> connection = [BChatSDK.db fetchOrCreateEntityWithID:contact.entityID withType:bUserConnectionEntity];
    [connection setType:@(bUserConnectionTypeContact)];
    [connection setEntityID:contact.entityID];
    [BChatSDK.currentUser addConnection:connection];
    return [RXPromise resolveWithResult:Nil];
}

/**
 * @brief Remove a contact locally and on the server if necessary
 */
-(RXPromise *) deleteContact: (id<PUser>) user {
    // Clear down the old blocking list
    id<PUser> currentUser = BChatSDK.currentUser;
    NSArray * entities = [BChatSDK.db fetchUserConnectionsWithType:bUserConnectionTypeContact entityID:user ? user.entityID : Nil];
    
    [BChatSDK.db deleteEntities:entities];
    
    return [RXPromise resolveWithResult:Nil];
}

@end
