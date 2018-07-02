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

//@synthesize managedObjectContext = _managedObjectContext;
//@synthesize managedObjectModel = _managedObjectModel;
//@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

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

-(NSArray *) fetchEntitiesWithName: (NSString *) entityName withPredicate: (NSPredicate *) predicate {
    return [self executeFetchRequest:[[NSFetchRequest alloc] init] entityName:entityName predicate:predicate];
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

-(void) deleteEntity: (id) entity {
    @synchronized(self.managedObjectContext)  {
        if (entity) {
            [self.managedObjectContext deleteObject:entity];
        }
    }
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

-(void) endUndoGroup {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.managedObjectContext.undoManager endUndoGrouping];
    });
}

-(void) undo {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.managedObjectContext.undoManager undo];
    });
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

-(NSArray *) fetchEntitiesWithTypes: (NSArray *) types {
    @synchronized(self.managedObjectContext)  {
        NSMutableArray * entities = [NSMutableArray new];
        for (NSString * type in types) {
            [entities addObjectsFromArray:[self fetchEntitiesWithName:type]];
        }
        return entities;
    }
}

-(void) deleteEntitiesWithType: (NSString *) type {
    @synchronized(self.managedObjectContext)  {
        NSArray * entities = [self fetchEntitiesWithTypes:@[type]];
        for (id entity in entities) {
            [self deleteEntity: entity];
        }
    }
}

-(void) deleteEntities: (NSArray *) entities {
    @synchronized(self.managedObjectContext)  {
        for (id entity in entities) {
            [self deleteEntity:entity];
        }
    }
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

-(id<PThread>) createThreadEntity {
    @synchronized(self.managedObjectContext)  {
        return [self createEntity:bThreadEntity];
    }
}

// TODO: Check this
-(id<PThread>) fetchThreadWithUsers: (NSArray *) users {
    @synchronized(self.managedObjectContext)  {
        NSMutableArray * allUsers = [NSMutableArray arrayWithArray:users];

        id<PUser> currentUser = NM.currentUser;
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
