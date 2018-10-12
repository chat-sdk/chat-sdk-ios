//
//  BCoreDataManager.h
//  NekNominate
//
//  Created by Benjamin Smiley-andrews on 12/02/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ChatSDK/BStorageAdapter.h>

@interface BCoreDataManager : NSObject<BStorageAdapter> {
    NSManagedObjectContext * _moc;
    NSManagedObjectContext * _privateMoc;
    NSManagedObjectContext * _backgrondMoc;
    NSManagedObjectModel * _model;
    NSPersistentStoreCoordinator * _store;
}

@end
