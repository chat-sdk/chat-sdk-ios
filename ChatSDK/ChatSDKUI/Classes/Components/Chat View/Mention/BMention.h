//
//  BMention.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 06/09/2017.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    bMentionTypeNormal,
    bMentionTypeUrgent,
} bMentionType;

@class HKWMentionsAttribute;

@interface BMention : NSObject

@property (nonatomic, strong) NSString * entityId;
@property (nonatomic, strong) NSString * entityName;
@property (nonatomic, strong) NSNumber * type;

// This is the location of the mention in the string - this and the mention length allow us to find it exactly
@property (nonatomic, strong) NSNumber * location;

- (void)replaceNameWithName: (NSString *)newName;

+ (instancetype)entityWithName:(NSString *)name entityId:(NSString *)entityID location: (NSNumber *)location type: (NSNumber *)type;

@end
