//
//  CDUserConnection+CoreDataProperties.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 05/09/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDUserConnection.h"

NS_ASSUME_NONNULL_BEGIN

@class CDThread;

@interface CDUserConnection (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *entityID;
@property (nullable, nonatomic, retain) id meta;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) CDUser *owner;
@property (nullable, nonatomic, retain) CDThread *thread;
@property (nullable, nonatomic, retain) NSString *userAccountID;

@end

@interface CDUserConnection (CoreDataGeneratedAccessors)

@end

NS_ASSUME_NONNULL_END
