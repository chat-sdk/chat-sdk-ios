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
}

-(NSComparisonResult) compare: (id<PMessage>) message;

-(float) getTextHeightWithFont: (UIFont *) font withWidth: (float) width;

- (NSURL *)thumbnailURL;
- (NSURL *)mainImageURL;
- (NSInteger)imageWidth;
- (NSInteger)imageHeight;

-(void) updatePosition;

-(void) updateOptimizationProperties;
-(void) clearOptimizationProperties;

@end

NS_ASSUME_NONNULL_END

#import "CDMessage+CoreDataProperties.h"
