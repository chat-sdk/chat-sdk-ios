//
//  BLocationOption.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 17/12/2016.
//
//

#import <ChatSDK/BChatOption.h>

@class CLLocationManager;
@class RXPromise;
@protocol CLLocationManagerDelegate;

@interface BLocationChatOption : BChatOption<CLLocationManagerDelegate> {
    CLLocationManager * _locationManager;
    RXPromise * _promise;
}

@end
