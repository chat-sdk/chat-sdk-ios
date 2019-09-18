//
//  PNearbyUsersDelegate.h
//  Pods
//
//  Created by Benjamin Smiley-Andrews on 08/04/2019.
//

#ifndef PNearbyUsersListener_h
#define PNearbyUsersListener_h

#import "BGeoEventType.h"
#import <ChatSDK/PGeoEvent.h>

@protocol PNearbyUsersListener <NSObject>

-(void) event: (id<PGeoEvent>) event;

@end

#endif /* PNearbyUsersListener_h */
