//
//  PNearbyUsersHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/12/2016.
//
//

#ifndef PNearbyUsersHandler_h
#define PNearbyUsersHandler_h

@class CLLocation;
@class RXPromise;
@protocol PUser;

#import <ChatSDK/PNearbyUsersListener.h>

@protocol PNearbyUsersHandler <NSObject>

-(CLLocation *) currentLocation;
-(void) addListener: (id<PNearbyUsersListener>) listener;
-(void) removeListener: (id<PNearbyUsersListener>) listener;

@end

#endif /* PNearbyUsersHandler_h */
