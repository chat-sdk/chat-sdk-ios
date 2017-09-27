//
//  BMentionList.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 06/09/2017.
//
//

#import <Foundation/Foundation.h>
#import "BMention.h"

@interface BMentionList : NSObject

@property (nonatomic, strong) NSMutableArray * mentions;

- (void)addMention: (BMention *)mention;
- (void)trimMentionWithName: (NSString *)newName entityID: (NSString *)entityID;
- (void)removeMentionWithEntityID: (NSString *)entityID;

- (NSDictionary *)serialize;
- (BMentionList *)deserialize: (NSDictionary *) value;

- (NSInteger)mentionCount;

- (instancetype)initWithMentions: (NSMutableArray *)mentions;

@end
