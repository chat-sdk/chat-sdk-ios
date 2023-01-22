//
//  BLocationManager.m
//  Pods
//
//  Created by Simon Smiley-Andrews on 27/07/2015.
//
//

#import "BLocationManager.h"
#import "GeoFire.h"
#import "Firebase+Paths.h"
#import "BGeoFireManager.h"
#import <RXPromise/RXPromise.h>


#define bLocationKey @"location"

@implementation BLocationManager

-(CLLocationManager *)lazyLocationManager {
    if(!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
        
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status != kCLAuthorizationStatusAuthorizedAlways &&
            [locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [locationManager requestAlwaysAuthorization];
        }
        
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return locationManager;
}

- (RXPromise *) updateLocation {
    if (!_locationUpdatedPromise) {
        _locationUpdatedPromise = [RXPromise new];
        [self.lazyLocationManager startUpdatingLocation];
    }
    return _locationUpdatedPromise;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if(locationManager) {

        [locationManager stopUpdatingLocation];
        CLLocation * currentLocation = locationManager.location;

        if (currentLocation) {
            _location = currentLocation;
        }
        
        if (_locationUpdatedPromise) {
            [_locationUpdatedPromise resolveWithResult:_location];
        }
        _locationUpdatedPromise = Nil;
        
        // Location manager must be set to nil after its location has been used else the location sent is nil
        locationManager = nil;
    }
}

- (CLLocation *) currentLocation {
    return _location;
}

@end
