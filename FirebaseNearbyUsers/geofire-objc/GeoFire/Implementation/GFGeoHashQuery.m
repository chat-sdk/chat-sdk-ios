//
//  GFGeoHashQuery.m
//  GeoFire
//
//  Created by Jonny Dimond on 7/7/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import "GFGeoHashQuery.h"

#import "GFBase32Utils.h"

// Length of a degree latitude at the equator
#define METERS_PER_DEGREE_LATITUDE ((double)110574)

// The equatorial circumference of the earth in meters
#define EARTH_MERIDIONAL_CIRCUMFERENCE ((double)40007860)

// The equatorial radius of the earth in meters
#define EARTH_EQ_RADIUS ((double)6378137)

// The following value assumes a polar radius of
// r_p = 6356752.3
// and an equatorial radius of
// r_e = 6378137
// The value is calculated as e2 == (r_e^2 - r_p^2)/(r_e^2)
// Use exact value to avoid rounding errors
#define E2 ((double)0.00669447819799)

// Number of bits per character in a geohash
#define BITS_PER_GEOHASH_CHAR 5

// The maximum number of bits in a geohash
#define MAXIMUM_BITS_PRECISION (22*(BITS_PER_GEOHASH_CHAR))

// Cutoff for floating point calculations
#define EPSILON ((double)1e-12)

#define DEGREES_TO_RADIANS(degs) ((degs)*M_PI/180)

#define BITS_PRECISION(precision) log2(precision), MAXIMUM_BITS_PRECISION)

@interface GFGeoHashQuery ()

@property (nonatomic, strong, readwrite) NSString *startValue;
@property (nonatomic, strong, readwrite) NSString *endValue;

@end

@implementation GFGeoHashQuery

- (id)initWithStartValue:(NSString *)startValue endValue:(NSString *)endValue
{
    self = [super init];
    if (self != nil) {
        self->_startValue = startValue;
        self->_endValue = endValue;
    }
    return self;
}

+ (GFGeoHashQuery *)newWithStartValue:(NSString *)startValue endValue:(NSString *)endValue
{
    return [[GFGeoHashQuery alloc] initWithStartValue:startValue endValue:endValue];
}

+ (double)bitsForLatitudeWithResolution:(double)resolution
{
    return log2(EARTH_MERIDIONAL_CIRCUMFERENCE/2/resolution);
}

+ (CLLocationDegrees)meters:(double)distance toLongitudeDegreesAtLatitude:(CLLocationDegrees)latitude
{
    double radians = DEGREES_TO_RADIANS(latitude);
    double numerator = cos(radians)*EARTH_EQ_RADIUS*M_PI/180;
    double denominator = 1/sqrt(1-E2*sin(radians)*sin(radians));
    double deltaDegrees = numerator*denominator;
    if (deltaDegrees < EPSILON) {
        return distance > 0 ? 360 : 0;
    } else {
        return fmin(360, distance/deltaDegrees);
    }
}

+ (double)bitsForLongitudeWithResolution:(double)resolution atLatitude:(CLLocationDegrees)latitude
{
    double degrees = [GFGeoHashQuery meters:resolution toLongitudeDegreesAtLatitude:latitude];
    return (fabs(degrees) > 0) ? log2(360/degrees) : 1;
}

+ (CLLocationDegrees)wrapLongitude:(CLLocationDegrees)longitude
{
    if (longitude >= -180 && longitude <= 180) {
        return longitude;
    }
    double adjusted = longitude + 180;
    if (adjusted > 0) {
        return fmod(adjusted, 360) - 180;
    } else {
        return 180 - fmod(-adjusted, 360);
    }
}

+ (NSUInteger)bitsForBoundingBoxAtLocation:(CLLocationCoordinate2D)location withSize:(double)size
{
    double latitudeDegreesDelta = size/METERS_PER_DEGREE_LATITUDE;
    double latitudeNorth = fmin(90, location.latitude + latitudeDegreesDelta);
    double latitudeSouth = fmax(-90, location.latitude - latitudeDegreesDelta);
    NSUInteger bitsLatitude = MAX(0, (int)floor([GFGeoHashQuery bitsForLatitudeWithResolution:size]))*2;
    double bitsNorth = [GFGeoHashQuery bitsForLongitudeWithResolution:size atLatitude:latitudeNorth];
    double bitsSouth = [GFGeoHashQuery bitsForLongitudeWithResolution:size atLatitude:latitudeSouth];
    NSUInteger bitsLongitudeNorth = MAX(1, (int)floor(bitsNorth))*2-1;
    NSUInteger bitsLongitudeSouth = MAX(1, (int)floor(bitsSouth))*2-1;
    return MIN(bitsLatitude, MIN(bitsLongitudeNorth, MIN(bitsLongitudeSouth, MAXIMUM_BITS_PRECISION)));
}

+ (NSUInteger)bitsForRegion:(MKCoordinateRegion)region
{
    NSUInteger bitsLatitude = MAX(0, (int)floor(log2(180/(region.span.latitudeDelta/2))))*2;
    NSUInteger bitsLongitude = MAX(1, (int)floor(log2(360/(region.span.longitudeDelta/2))))*2-1;
    return MIN(bitsLatitude, MIN(bitsLongitude, MAXIMUM_BITS_PRECISION));
}

+ (GFGeoHashQuery *)geoHashQueryWithGeoHash:(GFGeoHash *)geohash bits:(NSUInteger)bits
{
    NSString *hash = geohash.geoHashValue;
    NSUInteger precision = ((bits-1)/BITS_PER_GEOHASH_CHAR)+1;
    if (hash.length < precision) {
        return [GFGeoHashQuery newWithStartValue:hash endValue:[NSString stringWithFormat:@"%@~", hash]];
    }
    hash = [hash substringToIndex:precision];
    NSString *base = [hash substringToIndex:hash.length-1];
    NSUInteger lastValue = [GFBase32Utils base32CharacterToValue:(char)[hash characterAtIndex:hash.length-1]];
    NSUInteger significantBits = bits - (base.length*BITS_PER_BASE32_CHAR);
    NSUInteger unusedBits = (BITS_PER_BASE32_CHAR - significantBits);
    // delete unused bits
    NSUInteger startValue = (lastValue >> unusedBits) << unusedBits;
    NSUInteger endValue = startValue + (1 << unusedBits);
    NSString *startHash = [NSString stringWithFormat:@"%@%c", base, [GFBase32Utils valueToBase32Character:startValue]];
    NSString *endHash;
    if (endValue > 31) {
        endHash = [NSString stringWithFormat:@"%@~", base];
    } else {
        endHash = [NSString stringWithFormat:@"%@%c", base, [GFBase32Utils valueToBase32Character:endValue]];
    }
    return [GFGeoHashQuery newWithStartValue:startHash endValue:endHash];
}

+ (NSSet *)joinQueries:(NSSet *)set
{
    NSMutableSet *queries = [NSMutableSet setWithSet:set];
    // Join queries
    BOOL didJoin;
    do {
        GFGeoHashQuery *query1 = nil;
        GFGeoHashQuery *query2 = nil;
        for (GFGeoHashQuery *query in queries) {
            for (GFGeoHashQuery *other in queries) {
                if (query != other && [query canJoinWith:other]) {
                    query1 = query;
                    query2 = other;
                }
            }
        }
        if (query1 != nil && query2 != nil) {
            [queries removeObject:query1];
            [queries removeObject:query2];
            [queries addObject:[query1 joinWith:query2]];
            didJoin = YES;
        } else {
            didJoin = NO;
        }
    } while (didJoin);

    return queries;
}

+ (NSSet *)queriesForRegion:(MKCoordinateRegion)region
{
    NSUInteger bits = [GFGeoHashQuery bitsForRegion:region];
    NSUInteger geoHashPrecision = ((bits-1)/BITS_PER_GEOHASH_CHAR)+1;
    NSMutableSet *queries = [NSMutableSet set];
    void (^addQuery)(CLLocationDegrees, CLLocationDegrees) = ^(CLLocationDegrees lat, CLLocationDegrees lng) {
        GFGeoHash *geoHash = [GFGeoHash newWithLocation:CLLocationCoordinate2DMake(lat, lng)
                                              precision:geoHashPrecision];
        [queries addObject:[GFGeoHashQuery geoHashQueryWithGeoHash:geoHash bits:bits]];
    };
    CLLocationDegrees latitudeCenter = region.center.latitude;
    CLLocationDegrees latitudeNorth = region.center.latitude + region.span.latitudeDelta/2;
    CLLocationDegrees latitudeSouth = region.center.latitude - region.span.latitudeDelta/2;
    CLLocationDegrees longitudeCenter = region.center.longitude;
    CLLocationDegrees longitudeWest = [GFGeoHashQuery
                                       wrapLongitude:(region.center.longitude - region.span.longitudeDelta/2)];
    CLLocationDegrees longitudeEast = [GFGeoHashQuery
                                       wrapLongitude:(region.center.longitude + region.span.longitudeDelta/2)];

    addQuery(latitudeCenter, longitudeCenter);
    addQuery(latitudeCenter, longitudeEast);
    addQuery(latitudeCenter, longitudeWest);

    addQuery(latitudeNorth, longitudeCenter);
    addQuery(latitudeNorth, longitudeEast);
    addQuery(latitudeNorth, longitudeWest);

    addQuery(latitudeSouth, longitudeCenter);
    addQuery(latitudeSouth, longitudeEast);
    addQuery(latitudeSouth, longitudeWest);

    return [GFGeoHashQuery joinQueries:queries];
}

+ (NSSet *)queriesForLocation:(CLLocationCoordinate2D)center radius:(double)radius
{
    CLLocationDegrees latitudeDelta = radius/METERS_PER_DEGREE_LATITUDE;
    CLLocationDegrees latitudeNorth = fmin(90, center.latitude + latitudeDelta);
    CLLocationDegrees latitudeSouth = fmax(-90, center.latitude - latitudeDelta);
    CLLocationDegrees longitudeDeltaNorth = [GFGeoHashQuery meters:radius toLongitudeDegreesAtLatitude:latitudeNorth];
    CLLocationDegrees longitudeDeltaSouth = [GFGeoHashQuery meters:radius toLongitudeDegreesAtLatitude:latitudeSouth];
    CLLocationDegrees longitudeDelta = fmax(longitudeDeltaNorth, longitudeDeltaSouth);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, MKCoordinateSpanMake(latitudeDelta*2, longitudeDelta*2));
    return [GFGeoHashQuery queriesForRegion:region];
}

- (BOOL)isPrefixTo:(GFGeoHashQuery *)other
{
    return ([self.endValue compare:other.startValue] != NSOrderedAscending &&
            [self.startValue compare:other.startValue] == NSOrderedAscending &&
            [self.endValue compare:other.endValue] == NSOrderedAscending);
}

- (BOOL)isSuperQueryOf:(GFGeoHashQuery *)other
{
    NSComparisonResult start = [self.startValue compare:other.startValue];
    if (start == NSOrderedSame || start == NSOrderedAscending) {
        NSComparisonResult end = [self.endValue compare:other.endValue];
        return (end == NSOrderedSame || end == NSOrderedDescending);
    } else {
        return NO;
    }
}

- (BOOL)canJoinWith:(GFGeoHashQuery *)other
{
    return [self isPrefixTo:other] ||
           [other isPrefixTo:self] ||
           [self isSuperQueryOf:other] ||
           [other isSuperQueryOf:self];
}

- (GFGeoHashQuery *)joinWith:(GFGeoHashQuery *)other
{
    if ([self isPrefixTo:other]) {
        return [[GFGeoHashQuery alloc] initWithStartValue:self.startValue endValue:other.endValue];
    } else if ([other isPrefixTo:self]) {
        return [[GFGeoHashQuery alloc] initWithStartValue:other.startValue endValue:self.endValue];
    } else if ([self isSuperQueryOf:other]) {
        return self;
    } else if ([other isSuperQueryOf:self]) {
        return other;
    } else {
        return nil;
    }
}

- (BOOL)containsGeoHash:(GFGeoHash *)hash
{
    return [self.startValue isEqualToString:hash.geoHashValue] ||
           ([self.startValue compare:hash.geoHashValue] == NSOrderedAscending &&
            [self.endValue compare:hash.geoHashValue] == NSOrderedDescending);
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (![other isKindOfClass:[GFGeoHashQuery class]])
        return NO;
    if (![self.startValue isEqualToString:[other startValue]])
        return NO;
    return [self.endValue isEqualToString:[other endValue]];
}

- (NSUInteger)hash
{
    return [self.startValue hash]*31 + [self.endValue hash];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"GFGeoHashQuery: %@-%@", self.startValue, self.endValue];
}

@end
