//
//  BBackgroundPushAction.m
//  AFNetworking
//
//  Created by Ben on 8/24/18.
//

#import "BBackgroundPushAction.h"

@implementation BBackgroundPushAction

-(instancetype) initWithType: (bPushActionType) type payload: (NSDictionary *) payload {
    if ((self = [super init])) {
        self.type = type;
        self.payload = payload;
    }
    return self;
}

+(instancetype) actionWithType: (bPushActionType) type payload: (NSDictionary *) payload {
    return [[self alloc] initWithType:type payload:payload];
}

@end
