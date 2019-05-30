//
//  BCoreDataStorageAdapter.m
//  NekNominate
//
//  Created by Benjamin Smiley-andrews on 12/02/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "BCoreDataStorageAdapter.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/CoreData.h>

static BCoreDataStorageAdapter * manager;

static void * kMainQueueKey = (void *) "Key1";

@implementation BCoreDataStorageAdapter

-(instancetype) init {
    if ((self = [super init])) {
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:Nil queue:0 usingBlock:^(NSNotification * notification) {
            [self saveToStore];
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification object:Nil queue:0 usingBlock:^(NSNotification * notification) {
            [self saveToStore];
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:Nil queue:0 usingBlock:^(NSNotification * notification) {
            [self privateQueueObjectContextDidSaveNotification:notification];
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextObjectsDidChangeNotification object:Nil queue:0 usingBlock:^(NSNotification * notification) {
            [self privateQueueObjectContextDidChangeNotification:notification];
        }];
        
    }
    
    dispatch_queue_set_specific(dispatch_get_main_queue(), kMainQueueKey, kMainQueueKey, Nil);
    
    return self;
}

-(void) saveToStore {
    [self saveWithPromise].then(^id(id success) {
        return [self save:_privateMoc];
    }, Nil);
}

-(RXPromise *) saveWithPromise {
    return [RXPromise all:@[[self save:_moc], [self save:_backgrondMoc]]];
}

-(RXPromise *) save: (NSManagedObjectContext *) context {
    RXPromise * promise = [RXPromise new];
    
    [context performBlock:^{
        @try {
            if (context.hasChanges) {
                NSError *error = nil;
                if (![context save:&error]) {
                    NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
                    [promise rejectWithReason:error];
                    return;
                }
            }
            [promise resolveWithResult:Nil];
        }
        @catch (NSException * e) {
            NSLog(@"Error saving context: %@\n%@", [e name], [e description]);
            [promise rejectWithReason:e];
        }
    }];
    return promise;
}

-(RXPromise *) save {
    return [self saveWithPromise];
}

-(NSArray *) fetchEntitiesWithName: (NSString *) entityName {
    return [self fetchEntitiesWithName:entityName withPredicate:Nil];
}

-(id) executeFetchRequest: (NSFetchRequest *) fetchRequest entityName: (NSString *) entityName predicate: (NSPredicate *) predicate {
    [fetchRequest setIncludesPendingChanges:YES];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContextForThread];
    if (!entity) {
        return Nil;
    }
    
    [fetchRequest setEntity:entity];
    if (predicate != Nil) {
        [fetchRequest setPredicate:predicate];
    }
    
    NSError * error = Nil;
    NSArray * entities = [self.managedObjectContextForThread executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Fetch error: %@", error.localizedDescription);
    }
    return entities;
    
}

-(NSArray *) fetchUserConnectionsWithType: (bUserConnectionType) type {
    return [self fetchUserConnectionsWithType:type entityID:Nil];
}

-(NSArray *) fetchUserConnectionsWithType: (bUserConnectionType) type entityID: (nullable NSString *) entityID {
    id<PUser> currentUser = BChatSDK.currentUser;

    NSPredicate * predicate;
    if (entityID) {
        predicate = [NSPredicate predicateWithFormat:@"type = %@ AND owner = %@ AND entityID = %@", @(type), currentUser, entityID];
    }
    else {
        predicate = [NSPredicate predicateWithFormat:@"type = %@ AND owner = %@", @(type), currentUser];
    }

    return [BChatSDK.db fetchEntitiesWithName:bUserConnectionEntity withPredicate:predicate];
}

-(NSArray *) fetchEntitiesWithName: (NSString *) entityName withPredicate: (NSPredicate *) predicate {
    return [self executeFetchRequest:[[NSFetchRequest alloc] init] entityName:entityName predicate:predicate];
}

-(id) fetchEntityWithID: (NSString *) entityID withType: (NSString *) type {
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"entityID = %@", entityID];
    // Copy it to stop a mutation error
    NSArray * results = [[self fetchEntitiesWithName:type withPredicate:predicate] copy];
    for (id result in results) {
        return result;
    }
    return Nil;
}

-(RXPromise *) performOnPrivate: (id (^)(void))block  {
    return [self performOn:self.backgroundManagedObjectContext withBlock:block];
}

-(RXPromise *) performOnMain: (id(^)(void)) block  {
    return [self performOn:self.managedObjectContext withBlock:block];
}

-(RXPromise *) performOn: (NSManagedObjectContext *) context withBlock: (id(^)(void)) block {
    RXPromise * promise = [RXPromise new];
    [context performBlock:^{
        id result = block();
        if(context.hasChanges) {
            NSError * error;
            [context save:&error];
            if(error) {
                NSLog(@"Error %@", error.localizedDescription);
            }
        }
        [promise resolveWithResult:result];
    }];
    return promise;
}

-(id) fetchOrCreateEntityWithID: (NSString *) entityID withType: (NSString *) type {
    id<PEntity> entity = [self fetchEntityWithID:entityID withType:type];
    if (!entity) {
        entity = [self createEntity:type];
    }
    if (entityID && [entity respondsToSelector:@selector(setEntityID:)]) {
        [((id<PEntity>) entity) setEntityID:entityID];
    }
    
    return entity;
}

-(id) fetchOrCreateEntityWithPredicate: (NSPredicate *) predicate withType: (NSString *) type {
    NSArray * entities = [self fetchEntitiesWithName:type withPredicate:predicate];
    if (entities.count) {
        return entities.firstObject;
    }
    else {
        return [self createEntity:type];
    }
}

-(id) createEntity: (NSString *) entityName {
    if ([entityName isEqualToString:bUserEntity]) {
        NSLog(@"Creating: %@", entityName);
    }
    
    id entity = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                              inManagedObjectContext:self.managedObjectContextForThread];
    return entity;
}

-(bQueueType) queueType {
    return dispatch_get_specific(kMainQueueKey) ? bQueueTypeMain : bQueueTypeBackground;
}

-(NSManagedObjectContext *) managedObjectContextForThread {
//    assert(dispatch_get_specific(kMainQueueKey));
//    if (dispatch_get_specific(kMainQueueKey)) {
        return self.managedObjectContext;
//    }
//    else {
//        NSLog(@"managed object context: %@", [NSThread currentThread]);
//        return self.backgroundManagedObjectContext;
//    }
}

- (NSManagedObjectContext *) privateManagedObjectContext {
    
    if (!_privateMoc) {
        _privateMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _privateMoc.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    
    return _privateMoc;
}

- (NSManagedObjectContext *) backgroundManagedObjectContext {
    
    if (!_backgrondMoc) {
        _backgrondMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _backgrondMoc.parentContext = self.managedObjectContext;
        
        NSUndoManager *undoManager = [[NSUndoManager alloc] init];
        [_backgrondMoc setUndoManager:undoManager];
        [_backgrondMoc setAutomaticallyMergesChangesFromParent:YES];
    }
    
    return _backgrondMoc;
}

- (NSManagedObjectContext *) managedObjectContext {
    
    if (!_moc) {
        _moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _moc.parentContext = self.privateManagedObjectContext;
        NSUndoManager *undoManager = [[NSUndoManager alloc] init];
        [_moc setUndoManager:undoManager];
        //        [_moc setAutomaticallyMergesChangesFromParent:YES];
    }
    return _moc;
}

-(void) beginUndoGroup {
    [self.managedObjectContextForThread.undoManager beginUndoGrouping];
}

-(id<PThread>) threadForEntityID: (NSString *) entityID {
    return [self fetchEntityWithID:entityID withType:bThreadEntity];
}

-(id<PUser>) userForEntityID: (NSString *) entityID {
    return [self fetchEntityWithID:entityID withType:bUserEntity];
}

-(id<PMessage>) messageForEntityID: (NSString *) entityID {
    return [self fetchEntityWithID:entityID withType:bMessageEntity];
}


-(void) undo {
    [self.managedObjectContextForThread.undoManager undo];
}

- (NSManagedObjectModel *)managedObjectModel {
    
    if (!_model) {
        NSBundle * bundle = [NSBundle bundleWithName:bCoreDataBundle];
        
        NSString * path = [bundle pathForResource:@"ChatSDK" ofType:@"momd"];
        NSURL * momURL = [NSURL fileURLWithPath:path];
        _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
        
    }
    
    return _model;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_store) {
        NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                                   stringByAppendingPathComponent: @"ChatSDK.sqlite"]];
        
        NSError *error = nil;
        _store = [[NSPersistentStoreCoordinator alloc]
                  initWithManagedObjectModel:[self managedObjectModel]];
        
        NSDictionary * options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
        
        if(![_store addPersistentStoreWithType:NSSQLiteStoreType
                                 configuration:nil URL:storeUrl options:options error:&error]) {
            NSLog(@"Error setting up database: %@", error.localizedDescription);
        }
    }
    
    return _store;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

-(id<PMessage>) createMessageEntity {
    return [self createEntity:bMessageEntity];
}

-(void) endUndoGroup {
    [self.managedObjectContextForThread.undoManager endUndoGrouping];
}

-(NSArray *) fetchEntitiesWithTypes: (NSArray *) types {
    NSMutableArray * entities = [NSMutableArray new];
    for (NSString * type in types) {
        [entities addObjectsFromArray:[self fetchEntitiesWithName:type]];
    }
    return entities;
}

-(void) deleteEntitiesWithType: (NSString *) type {
    NSArray * entities = [self fetchEntitiesWithTypes:@[type]];
    for (id entity in entities) {
        [self deleteEntity: entity];
    }
}

-(void) deleteEntities: (NSArray *) entities {
    for(NSManagedObject * entity in entities) {
        [self deleteEntity:entity];
    }
}

-(void) deleteEntity: (id) entity {
    [self.managedObjectContextForThread deleteObject:entity];
}

-(void) deleteAllData {
    NSArray * entities = [self fetchEntitiesWithTypes:@[bUserEntity,
                                                        bUserConnectionEntity,
                                                        bMessageEntity,
                                                        bThreadEntity,
                                                        bUserAccountEntity,
                                                        bMetaDataEntity]];
    for (NSManagedObject * entity in entities) {
        [self deleteEntity:entity];
    }
}

-(id<PThread>) createThreadEntity {
    return [self createEntity:bThreadEntity];
}

-(id<PThread>) fetchThreadWithUsers: (NSArray *) users {
    NSMutableArray * allUsers = [NSMutableArray arrayWithArray:users];
    
    id<PUser> currentUser = BChatSDK.currentUser;
    if (![allUsers containsObject:currentUser]) {
        [allUsers addObject:currentUser];
    }
    
    for (id<PThread> thread in currentUser.threads) {
        if (thread.users.count == allUsers.count) {
            if ([thread.users isEqualToSet:[NSSet setWithArray:allUsers]]) {
                return thread;
            }
        }
    }
    return Nil;
}

-(NSArray<PMessage> *) loadMessagesForThread: (id<PThread>) thread fromDate: (NSDate *) date count: (int) count {
    return [self loadMessagesForThread:thread fromDate:date count:count newestFirst:YES];
}

-(NSArray<PMessage> *) loadAllMessagesForThread: (id<PThread>) thread newestFirst: (BOOL) newestFirst {
    return [self loadMessagesForThread:thread fromDate:Nil count:0 newestFirst:newestFirst];
}

-(NSArray<PMessage> *) loadMessagesForThread: (id<PThread>) thread newest: (int) count {
    return [self loadMessagesForThread:thread fromDate:Nil count:count newestFirst:YES];
}

-(NSArray<PMessage> *) loadMessagesForThread: (id<PThread>) thread oldest: (int) count {
    return [self loadMessagesForThread:thread fromDate:Nil count:count newestFirst:NO];
}

-(NSArray<PMessage> *) loadMessagesForThread: (id<PThread>) thread fromDate: (NSDate *) date count: (int) count newestFirst: (BOOL) newestFirst {
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    request.includesPendingChanges = YES;
    if (count > 0) {
        [request setFetchLimit:count];
    } else if (count < 0) {
        [request setFetchLimit:BChatSDK.config.messagesToLoadPerBatch];
    }
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:!newestFirst]];

    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"thread = %@", thread];
    if (date) {
        predicate = [NSPredicate predicateWithFormat:@"thread = %@ AND date < %@", thread, date];
    }
    
    NSArray * messages = [BChatSDK.db executeFetchRequest:request
                                               entityName:bMessageEntity
                                                predicate:predicate];
    
    return messages;
}

/// https://stackoverflow.com/questions/36338135/nsmanagedobjectcontext-how-to-update-child-when-parent-changes
/// I need this firing as sometimes objects change and the save notification below is not enough to make sure the UI updates.
- (void)privateQueueObjectContextDidChangeNotification:(NSNotification *)notification {
    NSManagedObjectContext * context = notification.object;
    
    NSManagedObjectContext * parent = self.privateManagedObjectContext;
    NSManagedObjectContext * background = self.backgroundManagedObjectContext;
    NSManagedObjectContext * main = self.managedObjectContext;

    if([context isEqual:parent]) {
//        NSLog(@"Parent");
    }
    else if([context isEqual:background]) {
//        NSLog(@"Background");
    }
    else if([context isEqual:main]) {
//        NSLog(@"Main");
    }
    else {
//        NSLog(@"None");
    }
    
    id updated = notification.userInfo[@"updated"];
    if ([updated isKindOfClass:[NSSet class]]) {
        for (id entity in (NSSet *) updated) {
            [self handleUpdatedEntity:entity];
        }
    } else {
        [self handleUpdatedEntity:updated];
    }

    
    //    if ([context isEqual:parent]) {
    //        //Collect the objectIDs of the objects that changed
    //        __block NSMutableSet *objectIDs = [NSMutableSet set];
    //        [context performBlockAndWait:^{
    //            NSDictionary *userInfo = notification.userInfo;
    //            for (NSManagedObject *changedObject in userInfo[NSUpdatedObjectsKey]) {
    //                [objectIDs addObject:changedObject.objectID];
    //            }
    //            for (NSManagedObject *changedObject in userInfo[NSInsertedObjectsKey]) {
    //                [objectIDs addObject:changedObject.objectID];
    //            }
    //            for (NSManagedObject *changedObject in userInfo[NSDeletedObjectsKey]) {
    //                [objectIDs addObject:changedObject.objectID];
    //            }
    //        }];
    //
    //        //Refresh the changed objects
    //        [background performBlock:^{
    //            for (NSManagedObjectID *objectID in objectIDs) {
    //                NSManagedObject *object = [background existingObjectWithID:objectID error:nil];
    //                if (object) {
    //                    [background refreshObject:object mergeChanges:YES];
    //                    //NSLog(@"refreshing %@", [object description]);
    //                }
    //            }
    //        }];
    //        [main performBlock:^{
    //            for (NSManagedObjectID *objectID in objectIDs) {
    //                NSManagedObject *object = [main existingObjectWithID:objectID error:nil];
    //                if (object) {
    //                    [main refreshObject:object mergeChanges:YES];
    //                    //NSLog(@"refreshing %@", [object description]);
    //                }
    //            }
    //        }];
    //    }
}

-(void) handleUpdatedEntity: (id) updated {
    if ([updated isKindOfClass:[CDUser class]]) {
        CDUser * user = (CDUser *) updated;
//        NSLog(@"User: %@ %@ updated", user.entityID, user.name);
    }
    if ([updated isKindOfClass:[CDThread class]]) {
        CDThread * thread = (CDThread *) updated;
//        NSLog(@"Thread: %@ updated", thread.entityID);
    }
    if ([updated isKindOfClass:[CDMessage class]]) {
        CDMessage * message = (CDMessage *) updated;
//        NSLog(@"Message: %@ %@ updated", message.entityID, message.text);
    }
}

- (void)privateQueueObjectContextDidSaveNotification:(NSNotification *)notification {
    //NSLog(@"private Q MOC has saved");
    //    [self.mainQueueObjectContext performBlock:^{
    //        [self.mainQueueObjectContext mergeChangesFromContextDidSaveNotification:notification];
    //        // I had UI update problems which I fixed with mergeChangesFromContextDidSaveNotification along with obtainPermanentIDsForObjects: in the insertEntity call.
    //    }];
}

@end
