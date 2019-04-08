//
//  PStorageAdapter.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 25/11/2015.
//
//

#ifndef PStorageAdapter_h
#define PStorageAdapter_h

#import "PMessage.h"
#import "PThread_.h"

#define bUserEntity @"CDUser"
#define bMessageEntity @"CDMessage"
#define bThreadEntity @"CDThread"
#define bUserAccountEntity @"CDUserAccount"
#define bMetaDataEntity @"CDMetaData"
#define bUserConnectionEntity @"CDUserConnection"
#define bGroupEntity @"CDGroup"

@class BMessageDef;
@class BThreadDef;
@class NSFetchRequest;

typedef enum {
    bQueueTypeMain,
    bQueueTypeBackground,
} bQueueType;

@protocol PStorageAdapter <NSObject>

-(NSArray *) fetchEntitiesWithName: (NSString *) entityName withPredicate: (NSPredicate *) predicate;
-(NSArray *) fetchEntitiesWithName: (NSString *) entityName;
-(id) fetchEntityWithID: (NSString *) entityID withType: (NSString *) type;
-(id) fetchOrCreateEntityWithID: (NSString *) entityID withType: (NSString *) type;
-(id) fetchOrCreateEntityWithPredicate: (NSPredicate *) predicate withType: (NSString *) type;
-(id<PThread>) fetchThreadWithUsers: (NSArray *) users;
-(id) executeFetchRequest: (NSFetchRequest *) fetchRequest entityName: (NSString *) entityName predicate: (NSPredicate *) predicate;

-(id<PMessage>) createMessageEntity;
-(id<PThread>) createThreadEntity;

-(RXPromise *) save;
-(void) saveToStore;

-(id) createEntity: (NSString *) entityName;

-(void) beginUndoGroup;
-(void) endUndoGroup;
-(void) undo;

-(void) deleteEntity: (id) entity;
-(void) deleteEntitiesWithType: (NSString *) type;
-(void) deleteEntities: (NSArray *) entities;
-(void) deleteAllData;

-(id<PThread>) threadForEntityID: (NSString *) entityID;
-(id<PUser>) userForEntityID: (NSString *) entityID;
-(id<PMessage>) messageForEntityID: (NSString *) entityID;

-(NSArray *) fetchUserConnectionsWithType: (bUserConnectionType) type entityID: (NSString *) entityID;
-(NSArray *) fetchUserConnectionsWithType: (bUserConnectionType) type;

-(RXPromise *) performOnPrivate: (id (^)(void)) block;
-(RXPromise *) performOnMain: (id (^)(void)) block;
-(bQueueType) queueType;


@end

#endif /* PStorageAdapter_h */
