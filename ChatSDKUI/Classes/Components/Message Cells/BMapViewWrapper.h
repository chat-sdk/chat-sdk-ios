//
//  BMapViewWrapper.h
//  AFNetworking
//
//  Created by Ben on 3/16/18.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BMapViewWrapper : NSObject

@property (nonatomic, readonly) MKMapView * mapView;
@property (nonatomic, readwrite) BOOL inUse;
-(void) setLongitude: (float) longitude withLatitude: (float) latitude;
@end
