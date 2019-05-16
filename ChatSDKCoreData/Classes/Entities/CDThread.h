//
//  CDThread.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 18/08/2016.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <ChatSDK/PEntity.h>
#import <ChatSDK/PThread_.h>
#import <ChatSDK/PThreadWrapper.h>


@class CDMessage, CDUser;

NS_ASSUME_NONNULL_BEGIN

@interface CDThread : NSManagedObject<PThread, PThreadWrapper> {
}

@end

NS_ASSUME_NONNULL_END

#import "CDThread+CoreDataProperties.h"
