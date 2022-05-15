//
//  GFGeoHash.h
//  GeoFire
//
//  Created by Jonny Dimond on 7/3/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define GF_DEFAULT_PRECISION 10
#define GF_MAX_PRECISION 22

@interface GFGeoHash : NSObject

@property (nonatomic, strong, readonly) NSString *geoHashValue;

- (id)initWithLocation:(CLLocationCoordinate2D)location;
- (id)initWithLocation:(CLLocationCoordinate2D)location precision:(NSUInteger)precision;

+ (GFGeoHash *)newWithLocation:(CLLocationCoordinate2D)location;
+ (GFGeoHash *)newWithLocation:(CLLocationCoordinate2D)location precision:(NSUInteger)precision;

- (id)initWithString:(NSString *)string;
+ (GFGeoHash *)newWithString:(NSString *)string;

+ (BOOL)isValidGeoHash:(NSString *)hash;

@end
