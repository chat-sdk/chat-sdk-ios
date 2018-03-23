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
#import <ChatSDK/PHasMeta.h>


@class CDMessage, CDUser;

NS_ASSUME_NONNULL_BEGIN

@interface CDThread : NSManagedObject<PThread, PThreadWrapper> {
    // We don't always want to load all the messages into memory so we
    // maintain a separate list of the messages that are currently relevant to us
    // i.e. start by only loading a certain number of messages
    NSMutableArray * _messagesWorkingList;
}

// Insert code here to declare functionality of your managed object subclass

-(void) optimize;

@end

NS_ASSUME_NONNULL_END

#import "CDThread+CoreDataProperties.h"
