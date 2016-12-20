//
//  Header.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 24/08/2016.
//
//

#ifndef Header_h
#define Header_h

typedef enum {
    bSubscriptionTypeNone = 0x0,
    bSubscriptionTypeTo = 0x1,
    bSubscriptionTypeFrom = 0x2,
    bSubscriptionTypeBoth = bSubscriptionTypeTo | bSubscriptionTypeFrom,
} bSubscriptionType;

#endif /* Header_h */
