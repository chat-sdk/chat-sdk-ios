//
//  CDUserConnection.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 18/08/2016.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <ChatSDK/PUserConnection.h>

@class CDGroup, CDUser;

NS_ASSUME_NONNULL_BEGIN

@interface CDUserConnection : NSManagedObject<PUserConnection>

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "CDUserConnection+CoreDataProperties.h"
