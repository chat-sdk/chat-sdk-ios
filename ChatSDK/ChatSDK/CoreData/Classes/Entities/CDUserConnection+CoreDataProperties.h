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

@interface CDUserConnection (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *entityID;
@property (nullable, nonatomic, retain) id meta;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSSet<CDGroup *> *groups;
@property (nullable, nonatomic, retain) CDUser *owner;

@end

@interface CDUserConnection (CoreDataGeneratedAccessors)

- (void)addGroupsObject:(CDGroup *)value;
- (void)removeGroupsObject:(CDGroup *)value;
- (void)addGroups:(NSSet<CDGroup *> *)values;
- (void)removeGroups:(NSSet<CDGroup *> *)values;

@end

NS_ASSUME_NONNULL_END
