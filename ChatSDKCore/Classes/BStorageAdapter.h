//
//  BStorageAdapter.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 25/11/2015.
//
//

#ifndef BStorageAdapter_h
#define BStorageAdapter_h

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

@protocol BStorageAdapter <NSObject>

-(NSArray *) fetchEntitiesWithName: (NSString *) entityName withPredicate: (NSPredicate *) predicate;
-(NSArray *) fetchEntitiesWithName: (NSString *) entityName;
-(id) fetchEntityWithID: (NSString *) entityID withType: (NSString *) type;
-(id) fetchOrCreateEntityWithID: (NSString *) entityID withType: (NSString *) type;
-(id) fetchOrCreateEntityWithPredicate: (NSPredicate *) predicate withType: (NSString *) type;
-(id<PThread>) fetchThreadWithUsers: (NSArray *) users;
-(id) executeFetchRequest: (NSFetchRequest *) fetchRequest entityName: (NSString *) entityName predicate: (NSPredicate *) predicate;

-(id<PMessage>) createMessageEntity;
-(id<PThread>) createThreadEntity;

-(void) save;
-(void) saveToStore;

-(id) createEntity: (NSString *) entityName;

-(void) beginUndoGroup;
-(void) endUndoGroup;
-(void) undo;

-(void) deleteEntity: (id) entity;
-(void) deleteEntitiesWithType: (NSString *) type;
-(void) deleteEntities: (NSArray *) entities;
-(void) deleteAllData;

-(id<PMessage>) messageForEntityID: (NSString *) entityID;
-(id<PUser>) userForEntityID: (NSString *) entityID;
-(id<PThread>) threadForEntityID: (NSString *) entityID;

//
//-(RXPromise *) safeFetchEntitiesWithName: (NSString *) entityName withPredicate: (NSPredicate *) predicate;
//-(RXPromise *) safeFetchEntitiesWithName: (NSString *) entityName;
//-(RXPromise *) safeFetchEntityWithID: (NSString *) entityID withType: (NSString *) type;
//-(RXPromise *) safeFetchOrCreateEntityWithID: (NSString *) entityID withType: (NSString *) type;
//-(RXPromise *) safeFetchOrCreateEntityWithPredicate: (NSPredicate *) predicate withType: (NSString *) type;
//-(RXPromise *) safeFetchThreadWithUsers: (NSArray *) users;
//-(RXPromise *) safeExecuteFetchRequest: (NSFetchRequest *) fetchRequest entityName: (NSString *) entityName predicate: (NSPredicate *) predicate;
//
//-(RXPromise *) safeCreateMessageEntity;
//-(RXPromise *) safeCreateThreadEntity;
//
//-(RXPromise *) safeCreateEntity: (NSString *) entityName;
//
//-(RXPromise *) safeBeginUndoGroup;
//-(RXPromise *) safeEndUndoGroup;
//-(RXPromise *) safeUndo;
//
//-(RXPromise *) safeDeleteEntity: (id) entity;
//-(RXPromise *) safeDeleteEntitiesWithType: (NSString *) type;
//-(RXPromise *) safeDeleteEntities: (NSArray *) entities;
//-(RXPromise *) safeDeleteAllData;

-(RXPromise *) performOnPrivate: (id (^)(void)) block;
-(RXPromise *) performOnMain: (id (^)(void)) block;
-(bQueueType) queueType;

@end

#endif /* BStorageAdapter_h */
