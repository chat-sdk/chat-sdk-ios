//
//  BMention.m
//  Pods
//
//  Created by Simon Smiley-Andrews on 06/09/2017.
//
//

#import "BMention.h"
#import "HKWMentionsAttribute.h"

@implementation BMention

+ (instancetype)entityWithName:(NSString *)name entityId:(NSString *)entityID location: (NSNumber *)location type: (NSNumber *)type {
    
    BMention * entity = [[self class] new];
    entity.entityId = entityID;
    entity.entityName = name;
    entity.location = location;
    entity.type = type;
    return entity;
}

- (void)replaceNameWithName: (NSString *)newName {
    self.entityName = newName;
}

@end
