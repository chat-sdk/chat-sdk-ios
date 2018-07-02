//
//  BCoreDataManager.h
//  NekNominate
//
//  Created by Benjamin Smiley-andrews on 12/02/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ChatSDK/BStorageAdapter.h>
//#import "Core.h"


@interface BCoreDataManager : NSObject<BStorageAdapter> {
    NSManagedObjectContext * _moc;
    NSManagedObjectContext * _privateMoc;
    NSManagedObjectModel * _model;
    NSPersistentStoreCoordinator * _store;
}



//@property (nonatomic, retain, readonly) NSManagedObjectModel * managedObjectModel;
//@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
//@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(NSArray *) fetchEntitiesWithName: (NSString *) entityName;
-(id) fetchOrCreateEntityWithID: (NSString *) entityID withType: (NSString *) type;

-(NSArray *) fetchEntitiesWithName: (NSString *) entityName withPredicate: (NSPredicate *) predicate;

-(id) createEntity: (NSString *) entityName;
-(void) deleteEntity: (id) entity;
-(void) save;
-(id) fetchEntityWithID: (NSString *) entityID withType: (NSString *) type;
-(id) fetchOrCreateEntityWithPredicate: (NSPredicate *) predicate withType: (NSString *) type ;
-(id) executeFetchRequest: (NSFetchRequest *) fetchRequest entityName: (NSString *) entityName predicate: (NSPredicate *) predicate;

-(void) beginUndoGroup;
-(void) endUndoGroup;
-(void) undo;

@end
