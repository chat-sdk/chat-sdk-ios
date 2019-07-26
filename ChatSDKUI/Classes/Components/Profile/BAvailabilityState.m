//
//  BAvailabilityState.m
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 16/08/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import "BAvailabilityState.h"
#import <ChatSDK/Core.h>

@implementation BAvailabilityState

+(NSArray *) options {
    return @[@[[NSBundle t:bAvailable], bAvailabilityStateChat],
             @[[NSBundle t:bAway], bAvailabilityStateAway],
             @[[NSBundle t:bExtendedAway], bAvailabilityStateEntendedAway],
             @[[NSBundle t:bBusy], bAvailabilityStateBusy]];
}

+(NSString *) titleForKey: (NSString *) key {
    for (NSArray * array in self.options) {
        if ([array.lastObject isEqualToString:key]) {
            return array.firstObject;
        }
    }
    return Nil;
}


@end
