//
//  CDUserAccount+CoreDataProperties.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 05/09/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDUserAccount.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDUserAccount (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *token;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) CDUser *user;

@end

NS_ASSUME_NONNULL_END
