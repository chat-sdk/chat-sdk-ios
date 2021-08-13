//
//  BLocationUpdater.h
//  AFNetworking
//
//  Created by Benjamin Smiley-Andrews on 08/04/2019.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BLocationManager;
@class CLLocation;
@class BGeoItem;
@class RXPromise;

@interface BLocationUpdater : NSObject {
    NSTimer * _locationTimer;
    BLocationManager * _locationManager;
    NSMutableArray * _items;
}

-(instancetype) init: (NSArray *) items;
- (void) startUpdatingLocation;
- (void) stopUpdatingLocation;
-(CLLocation *) currentLocation;
-(void) addItem: (BGeoItem *) item;
-(void) removeItem: (BGeoItem *) item;
-(RXPromise *) reset;

@end

NS_ASSUME_NONNULL_END
