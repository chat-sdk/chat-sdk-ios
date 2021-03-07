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
        
        _entityCache = [NSMutableDictionary new];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:Nil queue:0 usingBlock:^(NSNotification * notification) {
        }];

        [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:Nil queue:0 usingBlock:^(NSNotification * notification) {
            [self privateQueueObjectContextDidSaveNotification:notification];
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextObjectsDidChangeNotification object:Nil queue:0 usingBlock:^(NSNotification * notification) {
            
            NSDictionary * info = notification.userInfo;
            
//            NSSet * updated = info[@"updated"];
//            NSSet * inserted = info[@"inserted"];
//            NSSet * deleted = info[@"deleted"];
//
//            NSString * moc = @"";
//            if ([notification.object isEqual:_parentMoc]) {
//                moc = @"Parent";
//            }
//            if ([notification.object isEqual:_mainMoc]) {
//                moc = @"Main";
//            }
//            if ([notification.object isEqual:_backgroundMoc]) {
//                moc = @"Background";
//            }
//
//            if (updated) {
//
//            }
//            if (inserted) {
//                for (NSManagedObject * entity in inserted) {
//                    if ([entity isKindOfClass:CDThread.class]) {
//
//                        CDThread * thread = (CDThread *) entity;
//
//                        NSLog(@"Insert Thread %@ %@", moc, thread.entityID);
//
////                        [_mainMoc performBlock:^{
////                            NSArray * items = [self fetchEntitiesWithName:bThreadEntity];
////                            NSMutableDictionary * dict = [NSMutableDictionary new];
////                            for (id<PThread> thread in items) {
////                                id<PThread> dup = dict[thread.entityID];
////                                if (dup) {
////                                    NSLog(@"Duplicate!");
////                                } else {
////                                    dict[thread.entityID] = thread;
////                                }
////                            }
////                        }];
//                    }
//
//                }
//            }
//            if (deleted) {
//
//            }
            
            
            [self privateQueueObjectContextDidChangeNotification:notification];
        }];
        
        [BChatSDK.hook addHook:[BHook hookOnMain:^(NSDictionary * dict) {
            NSString * currentUserID = BChatSDK.currentUserID;
            for (CDThread * thread in BChatSDK.currentUser.threads) {
                if (!thread.userAccountID) {
                    thread.userAccountID = currentUserID;
                }
            }
        }] withName:bHookDidAuthenticate];
        
    }
    
    _mainMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//    _mainMoc.parentContext = _parentMoc;
    _mainMoc.persistentStoreCoordinator = self.persistentStoreCoordinator;
    _mainMoc.automaticallyMergesChangesFromParent = YES;
    _mainMoc.mergePolicy = NSErrorMergePolicy;

    _backgroundMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    _backgroundMoc.parentContext = _mainMoc;
    _backgroundMoc.automaticallyMergesChangesFromParent = YES;
    _backgroundMoc.mergePolicy = NSErrorMergePolicy;

    NSUndoManager *undoManager = [[NSUndoManager alloc] init];
    [_mainMoc setUndoManager:undoManager];
    
    return self;
}

-(NSManagedObjectContext *) mainMoc {
    return _mainMoc;
}

-(void) saveBackground {
    [_backgroundMoc performBlock:^{
        [self save:_backgroundMoc];
    }];
}

-(void) save: (NSManagedObjectContext *) context {
    @try {
        NSError *error = nil;
        if (![context save:&error]) {
            [BChatSDK.shared.logger log: @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]];
        }
    }
    @catch (NSException * e) {
        [BChatSDK.shared.logger log: @"Error saving context: %@\n%@", [e name], [e description]];
    }
}

-(void) save {
    [self saveFinally:nil];
}

-(void) saveFinally: (Completion) completion {
    [_mainMoc performBlock:^{
        [self save:_mainMoc];
        if (completion != nil) {
            completion();
        }
    }];
}

-(NSArray *) fetchEntitiesWithName: (NSString *) entityName {
    return [self fetchEntitiesWithName:entityName withPredicate:Nil];
}

-(id) executeFetchRequest: (NSFetchRequest *) fetchRequest entityName: (NSString *) entityName predicate: (NSPredicate *) predicate {
    return [self executeFetchRequest:fetchRequest entityName:entityName predicate:predicate context:_mainMoc];
}

-(id) executeFetchRequest: (NSFetchRequest *) fetchRequest entityName: (NSString *) entityName predicate: (NSPredicate *) predicate context: (NSManagedObjectContext *) context {
    [fetchRequest setIncludesPendingChanges:YES];
    
    if (!context) {
        context = _mainMoc;
    }
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    if (!entity) {
        return Nil;
    }
    
    [fetchRequest setEntity:entity];
    if (predicate != Nil) {
        [fetchRequest setPredicate:predicate];
    }
    
    NSError * error = Nil;
    NSArray * entities = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        [BChatSDK.shared.logger log: @"Fetch error: %@", error.localizedDescription];
    }
    return entities;
    
}

-(NSArray *) fetchUserConnectionsWithType: (bUserConnectionType) type {
    return [self fetchUserConnectionsWithType:type entityID:Nil];
}

-(NSArray *) fetchUserConnectionsWithType: (bUserConnectionType) type entityID: (nullable NSString *) entityID {
    id<PUser> currentUser = BChatSDK.currentUser;
    NSString * currentUserID = currentUser.entityID;

    NSPredicate * predicate;
    if (entityID) {
        predicate = [NSPredicate predicateWithFormat:@"type = %@ AND owner = %@ AND entityID = %@ AND owner.userAccountID = %@", @(type), currentUser, entityID, currentUserID];
    }
    else {
        predicate = [NSPredicate predicateWithFormat:@"type = %@ AND owner = %@ AND owner.userAccountID = %@", @(type), currentUser, currentUserID];
    }

    return [BChatSDK.db fetchEntitiesWithName:bUserConnectionEntity withPredicate:predicate];
}

-(id) fetchOrCreateUserConnectionWithID: (NSString *) entityID withType: (bUserConnectionType) type {
    NSArray * results = [self fetchUserConnectionsWithType:type entityID:entityID];
        
    for (id result in results) {
        return result;
    }
    
    CDUserConnection * connection = [self createEntity:bUserConnectionEntity];
    connection.entityID = entityID;
    connection.type = @(type);
    
    return connection;
}

-(NSArray *) fetchEntitiesWithName: (NSString *) entityName withPredicate: (NSPredicate *) predicate {
    return [self executeFetchRequest:[[NSFetchRequest alloc] init] entityName:entityName predicate:predicate];
}

-(id) fetchEntityWithID: (NSString *) entityID withType: (NSString *) type {
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"entityID = %@ AND userAccountID = %@", entityID, BChatSDK.currentUserID];
    // Copy it to stop a mutation error
    NSArray * results = [NSArray arrayWithArray:[self fetchEntitiesWithName:type withPredicate:predicate]];
    
    if (results.count > 1) {
        [BChatSDK.shared.logger log: @"Error: Fetch entity with ID: %@, type: %@", entityID, type];
        [BChatSDK.shared.logger log: @"Error: Fetch entity with ID, duplicate items %@", results];
    }
    
    for (id result in results) {
        return result;
    }
    return Nil;
}

-(NSUInteger) fetchEntityCountWithID: (NSString *) entityID withType: (NSString *) type {
    return [self fetchEntityCountWithID:entityID withType:type context:_mainMoc];
}

-(NSUInteger) fetchEntityCountWithID: (NSString *) entityID withType: (NSString *) type context: (NSManagedObjectContext *) context {
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"entityID = %@ AND userAccountID = %@", entityID, BChatSDK.currentUserID];
    return [self fetchEntityCountWithPredicate:predicate withType:type context:context];
}

-(NSUInteger) fetchEntityCountWithPredicate: (NSPredicate *) predicate withType: (NSString *) type context: (NSManagedObjectContext *) context {
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:type];
    request.includesPendingChanges = true;
    request.predicate = predicate;
    
    NSError * error = nil;
    NSUInteger count = [context countForFetchRequest:request error:&error];
    if (count != NSNotFound) {
        return count;
    } else {
        return 0;
    }
}

-(BOOL) entityExistsWithID: (NSString *) entityID withType: (NSString *) type {
    return [self fetchEntityCountWithID:entityID withType:type] != 0;
}

-(void) performOnMain: (Completion) block {
    [_mainMoc performBlock:^{
        if (block != nil) {
            block();
        }
    }];
}

-(void) performOnMainAndWait:(Completion) block {
    [_mainMoc performBlockAndWait:^{
        block();
    }];
}

-(void) performOnMainAndSave:(Completion) beforeSave finally: (Completion) afterSave {
    return [self performOnAndSave:_mainMoc then:beforeSave finally:afterSave];
}

-(void) performOnAndSave: (NSManagedObjectContext *) context then: (Completion) beforeSave finally: (Completion) afterSave {
    [context performBlock:^{
        if (beforeSave != nil) {
            beforeSave();
        }
        [self save:context];
        if (afterSave != nil) {
            afterSave();
        }
    }];
}

-(id) fetchOrCreateEntityWithID: (NSString *) entityID withType: (NSString *) type {
    
    if (!entityID.length) {
        [BChatSDK.shared.logger log:@"Error: Tried to create entity of type %@ with nil entity ID", type];
        return nil;
    }
    
    id<PEntity> entity = [self fetchEntityWithID:entityID withType:type];
    if (!entity) {
        entity = [self createEntity:type];
    }
    if (entityID && [entity respondsToSelector:@selector(setEntityID:)]) {
        [((id<PEntity>) entity) setEntityID:entityID];
    }
    if (type == bUserEntity && [entityID isEqualToString:@"blackchat.net"]) {
        NSLog(@"Blackchat");
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
    id entity = nil;

//    [_mainMoc performBlockAndWait:^{
        if ([entityName isEqualToString:bUserEntity]) {
            [BChatSDK.shared.logger log: @"Creating: %@", entityName];
        }
        if ([entityName isEqualToString:bThreadEntity]) {
            [BChatSDK.shared.logger log: @"Creating: %@", entityName];
        }

        entity = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                  inManagedObjectContext:_mainMoc];
        
        if ([entityName isEqualToString:bUserEntity]) {
            [BChatSDK.shared.logger log: @"Creating: %@", entityName];
        }
        if ([entityName isEqualToString:bThreadEntity]) {
    //        CDThread * thread = (CDThread *) entity;
    //        thread.currentUserEntityID = BChatSDK.currentUserID;
            [BChatSDK.shared.logger log: @"Creating: %@", entityName];
        }
        
        if ([entity respondsToSelector:@selector(setUserAccountID:)]) {
            [entity setUserAccountID: BChatSDK.currentUserID];
        }

    //    SEL selector = NSSelectorFromString(@"setUserAccountID:");
    //    if ([entity respondsToSelector:selector]) {
    //        [entity performSelector:selector withObject:BChatSDK.currentUserID];
    //    }
//    }];
    
    return entity;
}

-(void) beginUndoGroup {
    [_mainMoc.undoManager beginUndoGrouping];
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
    [_mainMoc.undoManager undo];
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
            [BChatSDK.shared.logger log: @"Error setting up database: %@", error.localizedDescription];
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
    [_mainMoc.undoManager endUndoGrouping];
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
    if ([entity isKindOfClass:[CDMessage class]]) {
        CDMessage * message = (CDMessage *) entity;
        [message.thread removeMessagesObject:message];
    }
    [_mainMoc deleteObject:entity];
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
    return [self loadMessagesForThread:thread fromDate:date count:count newestFirst:YES context:_mainMoc];
}

-(NSArray<PMessage> *) loadAllMessagesForThread: (id<PThread>) thread newestFirst: (BOOL) newestFirst {
    return [self loadMessagesForThread:thread fromDate:Nil count:0 newestFirst:newestFirst context:_mainMoc];
}

-(NSArray<PMessage> *) loadMessagesForThread: (id<PThread>) thread newest: (int) count {
    return [self loadMessagesForThread:thread fromDate:Nil count:count newestFirst:YES context:_mainMoc];
}

-(NSArray<PMessage> *) loadMessagesForThread: (id<PThread>) thread oldest: (int) count {
    return [self loadMessagesForThread:thread fromDate:Nil count:count newestFirst:NO context:_mainMoc];
}

-(NSArray<PMessage> *) loadMessagesForThread: (id<PThread>) thread fromDate: (NSDate *) date count: (int) count newestFirst: (BOOL) newestFirst context: (NSManagedObjectContext *) context {
    
    __block NSArray * messages = @[];
    
    [context performBlockAndWait:^{
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        request.includesPendingChanges = YES;
        if (count > 0) {
            [request setFetchLimit:count];
        } else if (count < 0) {
            [request setFetchLimit:BChatSDK.config.messagesToLoadPerBatch];
        }
        
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:!newestFirst]];
        
        NSString * currentUserID = BChatSDK.currentUserID;

        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"thread = %@ AND userAccountID = %@", thread, currentUserID];
        if (date) {
            predicate = [NSPredicate predicateWithFormat:@"thread = %@ AND date < %@ AND userAccountID = %@", thread, date, currentUserID];
        }
        
        messages = [self executeFetchRequest:request
                                  entityName:bMessageEntity
                                   predicate:predicate
                                     context:context];
    }];
    
    return messages;
}

//-(void) loadMessagesForThread: (id<PThread>) thread newest: (int) count completion: (CompletionArray) completion {
//    NSMutableArray * messages = [self loadMessagesForThread:thread fromDate:Nil count:count newestFirst:YES context:_backgroundMoc];
//    if (completion != nil) {
//        completion(messages);
//    }
//}

-(NSArray *) threadsWithType: (bThreadType) type {
    __block NSArray * threads = nil;
    [_mainMoc performBlockAndWait:^{
        threads = [self threadsWithType:type context:_mainMoc];
    }];
    return threads;
}

-(NSArray *) threadsWithType: (bThreadType) type context: (NSManagedObjectContext *) context {
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    request.includesPendingChanges = YES;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:false]];
    
    NSString * currentUserID = BChatSDK.currentUserID;
    NSPredicate * predicate;
    if (type & bThreadFilterPublic) {
        predicate = [NSPredicate predicateWithFormat:@"type = %@ AND userAccountID = %@", @(bThreadTypePublicGroup), currentUserID];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"(type = %@ OR type = %@)  AND (ANY users.entityID = %@) AND userAccountID = %@", @(bThreadType1to1), @(bThreadTypePrivateGroup), currentUserID, currentUserID];
    }
    
    NSArray * threads = [self executeFetchRequest:request
                                               entityName:bThreadEntity
                                                predicate:predicate
                                                  context: context];
    return threads;
}

-(void) threadsWithType: (bThreadType) type then: (CompletionArray) completion {
    [_backgroundMoc performBlock: ^{
        NSArray * threads = [self threadsWithType:type context:_backgroundMoc];
        completion(threads);
    }];
}

-(RXPromise *) privateThreadUnreadMessageCount {
    NSString * currentUserEntityID = BChatSDK.currentUserID;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"(thread.type = %@ OR thread.type = %@) AND thread.userAccountID = %@ AND user.entityID != %@ AND (read == NO || read = nil)", @(bThreadType1to1), @(bThreadTypePrivateGroup), currentUserEntityID, currentUserEntityID];
    return [self unreadMessagesCountWithPredicate:predicate];
}

-(RXPromise *) publicThreadUnreadMessageCount {
    NSString * currentUserEntityID = BChatSDK.currentUserID;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"thread.type = %@ AND thread.userAccountID = %@ AND user.entityID != %@ AND (read == NO || read = nil)", @(bThreadTypePublicGroup), currentUserEntityID, currentUserEntityID];
    return [self unreadMessagesCountWithPredicate:predicate];
}

-(RXPromise *) unreadMessagesCount: (NSString *) threadEntityID {
    NSString * currentUserEntityID = BChatSDK.currentUserID;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"thread.entityID = %@ AND thread.userAccountID = %@ AND user.entityID != %@ AND (read == NO || read = nil)", threadEntityID, currentUserEntityID, currentUserEntityID];
    return [self unreadMessagesCountWithPredicate:predicate];
}

-(int) unreadMessagesCountNow: (NSString *) threadEntityID {
    __block int count = 0;
    [_mainMoc performBlockAndWait:^{
        NSString * currentUserEntityID = BChatSDK.currentUserID;

        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"thread.entityID = %@ AND thread.userAccountID = %@ AND user.entityID != %@ AND (read == NO || read = nil)", threadEntityID, currentUserEntityID, currentUserEntityID];
        
        NSArray * messagesUnread = [self unreadMessagesNowWithPredicate:predicate context:_mainMoc];
        count = messagesUnread.count;

    }];
    return count;
}

-(void) unreadMessages: (NSString *) threadEntityID then: (CompletionArray) completion {
    NSString * currentUserEntityID = BChatSDK.currentUserID;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"thread.entityID = %@ AND thread.userAccountID = %@ AND user.entityID != %@ AND (read == NO || read = nil)", threadEntityID, currentUserEntityID, currentUserEntityID];
    return [self unreadMessagesWithPredicate:predicate context:_mainMoc then: completion];
}

-(void) unreadMessagesCountWithPredicate: (NSPredicate *) predicate then: (CompletionInt) completion {
    [self unreadMessagesWithPredicate:predicate context:_backgroundMoc then:^(NSArray * messages) {
        completion(messages.count);
    }];
}

-(RXPromise *) unreadMessagesCountWithPredicate: (NSPredicate *) predicate {
    __block RXPromise * promise = [RXPromise new];
    [self unreadMessagesCountWithPredicate:predicate then:^(int count){
        [promise resolveWithResult:@(count)];
    }];
    return promise;
}

-(void) unreadMessagesWithPredicate: (NSPredicate *) predicate context: (NSManagedObjectContext *) context then: (CompletionArray) completion {
    // Can this be on background? Causes a crash
    // Maybe put this back on background?
    // Move to hook or notification
    [context performBlock: ^{
        completion([self unreadMessagesNowWithPredicate:predicate context:context]);
    }];
}

-(NSArray *) unreadMessagesNowWithPredicate: (NSPredicate *) predicate context: (NSManagedObjectContext *) context {
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    request.includesPendingChanges = YES;
            
    NSArray * messages = [self executeFetchRequest:request
                                               entityName:bMessageEntity
                                                predicate:predicate
                                                  context: context];

    return messages;
}


/// https://stackoverflow.com/questions/36338135/nsmanagedobjectcontext-how-to-update-child-when-parent-changes
/// I need this firing as sometimes objects change and the save notification below is not enough to make sure the UI updates.
- (void)privateQueueObjectContextDidChangeNotification:(NSNotification *)notification {
    NSManagedObjectContext * context = notification.object;
    
//    NSManagedObjectContext * parent = _parentMoc;
//    NSManagedObjectContext * background = self.backgroundManagedObjectContext;
    NSManagedObjectContext * main = _mainMoc;

//    if([context isEqual:parent]) {
//        NSLog(@"Parent");
//    }
//    else if([context isEqual:background]) {
//        NSLog(@"Background");
//    }
//    else if([context isEqual:main]) {
//        NSLog(@"Main");
//    }
//    else {
//        NSLog(@"None");
//    }
    
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
