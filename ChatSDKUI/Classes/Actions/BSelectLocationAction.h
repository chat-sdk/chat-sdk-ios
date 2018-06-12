//
//  BSelectLocationAction.h
//  ChatSDK
//
//  Created by Ben on 12/11/17.
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PAction.h>
#import <CoreLocation/CoreLocation.h>
#import <ChatSDK/BLocationPickerController.h>

@protocol CLLocationManagerDelegate;

@interface BSelectLocationAction : NSObject<PAction, BLocationPickerControllerDelegate>

- (instancetype)initWithViewController:(UIViewController *)controller;

@end
