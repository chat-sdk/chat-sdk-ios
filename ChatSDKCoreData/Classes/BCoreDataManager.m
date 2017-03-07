//
//  BCoreDataManager.m
//  NekNominate
//
//  Created by Benjamin Smiley-andrews on 12/02/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "BCoreDataManager.h"

#import <ChatSDKCore/ChatCore.h>
#import <ChatSDKCoreData/ChatCoreData.h>

static BCoreDataManager * manager;

@implementation BCoreDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

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

-(id) init {
    if ((self = [super init])) {
        
    }
    return self;
}

-(void) save {
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Save error: %@", error.localizedDescription);
    }
}

-(NSArray *) fetchEntitiesWithName: (NSString *) entityName {
    return [self fetchEntitiesWithName:entityName withPredicate:Nil];
}

-(NSArray *) fetchEntitiesWithName: (NSString *) entityName withPredicate: (NSPredicate *) predicate {
    
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
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

-(id) fetchEntityWithID: (NSString *) entityID withType: (NSString *) type {
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"entityID = %@", entityID];
    NSArray * results = [self fetchEntitiesWithName:type withPredicate:predicate];
    for (id result in results) {
        return result;
    }
    return Nil;
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
                                         inManagedObjectContext:self.managedObjectContext];

    return entity;
}

-(void) deleteEntity: (id) entity {
    // #6705 Start bug fix for v3.0.2
    if (entity) {
        [self.managedObjectContext deleteObject:entity];
    }
    // End bug fix for v3.0.2
}

- (NSManagedObjectContext *) managedObjectContext {

    if (!_managedObjectContext) {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] init];
            [_managedObjectContext setPersistentStoreCoordinator: coordinator];
            
            NSUndoManager *undoManager = [[NSUndoManager alloc] init];
            [_managedObjectContext setUndoManager:undoManager];
        }
    }
    
    return _managedObjectContext;
}

-(void) beginUndoGroup {
    [self.managedObjectContext.undoManager beginUndoGrouping];
}

-(void) endUndoGroup {
    [self.managedObjectContext.undoManager endUndoGrouping];
}

-(void) undo {
    [self.managedObjectContext.undoManager undo];
}


- (NSManagedObjectModel *)managedObjectModel {
    
    if (!_managedObjectModel) {
        
        NSBundle * bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"ChatCoreData" ofType:@"bundle"]];

        /*
        NSString *path1 = [bundle resourcePath];
        NSFileManager *fm = [NSFileManager defaultManager];
        
        NSError *error = nil;
        NSArray *directoryAndFileNames = [fm contentsOfDirectoryAtPath:path1 error:&error];
        */
        
        NSString * path = [bundle pathForResource:@"ChatSDK" ofType:@"momd"];
        NSURL * momURL = [NSURL fileURLWithPath:path];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
        
    }
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (!_persistentStoreCoordinator) {
        
        NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                                   stringByAppendingPathComponent: @"ChatSDK.sqlite"]];

        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                       initWithManagedObjectModel:[self managedObjectModel]];
        
        
        NSDictionary * options = @{NSMigratePersistentStoresAutomaticallyOption: @YES,
                                   NSInferMappingModelAutomaticallyOption: @YES};
        
        if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                      configuration:nil URL:storeUrl options:options error:&error]) {
            NSLog(@"Error setting up database: %@", error.localizedDescription);
        }
    }
    
    return _persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

-(id<PMessage>) createMessageEntity {
    return [self createEntity:bMessageEntity];
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
    for (id entity in entities) {
        [self deleteEntity:entity];
    }
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
    [self save];
}

-(id<PThread>) createThreadEntity {
    return [self createEntity:bThreadEntity];
}

// TODO: Check this
-(id<PThread>) fetchThreadWithUsers: (NSArray *) users {
    NSMutableArray * allUsers = [NSMutableArray arrayWithArray:users];

    id<PUser> currentUser = [BNetworkManager sharedManager].a.core.currentUserModel;
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

@end
