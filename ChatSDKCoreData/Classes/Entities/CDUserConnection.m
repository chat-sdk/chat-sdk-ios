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

#define SubscriptionTypeKey @"subscriptionType"

#define SubscriptionTypeStringTo @"to"
#define SubscriptionTypeStringFrom @"from"
#define SubscriptionTypeStringBoth @"both"

#define IsActive @"isActive"
#define HasLeft @"hasLeft"
#define Affiliation @"affiliation"
#define Role @"role"

@implementation CDUserConnection

-(bUserConnectionType) userConnectionType {
    return self.type.intValue;
}

-(id<PUser>) user {
    if (!_user || ![_user.entityID isEqualToString:self.entityID]) {
        _user = [BChatSDK.db fetchEntityWithID:self.entityID withType:bUserEntity];
    }
    return _user;
}

-(void) setSubscriptionType:(NSString *)subscriptionType {
    [self setMetaValue:subscriptionType forKey:SubscriptionTypeKey];
}

-(bSubscriptionType) subscriptionType {
    NSString * type = [self.meta metaStringForKey:SubscriptionTypeKey];
    
    if ([type isEqualToString:SubscriptionTypeStringTo]) {
        return bSubscriptionTypeTo;
    }
    if ([type isEqualToString:SubscriptionTypeStringFrom]) {
        return bSubscriptionTypeFrom;
    }
    if ([type isEqualToString:SubscriptionTypeStringBoth]) {
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

-(BOOL) setRole: (NSString *) role {
    if (role != self.role) {
        [self setMetaValue:role forKey:Role];
        return true;
    }
    return false;
}

-(NSString *) role {
    return self.meta[Role];
}

-(BOOL) setAffiliation: (NSString *) affiliation {
    if (affiliation != self.affiliation) {
        [self setMetaValue:affiliation forKey:Affiliation];
        return true;
    }
    return false;
}

-(NSString *) affiliation {
    return self.meta[Affiliation];
}

-(BOOL) setIsActive:(BOOL) isActive {
    if (isActive != self.isActive) {
        [self setMetaValue:@(isActive) forKey:IsActive];
        return true;
    }
    return false;
}

-(BOOL) isActive {
    return [self.meta[IsActive] boolValue];
}

-(BOOL) setHasLeft:(BOOL) hasLeft {
    if (hasLeft != self.hasLeft) {
        [self setMetaValue:@(hasLeft) forKey:HasLeft];
        return true;
    }
    return false;
}

-(BOOL) hasLeft {
    return [self.meta[HasLeft] boolValue];
}



@end
