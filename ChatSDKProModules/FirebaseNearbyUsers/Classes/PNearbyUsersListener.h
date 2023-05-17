//
//  PNearbyUsersDelegate.h
//  Pods
//
//  Created by Benjamin Smiley-Andrews on 08/04/2019.
//

#ifndef PNearbyUsersListener_h
#define PNearbyUsersListener_h

#import "BGeoEventType.h"
#import <ChatSDK/PGeoItem.h>

@class BGeoEvent;

@protocol PNearbyUsersListener <NSObject>

-(void) event: (BGeoEvent *) event;

@end

#endif /* PNearbyUsersListener_h */
