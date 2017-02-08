//
//  BLocation.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 27/09/2013.
//  Copyright (c) 2013 chatsdk.co All rights reserved. The Chat SDK is issued under the MIT liceense and is available for free at http://github.com/chat-sdk
//

#import "BMessageCell.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define bLocationMessageCell @"LocationMessageCell"

@interface BLocationCell : BMessageCell<BMessageDelegate>

@property (nonatomic, readwrite) MKMapView * mapView;

@end
