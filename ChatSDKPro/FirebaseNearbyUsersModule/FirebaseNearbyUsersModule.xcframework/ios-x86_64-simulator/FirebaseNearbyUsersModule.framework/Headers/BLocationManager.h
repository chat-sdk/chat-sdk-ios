//
//  BLocationManager.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 27/07/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <ChatSDK/PUser.h>

@class RXPromise;

@interface BLocationManager : NSObject <CLLocationManagerDelegate> {
    
    CLLocationManager * locationManager;
    
    CLLocation * _location;
    RXPromise * _locationUpdatedPromise;
}


- (CLLocation *) currentLocation;
- (RXPromise *) updateLocation;

@end
