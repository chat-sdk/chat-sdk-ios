//
//  CDUser.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 18/08/2016.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <ChatSDKCore/PUser.h>
#import <ChatSDKCore/PEntity.h>
#import <ChatSDKCore/PUserWrapper.h>
#import <ChatSDKCore/PHasMeta.h>

@class CDLinkedContact, CDMessage, CDThread, CDUserAccount;

NS_ASSUME_NONNULL_BEGIN

@interface CDUser : NSManagedObject<PEntity, PUser, PUserWrapper, PHasMeta>

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "CDUser+CoreDataProperties.h"
