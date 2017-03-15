//
//  CDThread.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 18/08/2016.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <ChatSDKCore/PEntity.h>
#import <ChatSDKCore/PThread_.h>
#import <ChatSDKCore/PThreadWrapper.h>
#import <ChatSDKCore/PHasMeta.h>

@class CDMessage, CDUser;

NS_ASSUME_NONNULL_BEGIN

@interface CDThread : NSManagedObject<PEntity, PThread, PThreadWrapper, PHasMeta>

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "CDThread+CoreDataProperties.h"
