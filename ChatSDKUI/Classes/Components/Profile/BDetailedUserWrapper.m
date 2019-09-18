//
//  BDetailedUserWrapper.m
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 19/08/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import "BDetailedUserWrapper.h"

#define bLocalityKey @"locality"
#define bCountryKey @"country"

#import <ChatSDK/Core.h>

@implementation BDetailedUserWrapper

+(BDetailedUserWrapper *) wrapperWithUser:(id<PUser>)user {
    return [[self alloc] initWithUser:user];
}

-(id) initWithUser:(id<PUser>) user {
    if ((self = [self init])) {
        _user = user;
    }
    return self;
}

-(NSString *) locality {
    return [_user.meta metaStringForKey:bLocalityKey];
}

-(void) setLocality: (NSString *) locality {
    [_user setMetaValue:locality forKey:bLocalityKey];
}

-(NSString *) country {
    return [_user.meta metaStringForKey:bCountryKey];
}

-(void) setCountry: (NSString *) country {
    [_user setMetaValue:country forKey:bCountryKey];
}

@end
