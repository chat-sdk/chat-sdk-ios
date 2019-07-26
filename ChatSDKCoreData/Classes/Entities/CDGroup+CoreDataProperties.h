//
//  CDGroup+CoreDataProperties.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 05/09/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDGroup.h"

NS_ASSUME_NONNULL_BEGIN
@class CDUserConnection;

@interface CDGroup (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<CDUserConnection *> *userConnections;

@end

@interface CDGroup (CoreDataGeneratedAccessors)

- (void)addUserConnectionsObject:(CDUserConnection *)value;
- (void)removeUserConnectionsObject:(CDUserConnection *)value;
- (void)addUserConnections:(NSSet<CDUserConnection *> *)values;
- (void)removeUserConnections:(NSSet<CDUserConnection *> *)values;

@end

NS_ASSUME_NONNULL_END
