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

@class NSFetchRequest;

typedef void(^CompletionArray)(NSArray *);
typedef void(^Completion)(void);
typedef void(^CompletionInt)(int);

@protocol PStorageAdapter <NSObject>

-(NSArray *) fetchEntitiesWithName: (NSString *) entityName withPredicate: (NSPredicate *) predicate;
-(NSArray *) fetchEntitiesWithName: (NSString *) entityName;
-(id) fetchEntityWithID: (NSString *) entityID withType: (NSString *) type;
-(id) fetchOrCreateEntityWithID: (NSString *) entityID withType: (NSString *) type;
-(id) fetchOrCreateEntityWithPredicate: (NSPredicate *) predicate withType: (NSString *) type;
-(NSUInteger) fetchEntityCountWithID: (NSString *) entityID withType: (NSString *) type;
-(BOOL) entityExistsWithID: (NSString *) entityID withType: (NSString *) type;

-(id) fetchOrCreateUserConnectionWithID: (NSString *) entityID withType: (bUserConnectionType) type;

-(id<PThread>) fetchThreadWithUsers: (NSArray *) users;
-(id) executeFetchRequest: (NSFetchRequest *) fetchRequest entityName: (NSString *) entityName predicate: (NSPredicate *) predicate;

-(int) unreadMessagesCountNow: (NSString *) threadEntityID;

-(RXPromise *) privateThreadUnreadMessageCount;
-(RXPromise *) publicThreadUnreadMessageCount;
-(RXPromise *) unreadMessagesCount: (NSString *) threadEntityID;

-(void) threadsWithType: (bThreadType) type then: (CompletionArray) completion;
-(NSArray *) threadsWithType: (bThreadType) type;

-(void) unreadMessages: (NSString *) threadEntityID then: (CompletionArray) completion;

-(id<PMessage>) createMessageEntity;
-(id<PThread>) createThreadEntity;


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

-(NSArray<PMessage> *) loadMessagesForThread: (id<PThread>) thread fromDate: (NSDate *) date count: (int) count newestFirst: (BOOL) newestFirst;
-(NSArray<PMessage> *) loadAllMessagesForThread: (id<PThread>) thread newestFirst: (BOOL) newestFirst;
-(NSArray<PMessage> *) loadMessagesForThread: (id<PThread>) thread fromDate: (NSDate *) date count: (int) count;
-(NSArray<PMessage> *) loadMessagesForThread: (id<PThread>) thread newest: (int) count;
-(NSArray<PMessage> *) loadMessagesForThread: (id<PThread>) thread oldest: (int) count;

-(void) performOnMain: (Completion) block;
-(void) performOnMainAndWait:(Completion) block;
-(void) saveFinally: (Completion) completion;

-(void) performOnMainAndSave:(Completion)beforeSave finally: (Completion) afterSave;
-(void) save;
-(void) saveBackground;


@end

#endif /* PStorageAdapter_h */
