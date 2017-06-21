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

#define bMessageWorkingListInitialSize 50

@class CDMessage, CDUser;

NS_ASSUME_NONNULL_BEGIN

@interface CDThread : NSManagedObject<PEntity, PThread, PThreadWrapper, PHasMeta> {
    // We don't always want to load all the messages into memory so we
    // maintain a separate list of the messages that are currently relevant to us
    // i.e. start by only loading a certain number of messages
    NSMutableArray * _messagesWorkingList;
}

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "CDThread+CoreDataProperties.h"
