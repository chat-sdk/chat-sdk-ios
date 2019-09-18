//
//  CDMessage+CoreDataProperties.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 05/09/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDMessage+CoreDataProperties.h"

@implementation CDMessage (CoreDataProperties)

@dynamic date;
@dynamic delivered;
@dynamic entityID;
@dynamic flagged;
@dynamic placeholder;
@dynamic read;
@dynamic type;
@dynamic thread;
@dynamic user;
@dynamic meta;
@dynamic readStatus;
@dynamic previousMessage;
@dynamic nextMessage;

@end
