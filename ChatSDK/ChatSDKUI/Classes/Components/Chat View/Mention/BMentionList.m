//
//  BMentionList.m
//  Pods
//
//  Created by Simon Smiley-Andrews on 06/09/2017.
//
//

#import "BMentionList.h"

#import <ChatSDKCore/ChatCore.h>

#define bMentionEntityID @"entityID"
#define bMentionEntityName @"name"
#define bMentionEntityLocation @"location"
#define bMentionEntityType @"type"

@implementation BMentionList

- (instancetype)initWithMentions: (NSMutableArray *)mentions {
    
    BMentionList * entity = [[self class] new];
    entity.mentions = mentions;
    return entity;
}

// We take a mentionList object and output an NSDictionary
- (NSDictionary *)serialize {
    
    NSMutableDictionary * dict = [NSMutableDictionary new];
    NSMutableArray * orderedMentions = [NSMutableArray new];
    
    for (BMention * mention in self.mentions) {
        
        NSDictionary * mentionDict = @{bMentionEntityName: mention.entityName,
                                       bMentionEntityID: mention.entityId,
                                       bMentionEntityLocation: mention.location,
                                       bMentionEntityType: mention.type};
        
        [orderedMentions addObject:mentionDict];
    }
    
    return @{bMentionsPath: orderedMentions};
}

// We take an NSDictionary and output a MentionList object
- (BMentionList *)deserialize: (NSDictionary *) value {
    
    // We have a dictionary containing an array of mentions
    // We want to convert this into a mentionsListObject
    
    NSArray * mentions = value[bMentionsPath];
    
    for (NSDictionary * dict in mentions) {
        
        BMention * mention = [BMention entityWithName:dict[bMentionEntityName]
                                             entityId:dict[bMentionEntityID]
                                             location:dict[bMentionEntityLocation]
                                                 type:dict[bMentionEntityType]];
        
        [self addMention:mention];
    }
    
    return self;
}

- (void)addMention: (BMention *)mention {
    [self.mentions addObject:mention];
}

- (void)trimMentionWithName: (NSString *)newName entityID: (NSString *)entityID {
    
    for (BMention * mention in self.mentions) {
        if ([mention.entityId isEqualToString:entityID]) {
            mention.entityName = newName;
        }
    }
}

- (void)removeMentionWithEntityID: (NSString *)entityID {
    
    NSInteger removeIndex;
    
    for (BMention * mention in self.mentions) {
        if ([mention.entityId isEqualToString:entityID]) {
            removeIndex = [_mentions indexOfObject:mention];
        }
    }
    
    [self.mentions removeObjectAtIndex:removeIndex];
}

- (NSInteger)mentionCount {
    return self.mentions.count;
}

@end
