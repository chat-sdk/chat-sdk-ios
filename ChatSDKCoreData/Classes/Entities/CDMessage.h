 //
//  CDMessage.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 18/08/2016.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <ChatSDK/PMessage.h>
#import <ChatSDK/PMessageWrapper.h>

@class CDUser, CDThread;

NS_ASSUME_NONNULL_BEGIN

@interface CDMessage : NSManagedObject<PMessage, PMessageWrapper> {
    NSNumber * _senderIsMe;
    NSNumber * _position;
}

-(NSComparisonResult) compare: (id<PMessage>) message;

-(float) getTextHeightWithFont: (UIFont *) font withWidth: (float) width;

- (NSURL *) imageURL;
- (NSInteger)imageWidth;
- (NSInteger)imageHeight;

-(void) updatePosition;

@end

NS_ASSUME_NONNULL_END

#import "CDMessage+CoreDataProperties.h"
