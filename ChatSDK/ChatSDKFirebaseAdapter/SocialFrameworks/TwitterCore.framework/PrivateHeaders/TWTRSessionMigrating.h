//
//  TWTRSessionMigrating.h
//  TwitterCore
//
//  Copyright (c) 2015 Twitter Inc. All rights reserved.
//

#import <TwitterCore/TWTRSessionStore.h>

@protocol TWTRSessionMigrating <NSObject>

/**
 * Specifies that the migrator should migrate any existing sessions into the given store.
 *
 * @param store the store to migrate sessions to
 * @param removeOnSuccess if the migrator should remove the sessions on successful migration.
 */
- (void)runMigrationWithDestination:(id<TWTRSessionStore>)store removeOnSuccess:(BOOL)removeOnSuccess;

@end
