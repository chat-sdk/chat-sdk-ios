//
//  BGeoEvent.m
//  AFNetworking
//
//  Created by Benjamin Smiley-Andrews on 08/04/2019.
//

#import "BGeoEvent.h"
#import "NearbyUsers.h"

@implementation BGeoEvent

@synthesize type;
@synthesize item;

+(instancetype) event: (BGeoItem *) item withType: (bGeoEventType) type {
    return [[BGeoEvent alloc] init:item withType:type];
}

-(instancetype) init: (BGeoItem *) item withType: (bGeoEventType) type {
    if((self = [super init])) {
        self.item = item;
        self.type = type;
    }
    return self;
}

-(BOOL) isEqual:(id)object {
    if ([object isKindOfClass:[BGeoEvent class]]) {
        BGeoEvent * other = (BGeoEvent *) object;
        return [self.item isEqual:other.item];
    }
    return false;
}

@end
