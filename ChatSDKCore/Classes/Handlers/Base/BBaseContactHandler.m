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
    return [NM.currentUser connectionsWithType:bUserConnectionTypeContact];
}

-(NSArray *) contactsWithType: (bUserConnectionType) type {
    return [NM.currentUser contactsWithType: type];
}

-(NSArray *) connectionsWithType: (bUserConnectionType) type {
    return [NM.currentUser connectionsWithType:type];
}

-(RXPromise *) addContact: (id<PUser>) contact withType: (bUserConnectionType) type {
    id<PUserConnection> connection = [[BStorageManager sharedManager].a fetchOrCreateEntityWithID:contact.entityID withType:bUserConnectionEntity];
    [connection setType:@(bUserConnectionTypeContact)];
    [connection setEntityID:contact.entityID];
    [NM.currentUser addConnection:connection];
    return [RXPromise resolveWithResult:Nil];
}

/**
 * @brief Remove a contact locally and on the server if necessary
 */
-(RXPromise *) deleteContact: (id<PUser>) user {
    // Clear down the old blocking list
    id<PUser> currentUser = NM.currentUser;
    
    NSPredicate * predicate;
    if (user && user.entityID) {
        predicate = [NSPredicate predicateWithFormat:@"type = %@ AND owner = %@ AND entityID = %@", @(bUserConnectionTypeContact), currentUser, user.entityID];
    }
    else {
        predicate = [NSPredicate predicateWithFormat:@"type = %@ AND owner = %@", @(bUserConnectionTypeContact), currentUser];
    }
    
    NSArray * entities = [[BStorageManager sharedManager].a fetchEntitiesWithName:bUserConnectionEntity withPredicate:predicate];
    [[BStorageManager sharedManager].a deleteEntities:entities];
    
    return [RXPromise resolveWithResult:Nil];
}

@end
