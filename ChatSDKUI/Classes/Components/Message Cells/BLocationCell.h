//
//  BLocation.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 27/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import "BMessageCell.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BLocationCell : BMessageCell<BMessageDelegate>

@property (nonatomic, readwrite) MKMapView * mapView;

@end
