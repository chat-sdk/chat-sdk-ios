//
//  CDUser.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 18/08/2016.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <ChatSDK/PUser.h>
#import <ChatSDK/PEntity.h>
#import <ChatSDK/PUserWrapper.h>

@class CDLinkedContact, CDMessage, CDThread, CDUserAccount;

NS_ASSUME_NONNULL_BEGIN

@interface CDUser : NSManagedObject<PUser, PUserWrapper>

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "CDUser+CoreDataProperties.h"


