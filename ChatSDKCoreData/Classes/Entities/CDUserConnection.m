//
//  CDUserConnection.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 18/08/2016.
//
//

#import "CDUserConnection.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/CoreData.h>

#define bSubscriptionTypeKey @"subscriptionType"

#define bSubscriptionTypeStringTo @"to"
#define bSubscriptionTypeStringFrom @"from"
#define bSubscriptionTypeStringBoth @"both"

@implementation CDUserConnection

-(bUserConnectionType) userConnectionType {
    return self.type.intValue;
}

-(id<PUser>) user {
    return [BChatSDK.db fetchEntityWithID:self.entityID withType:bUserEntity];
}

-(void) setSubscriptionType:(NSString *)subscriptionType {
    [self setMetaValue:subscriptionType forKey:bSubscriptionTypeKey];
}

-(bSubscriptionType) subscriptionType {
    NSString * type = [self.meta metaStringForKey:bSubscriptionTypeKey];
    
    if ([type isEqualToString:bSubscriptionTypeStringTo]) {
        return bSubscriptionTypeTo;
    }
    if ([type isEqualToString:bSubscriptionTypeStringFrom]) {
        return bSubscriptionTypeFrom;
    }
    if ([type isEqualToString:bSubscriptionTypeStringBoth]) {
        return bSubscriptionTypeBoth;
    }
    return bSubscriptionTypeNone;
}

-(void) updateMeta: (NSDictionary *) dict {
    if (!self.meta) {
        self.meta = @{};
    }
    self.meta = [self.meta updateMetaDict:dict];
}

-(void) setMetaValue: (id) value forKey: (NSString *) key {
    [self updateMeta:@{key: [NSString safe: value]}];
}

-(BOOL) isEqualToEntity: (id<PEntity>) entity {
    return [self.entityID isEqualToString:entity.entityID];
}

@end
