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
    return [[BStorageManager sharedManager].a fetchEntityWithID:self.entityID withType:bUserEntity];
}

-(void) setSubscriptionType:(NSString *)subscriptionType {
    [self setMetaString:subscriptionType forKey:bSubscriptionTypeKey];
}

-(bSubscriptionType) subscriptionType {
    NSString * type = [self metaStringForKey:bSubscriptionTypeKey];
    
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

@end
