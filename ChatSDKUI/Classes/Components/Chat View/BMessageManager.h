//
//  BMessageManager.h
//  AFNetworking
//
//  Created by ben3 on 09/05/2019.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BMessageSection;
@protocol PMessage;
@protocol PElmMessage;

@interface BMessageManager : NSObject {
    NSMutableArray<BMessageSection *> * _messageSections;
    NSDateFormatter * _dateFormatter;
}

-(NSIndexPath *) addMessage: (id<PMessage>) message;
-(NSIndexPath *) removeMessage: (id<PMessage>) message;
-(void) setMessages: (NSArray<PMessage> *) messages;
-(NSArray<NSIndexPath *> *) addMessages: (NSArray<id<PMessage>> *) messages;
//-(NSArray<NSIndexPath *> *) removeMessages: (NSArray<id<PMessage>> *) messages;
-(id<PMessage>) newestMessage;
-(id<PMessage>) oldestMessage;

-(NSInteger) sectionCount;
-(NSInteger) rowCountForSection: (NSInteger) section;
-(id<PElmMessage>) messageForIndexPath: (NSIndexPath *) indexPath;
-(UIView *) headerForSection: (NSInteger) section;

-(NSIndexPath *) indexPathForMessage: (id<PMessage>) message;
-(NSIndexPath *) indexPathForPreviousMessageInSection: (id<PMessage>) message;
-(NSIndexPath *) indexPathForPreviousMessage: (id<PMessage>) message;
-(NSArray<NSIndexPath *> *) indexPathsForMessages: (NSArray<PMessage> *) messages;
-(BMessageSection *) messageSectionForIndex: (NSInteger) index;
-(void) debug;

@end

NS_ASSUME_NONNULL_END
