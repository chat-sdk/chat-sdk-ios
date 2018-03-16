//
//  BMapViewWrapper.m
//  AFNetworking
//
//  Created by Ben on 3/16/18.
//

#import "BMapViewWrapper.h"
#import <ChatSDK/BCoreUtilities.h>

@implementation BMapViewWrapper

@synthesize mapView;

-(instancetype) init {
    if ((self = [super init])) {
        mapView = [[MKMapView alloc] init];
        mapView.showsScale = NO;
        mapView.showsCompass = NO;
    }
    return self;
}

-(void) setLongitude: (float) longitude withLatitude: (float) latitude {
    CLLocationCoordinate2D coord;
    coord.longitude = longitude;
    coord.latitude = latitude;
    
    // Set the location and display the controller
    MKCoordinateRegion region = [BCoreUtilities regionForLongitude:coord.longitude latitude:coord.latitude];
    MKPointAnnotation * annotation = [BCoreUtilities annotationForLongitude:coord.longitude latitude:coord.latitude];

    [mapView setRegion:region animated:NO];
    [mapView addAnnotation:annotation];
    [mapView selectAnnotation:annotation animated:NO];

}

@end
