//
//  BCoreDataManager.m
//  NekNominate
//
//  Created by Benjamin Smiley-andrews on 12/02/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "BCoreDataManager.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/CoreData.h>

static BCoreDataManager * manager;

@implementation BCoreDataManager

+(BCoreDataManager *) sharedManager {
    
	@synchronized(self) {
		
		// If the sharedSoundManager var is nil then we need to allocate it.
		if(manager == nil) {
			// Allocate and initialize an instance of this class
			manager = [[self alloc] init];
		}
	}
    return manager;
}

-(instancetype) init {
    if ((self = [super init])) {
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:Nil queue:0 usingBlock:^(NSNotification * notification) {
            [self saveToStore];
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification object:Nil queue:0 usingBlock:^(NSNotification * notification) {
            [self saveToStore];
        }];
    }
    return self;
}

-(void) saveToStore {
    [self saveWithPromise].thenOnMain(^id(id success) {
        [self.privateManagedObjectContext performBlock:^{
            @try {
                if (self.privateManagedObjectContext.hasChanges) {
                    NSError *error = nil;
                    if (![self.privateManagedObjectContext save:&error]) {
                        NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
                    }
                }
            }
            @catch (NSException * e) {
                NSLog(@"Error saving context: %@\n%@", [e name], [e description]);
            }
        }];
        return Nil;
    }, Nil);
}

-(RXPromise *) saveWithPromise {
    
    RXPromise * promise = [RXPromise new];
    
    [self.managedObjectContext performBlock:^{
        @try {
            if (self.managedObjectContext.hasChanges) {
                NSError *error = nil;
                if (![self.managedObjectContext save:&error]) {
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

-(void) save {
    [self saveWithPromise];
}

-(NSArray *) fetchEntitiesWithName: (NSString *) entityName {
    return [self fetchEntitiesWithName:entityName withPredicate:Nil];
}

-(RXPromise *) safeFetchEntitiesWithName: (NSString *) entityName {
    return [self safeFetchEntitiesWithName:entityName withPredicate:Nil];
}

-(RXPromise *) safeExecuteFetchRequest: (NSFetchRequest *) fetchRequest entityName: (NSString *) entityName predicate: (NSPredicate *) predicate {
    RXPromise * promise = [RXPromise new];
    [self.privateManagedObjectContext performBlock:^{
        [fetchRequest setIncludesPendingChanges:YES];
        
        NSEntityDescription * entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.privateManagedObjectContext];
        if (!entity) {
            [promise resolveWithResult: Nil];
        }
        
        [fetchRequest setEntity:entity];
        if (predicate != Nil) {
            [fetchRequest setPredicate:predicate];
        }
        
        NSError * error = Nil;
        NSArray * entities = [self.privateManagedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (error) {
            [promise rejectWithReason:error];
            NSLog(@"Fetch error: %@", error.localizedDescription);
        }
        
        [promise resolveWithResult:entities];
    }];
    return promise;
}

/**
 * @deprecated This method is not thread safe
 * @note plase use safeExecuteFetchRequest instead
 */
-(id) executeFetchRequest: (NSFetchRequest *) fetchRequest entityName: (NSString *) entityName predicate: (NSPredicate *) predicate {
    @synchronized(self.managedObjectContext) {
        [fetchRequest setIncludesPendingChanges:YES];

        NSEntityDescription * entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
        if (!entity) {
            return Nil;
        }
        
        [fetchRequest setEntity:entity];
        if (predicate != Nil) {
            [fetchRequest setPredicate:predicate];
        }
        
        NSError * error = Nil;
        NSArray * entities = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (error) {
            NSLog(@"Fetch error: %@", error.localizedDescription);
        }
        
        return entities;
    }
}

/**
 * @deprecated This method is not thread safe
 * @note plase use safeFetchEntitiesWithName instead
 */
-(NSArray *) fetchEntitiesWithName: (NSString *) entityName withPredicate: (NSPredicate *) predicate {
    return [self executeFetchRequest:[[NSFetchRequest alloc] init] entityName:entityName predicate:predicate];
}

-(RXPromise *) safeFetchEntitiesWithName: (NSString *) entityName withPredicate: (NSPredicate *) predicate {
    return [self safeExecuteFetchRequest:[NSFetchRequest new] entityName:entityName predicate:predicate];
}

-(id) fetchEntityWithID: (NSString *) entityID withType: (NSString *) type {
    @synchronized(self.managedObjectContext)  {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"entityID = %@", entityID];
        // Copy it to stop a mutation error
        NSArray * results = [[self fetchEntitiesWithName:type withPredicate:predicate] copy];
        for (id result in results) {
            return result;
        }
        return Nil;
    }
}

-(RXPromise *) safeFetchEntityWithID: (NSString *) entityID withType: (NSString *) type {
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"entityID = %@", entityID];
    return [self safeFetchEntitiesWithName:type withPredicate:predicate].then(^id(NSArray * items) {
        if (items.count) {
            return items.firstObject;
        }
        return Nil;
    }, Nil);
}

-(id) fetchOrCreateEntityWithID: (NSString *) entityID withType: (NSString *) type {
    @synchronized(self.managedObjectContext)  {
        id<PEntity> entity = [self fetchEntityWithID:entityID withType:type];
        if (!entity) {
            entity = [self createEntity:type];
        }
        if (entityID && [entity respondsToSelector:@selector(setEntityID:)]) {
            [((id<PEntity>) entity) setEntityID:entityID];
        }
        
        return entity;
    }
}

-(RXPromise *) safeFetchOrCreateEntityWithID: (NSString *) entityID withType: (NSString *) type {
    return [self safeFetchEntityWithID:entityID withType:type].then(^id(id<PEntity> entity) {
        if (!entity) {
            return [self safeCreateEntity:type];
        }
        return entity;
    }, Nil).then(^id(id<PEntity> entity) {
        if (entityID && [entity respondsToSelector:@selector(setEntityID:)]) {
            [((id<PEntity>) entity) setEntityID:entityID];
        }
        return entity;
    }, Nil);
}

-(id) fetchOrCreateEntityWithPredicate: (NSPredicate *) predicate withType: (NSString *) type {
    @synchronized(self.managedObjectContext)  {
        NSArray * entities = [self fetchEntitiesWithName:type withPredicate:predicate];
        if (entities.count) {
            return entities.firstObject;
        }
        else {
            return [self createEntity:type];
        }
    }
}

-(RXPromise *) safeFetchOrCreateEntityWithPredicate: (NSPredicate *) predicate withType: (NSString *) type {
    return [self safeFetchEntitiesWithName:type withPredicate:predicate].then(^id(NSArray * entities) {
        if (entities.count) {
            return entities.firstObject;
        }
        else {
            return [self safeCreateEntity:type];
        }
    }, Nil);
}


-(id) createEntity: (NSString *) entityName {
    @synchronized(self.managedObjectContext)  {
        if ([entityName isEqualToString:bUserEntity]) {
            NSLog(@"Creating: %@", entityName);
        }
        
        id entity = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                             inManagedObjectContext:self.managedObjectContext];
        return entity;
    }
}

-(RXPromise *) safeCreateEntity: (NSString *) entityName {
    RXPromise * promise = [RXPromise new];
    [self.privateManagedObjectContext performBlock:^{
        id entity = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                  inManagedObjectContext:self.privateManagedObjectContext];
        [promise resolveWithResult:entity];
    }];
    return promise;
}

- (NSManagedObjectContext *) privateManagedObjectContext {
    
    if (!_privateMoc) {
        _privateMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _privateMoc.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    
    return _privateMoc;
}

- (NSManagedObjectContext *) managedObjectContext {

    if (!_moc) {
        _moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _moc.parentContext = self.privateManagedObjectContext;
        
        NSUndoManager *undoManager = [[NSUndoManager alloc] init];
        [_moc setUndoManager:undoManager];
    }
    return _moc;
}

-(void) beginUndoGroup {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.managedObjectContext.undoManager beginUndoGrouping];
    });
}

-(RXPromise *) safeBeginUndoGroup {
    RXPromise * promise = [RXPromise new];
    [self.privateManagedObjectContext performBlock:^{
        [self.managedObjectContext.undoManager beginUndoGrouping];
        [promise resolveWithResult:Nil];
    }];
    return promise;
}

-(void) endUndoGroup {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.managedObjectContext.undoManager endUndoGrouping];
    });
}

-(RXPromise *) safeEndUndoGroup {
    RXPromise * promise = [RXPromise new];
    [self.privateManagedObjectContext performBlock:^{
        [self.managedObjectContext.undoManager endUndoGrouping];
        [promise resolveWithResult:Nil];
    }];
    return promise;
}

-(void) undo {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.managedObjectContext.undoManager undo];
    });
}

-(RXPromise *) safeUndo {
    RXPromise * promise = [RXPromise new];
    [self.privateManagedObjectContext performBlock:^{
        [self.managedObjectContext.undoManager undo];
        [promise resolveWithResult:Nil];
    }];
    return promise;
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
    @synchronized(self.managedObjectContext)  {
        return [self createEntity:bMessageEntity];
    }
}

-(id<PMessage>) safeCreateMessageEntity {
    return [self safeCreateEntity:bMessageEntity];
}

-(NSArray *) fetchEntitiesWithTypes: (NSArray *) types {
    NSMutableArray * entities = [NSMutableArray new];
    for (NSString * type in types) {
        [entities addObjectsFromArray:[self fetchEntitiesWithName:type]];
    }
}

// Check this
-(RXPromise *) safeFetchEntitiesWithTypes: (NSArray *) types {
    NSMutableArray * promises = [NSMutableArray new];
    for(NSString * type in types) {
        [promises addObject:[self safeFetchEntitiesWithName:type]];
    }
    return [RXPromise all:promises];
}

-(void) deleteEntitiesWithType: (NSString *) type {
    NSArray * entities = [self fetchEntitiesWithTypes:@[type]];
    for (id entity in entities) {
        [self deleteEntity: entity];
    }
}

-(RXPromise *) safeDeleteEntitiesWithType: (NSString *) type {
    return [self safeDeleteEntitiesWithTypes:@[type]];
}

-(RXPromise *) safeDeleteEntities: (NSArray *) entities {
    RXPromise * promise = [RXPromise new];
    [self.privateManagedObjectContext performBlock:^{
        for(id entity in entities) {
            [self.privateManagedObjectContext deleteObject:entity];
        }
        [promise resolveWithResult:Nil];
    }];
    
}

-(RXPromise *) safeDeleteEntitiesWithTypes: (NSArray *) types {
    NSMutableArray * promises = [NSMutableArray new];
    for(NSString * type in types) {
        [promises addObject:[self safeFetchEntitiesWithName:type].then(^id(NSArray * entities) {
            return [self safeDeleteEntities: entities];
        }, Nil)];
    }
    return promises;
}

-(void) deleteEntities: (NSArray *) entities {
    @synchronized(self.managedObjectContext)  {
        [self getEntitiesOnMainThread:entities].thenOnMain(^id(NSArray * safeEntities) {
            for(NSManagedObject * entity in safeEntities) {
                [self unsafeDeleteEntity:entity];
            }
            return Nil;
        }, Nil);
    }
}

-(void) unsafeDeleteEntity: (id) entity {
    @synchronized(self.managedObjectContext)  {
        if (entity) {
            [self.managedObjectContext deleteObject:entity];
        }
    }
}

-(void) deleteEntity: (id) entity {
    @synchronized(self.managedObjectContext)  {
        [self deleteEntities:@[entity]];
    }
}


-(RXPromise *) getEntitiesOnMainThread: (NSArray *) entities {
    RXPromise * promise = [RXPromise new];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray * safeEntities = [NSMutableArray new];
        for(id entity in entities) {
            if ([entities isKindOfClass:NSManagedObject.class]) {
                NSManagedObject * safeEntity = [self.managedObjectContext objectWithID:((NSManagedObject *)entity).objectID];
                if (safeEntity) {
                    [safeEntities addObject:safeEntity];
                }
            }
        }
        [promise resolveWithResult:safeEntities];
    });
    return promise;
}

-(void) deleteAllData {
    @synchronized(self.managedObjectContext)  {
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
}

-(RXPromise *) safeDeleteAllData {
    return [self safeDeleteEntitiesWithTypes:@[bUserEntity,
                                               bUserConnectionEntity,
                                               bMessageEntity,
                                               bThreadEntity,
                                               bUserAccountEntity,
                                               bMetaDataEntity]];
}


-(id<PThread>) createThreadEntity {
    @synchronized(self.managedObjectContext)  {
        return [self createEntity:bThreadEntity];
    }
}

-(id<PThread>) safeCreateThreadEntity {
    return [self safeCreateEntity:bThreadEntity];
}

-(id<PThread>) fetchThreadWithUsers: (NSArray *) users {
    @synchronized(self.managedObjectContext)  {
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
}

@end
