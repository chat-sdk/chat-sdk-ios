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

@protocol PNearbyUsersDelegate <NSObject>

- (void)userAdded: (id<PUser>)user location: (CLLocation *)location;
- (void)userRemoved: (id<PUser>)user;
- (void)userMoved: (id<PUser>)user location: (CLLocation *)location;

@end

@protocol PNearbyUsersHandler <NSObject>

-(void) findNearbyUsersWithRadius: (double) radiusInMetres;

-(RXPromise *)startUpdatingUserLocation;
-(void)stopUpdatingUserLocation;
-(CLLocation *)getCurrentLocation;
-(void) setDelegate: (id<PNearbyUsersDelegate>) delegate;

@end

#endif /* PNearbyUsersHandler_h */
