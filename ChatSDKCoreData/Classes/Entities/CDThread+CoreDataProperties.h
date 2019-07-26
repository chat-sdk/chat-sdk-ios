//
//  CDThread+CoreDataProperties.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 05/09/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDThread.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDThread (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *creationDate;
@property (nullable, nonatomic, retain) NSDate *deletedDate;
@property (nullable, nonatomic, retain) NSString *entityID;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) id meta;
@property (nullable, nonatomic, retain) CDUser *creator;
@property (nullable, nonatomic, retain) NSSet<CDMessage *> *messages;
@property (nullable, nonatomic, retain) NSSet<CDUser *> *users;

@end

@interface CDThread (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(CDMessage *)value;
- (void)removeMessagesObject:(CDMessage *)value;
- (void)addMessages:(NSSet<CDMessage *> *)values;
- (void)removeMessages:(NSSet<CDMessage *> *)values;

- (void)addUsersObject:(CDUser *)value;
- (void)removeUsersObject:(CDUser *)value;
- (void)addUsers:(NSSet<CDUser *> *)values;
- (void)removeUsers:(NSSet<CDUser *> *)values;

@end

NS_ASSUME_NONNULL_END
