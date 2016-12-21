//
//  BBaseContactHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BBaseContactHandler.h"

#import <ChatSDK/ChatCore.h>

@implementation BBaseContactHandler

-(NSArray *) contacts {
    return [[BNetworkManager sharedManager].a.core.currentUserModel connectionsWithType:bUserConnectionTypeContact];
}

-(NSArray<PUser> *) contactsWithType: (bUserConnectionType) type {
    return [[BNetworkManager sharedManager].a.core.currentUserModel contactsWithType: type];
}

-(NSArray<PUserConnection> *) connectionsWithType: (bUserConnectionType) type {
    return [[BNetworkManager sharedManager].a.core.currentUserModel connectionsWithType:type];
}

-(RXPromise *) addContact: (id<PUser>) contact withType: (bUserConnectionType) type {
    id<PUserConnection> connection = [[BStorageManager sharedManager].a fetchOrCreateEntityWithID:contact.entityID withType:bUserConnectionEntity];
    [connection setType:@(bUserConnectionTypeContact)];
    [connection setEntityID:contact.entityID];
    [[BNetworkManager sharedManager].a.core.currentUserModel addConnection:connection];
    return [RXPromise resolveWithResult:Nil];
}

/**
 * @brief Remove a contact locally and on the server if necessary
 */
-(RXPromise *) deleteContact: (id<PUser>) user {
    // Clear down the old blocking list
    id<PUser> currentUser = [BNetworkManager sharedManager].a.core.currentUserModel;
    
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

-(RXPromise *) searchViewControllerForType: (bSearchType) type exclude: (NSArray *) users usersAdded: (void(^)(NSArray * users)) usersAdded {
    UIViewController * vc = Nil;
    if(type == bSearchTypeNameSearch) {
        vc = [[BInterfaceManager sharedManager].a searchViewControllerExcludingUsers:users usersAdded:usersAdded];
    }
    return [RXPromise resolveWithResult: vc];
}

@end
