//
//  BGeoItem.m
//  AFNetworking
//
//  Created by Benjamin Smiley-Andrews on 08/04/2019.
//

#import "BGeoItem.h"
#import <ChatSDK/Core.h>

@implementation BGeoItem

@synthesize entityID;
@synthesize type;

-(instancetype) init {
    if((self = [super init])) {
        type = bGeoItemTypeUser;
    }
    return self;
}

+(instancetype) item: (NSString *) itemID {
    return [[self alloc] init:itemID];
}

+(instancetype) item: (NSString *) entityID withType: (NSString *) type {
    return [[self alloc] init: entityID withType: type];
}

-(instancetype) init: (NSString *) itemID {
    if((self = [self init])) {
        NSArray * split = [itemID componentsSeparatedByString:@"_"];
        if (split.count >= 2) {
            self.type = split.firstObject;
            self.entityID = [itemID stringByReplacingOccurrencesOfString:[self.type stringByAppendingString:@"_"] withString:@""];
        } else {
            entityID = itemID;
        }
    }
    // Add a listener to the user if necessary
    if ([self typeIs:bGeoItemTypeUser]) {
        [BChatSDK.core observeUser:self.entityID];
    }
    return self;
}

-(instancetype) init: (NSString *) entityID withType: (NSString *) type {
    if((self = [self init])) {
        self.type = type;
        self.entityID = entityID;
    }
    return self;
}

-(NSString *) itemID {
    return [type stringByAppendingFormat:@"_%@", entityID];
}

-(BOOL) typeIs: (NSString *) type {
    return [type isEqualToString:self.type];
}


-(BOOL) isEqual:(id)object {
    if ([object isKindOfClass:[BGeoItem class]]) {
        BGeoItem * other = (BGeoItem *) object;
        if ([self.itemID isEqual:other.itemID]) {
            return true;
        }
    }
    return false;
}

@end
