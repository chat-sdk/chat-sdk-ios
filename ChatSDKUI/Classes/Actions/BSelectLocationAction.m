//
//  BSelectLocationAction.m
//  AFNetworking
//
//  Created by Ben on 12/11/17.
//

#import "BSelectLocationAction.h"
#import <ChatSDK/Core.h>

@implementation BSelectLocationAction

-(RXPromise *) execute {
    
    if(_promise) {
        return _promise;
    }
    else {
        _promise = [RXPromise new];
    }
    /*
    if(!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined &&
            [_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
        
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    [_locationManager startUpdatingLocation];
    */
    return _promise;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [manager stopUpdatingLocation];
    if(_locationManager) {
        _locationManager = nil;
        
        CLLocation * location = locations.lastObject;
        [_promise resolveWithResult:location];
    }
    if(_promise) {
        [_promise resolveWithResult: Nil];
    }
    _promise = Nil;
}

@end
