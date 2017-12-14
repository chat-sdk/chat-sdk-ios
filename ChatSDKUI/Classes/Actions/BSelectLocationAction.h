//
//  BSelectLocationAction.h
//  AFNetworking
//
//  Created by Ben on 12/11/17.
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PAction.h>
#import <CoreLocation/CoreLocation.h>

@protocol CLLocationManagerDelegate;

@interface BSelectLocationAction : NSObject<PAction, CLLocationManagerDelegate> {
    CLLocationManager * _locationManager;
    RXPromise * _promise;
}

@end
