//
//  CDUser+CoreDataProperties.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 05/09/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDUser.h"
#import "CDUserConnection.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *entityID;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSDate *lastOnline;
@property (nullable, nonatomic, retain) id meta;
@property (nullable, nonatomic, retain) NSNumber *online;
@property (nullable, nonatomic, retain) NSSet<CDUserAccount *> *linkedAccounts;
@property (nullable, nonatomic, retain) NSSet<CDMessage *> *messages;
@property (nullable, nonatomic, retain) NSSet<CDThread *> *threads;
@property (nullable, nonatomic, retain) NSSet<CDUserConnection *> *userConnections;

@end

@interface CDUser (CoreDataGeneratedAccessors)

- (void)addLinkedAccountsObject:(CDUserAccount *)value;
- (void)removeLinkedAccountsObject:(CDUserAccount *)value;
- (void)addLinkedAccounts:(NSSet<CDUserAccount *> *)values;
- (void)removeLinkedAccounts:(NSSet<CDUserAccount *> *)values;

- (void)addMessagesObject:(CDMessage *)value;
- (void)removeMessagesObject:(CDMessage *)value;
- (void)addMessages:(NSSet<CDMessage *> *)values;
- (void)removeMessages:(NSSet<CDMessage *> *)values;

- (void)addThreadsObject:(CDThread *)value;
- (void)removeThreadsObject:(CDThread *)value;
- (void)addThreads:(NSSet<CDThread *> *)values;
- (void)removeThreads:(NSSet<CDThread *> *)values;

- (void)addUserConnectionsObject:(CDUserConnection *)value;
- (void)removeUserConnectionsObject:(CDUserConnection *)value;
- (void)addUserConnections:(NSSet<CDUserConnection *> *)values;
- (void)removeUserConnections:(NSSet<CDUserConnection *> *)values;

@end

NS_ASSUME_NONNULL_END
