//
//  CDUserAccount.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 18/08/2016.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <ChatSDK/PUserAccount.h>

@class CDUser;

NS_ASSUME_NONNULL_BEGIN

@interface CDUserAccount : NSManagedObject<PUserAccount>

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "CDUserAccount+CoreDataProperties.h"
