//
//  BLocationOption.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 17/12/2016.
//
//

#import <ChatSDKUI/BChatOption.h>

#import <CoreLocation/CoreLocation.h>

@class RXPromise;
@protocol CLLocationManagerDelegate;

@interface BLocationChatOption : BChatOption<CLLocationManagerDelegate> {
    CLLocationManager * _locationManager;
    RXPromise * _promise;
}

@end
