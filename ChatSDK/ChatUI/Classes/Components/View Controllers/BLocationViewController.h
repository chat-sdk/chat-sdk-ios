//
//  BLocationViewController.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 16/04/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface BLocationViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, readwrite) MKCoordinateRegion region;
@property (nonatomic, readwrite) MKPointAnnotation * annotation;

@end
