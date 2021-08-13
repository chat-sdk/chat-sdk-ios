//
//  BGeoFireManager.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 22/03/2016.
//
//

#import <Foundation/Foundation.h>

#import <ChatSDK/PNearbyUsersHandler.h>
#import "PNearbyUsersListener.h"
#import "BLocationManager.h"
#import "GeoFire.h"

@class BLocationManager;
@class BGeoItem;

@interface BGeoFireManager : NSObject<PNearbyUsersHandler> {
    BOOL _isOn;
    
    // GeoFire location query - this is the object we add or remove listeners from
    GFCircleQuery * _circleQuery;
    CLLocation * _location;
    NSMutableArray * _listeners;
    NSMutableArray * _events;
    NSMutableArray * _items;
}

@property (nonatomic, readonly) CLLocation * location;

+(BGeoFireManager *) sharedManager;
-(BOOL) addItemAtCurrentLocation: (BGeoItem *) item removeOnDisconnect: (BOOL) removeOnDisconnect;
-(BOOL) updateLocation: (CLLocation *) location;
-(RXPromise *) removeItem: (BGeoItem *) item;
-(NSArray *) events;
-(NSArray *) items;
-(void) stopListeningForItems;
-(void) resetLocation;

@end

