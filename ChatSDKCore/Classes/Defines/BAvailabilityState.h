//
//  BAvailabilityState.h
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 16/08/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>

#define bAvailabilityStateChat @"chat"
#define bAvailabilityStateAvailable @"available"
#define bAvailabilityStateAway @"away"
#define bAvailabilityStateBusy @"dnd"
#define bAvailabilityStateEntendedAway @"xa"

@interface BAvailabilityState : NSObject

+(NSArray *) options;
+(NSString *) titleForKey: (NSString *) key;

@end
