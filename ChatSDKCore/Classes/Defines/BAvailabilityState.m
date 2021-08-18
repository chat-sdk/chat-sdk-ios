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
    return @[@[[NSBundle t:bAvailable], bAvailabilityStateChat, bAvailabilityStateAvailable],
             @[[NSBundle t:bAway], bAvailabilityStateAway],
             @[[NSBundle t:bExtendedAway], bAvailabilityStateExtendedAway],
             @[[NSBundle t:bBusy], bAvailabilityStateBusy]];
}

+(NSString *) titleForKey: (NSString *) key {
    for (NSArray * array in self.options) {
        for (int i = 1; i < array.count; i++) {
            if ([array[i] isEqual:key]) {
                return array.firstObject;
            }
        }
    }
    return Nil;
}


@end
