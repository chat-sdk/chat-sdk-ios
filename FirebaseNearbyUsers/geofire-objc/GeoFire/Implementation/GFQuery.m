//
//  GFQuery.m
//  GeoFire
//
//  Created by Jonny Dimond on 7/3/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import <ChatSDKFirebase/FirebaseAdapter.h>

#import "GFQuery.h"
#import "GFRegionQuery.h"
#import "GFCircleQuery.h"
#import "GFQuery+Private.h"
#import "GeoFire.h"
#import "GeoFire+Private.h"
#import "GFGeoHashQuery.h"


@interface GFQueryLocationInfo : NSObject

@property (nonatomic) BOOL isInQuery;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) GFGeoHash *geoHash;

@end

@implementation GFQueryLocationInfo
@end

@interface GFGeoHashQueryHandle : NSObject

@property (nonatomic) FirebaseHandle childAddedHandle;
@property (nonatomic) FirebaseHandle childRemovedHandle;
@property (nonatomic) FirebaseHandle childChangedHandle;

@end

@implementation GFGeoHashQueryHandle

@end

@interface GFCircleQuery ()

@property (nonatomic, strong) CLLocation *centerLocation;

@end

@implementation GFCircleQuery

@synthesize radius = _radius;

- (id)initWithGeoFire:(GeoFire *)geoFire
             location:(CLLocation *)location
               radius:(double)radius
{
    self = [super initWithGeoFire:geoFire];
    if (self != nil) {
        if (!CLLocationCoordinate2DIsValid(location.coordinate)) {
            [NSException raise:NSInvalidArgumentException
                        format:@"Not a valid geo location: [%f,%f]",
             location.coordinate.latitude, location.coordinate.longitude];
        }
        _centerLocation = location;
        _radius = radius;
    }
    return self;
}

- (void)setCenter:(CLLocation *)center
{
    @synchronized(self) {
        if (!CLLocationCoordinate2DIsValid(center.coordinate)) {
            [NSException raise:NSInvalidArgumentException
                        format:@"Not a valid geo location: [%f,%f]",
             center.coordinate.latitude, center.coordinate.longitude];
        }
        _centerLocation = center;
        [self searchCriteriaDidChange];
    }
}

- (CLLocation *)center
{
    @synchronized(self) {
        return self.centerLocation;
    }
}

- (void)setRadius:(double)radius
{
    @synchronized(self) {
        _radius = radius;
        [self searchCriteriaDidChange];
    }
}

- (double)radius
{
    @synchronized(self) {
        return _radius;
    }
}

- (BOOL)locationIsInQuery:(CLLocation *)location
{
    return [location distanceFromLocation:self.centerLocation] <= (self.radius * 1000);
}

- (NSSet *)queriesForCurrentCriteria
{
    return [GFGeoHashQuery queriesForLocation:self.centerLocation.coordinate radius:(self.radius * 1000)];
}

@end

@interface GFRegionQuery ()

@end

@implementation GFRegionQuery

@synthesize region = _region;

- (id)initWithGeoFire:(GeoFire *)geoFire
               region:(MKCoordinateRegion)region;
{
    self = [super initWithGeoFire:geoFire];
    if (self != nil) {
        _region = region;
    }
    return self;
}

- (void)setRegion:(MKCoordinateRegion)region
{
    @synchronized(self) {
        _region = region;
        [self searchCriteriaDidChange];
    }
}

- (MKCoordinateRegion)region
{
    @synchronized(self) {
        return _region;
    }
}

- (BOOL)locationIsInQuery:(CLLocation *)location
{
    MKCoordinateRegion region = self.region;
    CLLocationDegrees north = region.center.latitude + region.span.latitudeDelta/2;
    CLLocationDegrees south = region.center.latitude - region.span.latitudeDelta/2;
    CLLocationDegrees west = region.center.longitude - region.span.longitudeDelta/2;
    CLLocationDegrees east = region.center.longitude + region.span.longitudeDelta/2;

    CLLocationCoordinate2D coordinate = location.coordinate;
    return (coordinate.latitude <= north && coordinate.latitude >= south &&
            coordinate.longitude >= west && coordinate.longitude <= east);
}

- (NSSet *)queriesForCurrentCriteria
{
    return [GFGeoHashQuery queriesForRegion:self.region];
}

@end


@interface GFQuery ()

@property (nonatomic, strong) NSMutableDictionary *locationInfos;
@property (nonatomic, strong) GeoFire *geoFire;
@property (nonatomic, strong) NSSet *queries;
@property (nonatomic, strong) NSMutableDictionary *firebaseHandles;
@property (nonatomic, strong) NSMutableSet *outstandingQueries;

@property (nonatomic, strong) NSMutableDictionary *keyEnteredObservers;
@property (nonatomic, strong) NSMutableDictionary *keyExitedObservers;
@property (nonatomic, strong) NSMutableDictionary *keyMovedObservers;
@property (nonatomic, strong) NSMutableDictionary *readyObservers;
@property (nonatomic) NSUInteger currentHandle;

@end

@implementation GFQuery

- (id)initWithGeoFire:(GeoFire *)geoFire
{
    self = [super init];
    if (self != nil) {
        _geoFire = geoFire;
        _currentHandle = 1;
        [self reset];
    }
    return self;
}

- (FIRDatabaseQuery *)firebaseForGeoHashQuery:(GFGeoHashQuery *)query
{
    return [[[self.geoFire.firebaseRef queryOrderedByChild:@"g"] queryStartingAtValue:query.startValue]
            queryEndingAtValue:query.endValue];
}

- (void)updateLocationInfo:(CLLocation *)location
                    forKey:(NSString *)key
{
    NSAssert(location != nil, @"Internal Error! Location must not be nil!");
    GFQueryLocationInfo *info = self.locationInfos[key];
    BOOL isNew = NO;
    if (info == nil) {
        isNew = YES;
        info = [[GFQueryLocationInfo alloc] init];
        self.locationInfos[key] = info;
    }
    BOOL changedLocation = !(info.location.coordinate.latitude == location.coordinate.latitude &&
                             info.location.coordinate.longitude == location.coordinate.longitude);
    BOOL wasInQuery = info.isInQuery;

    info.location = location;
    info.isInQuery = [self locationIsInQuery:location];
    info.geoHash = [GFGeoHash newWithLocation:location.coordinate];

    if ((isNew || !wasInQuery) && info.isInQuery) {
        [self.keyEnteredObservers enumerateKeysAndObjectsUsingBlock:^(id observerKey,
                                                                      GFQueryResultBlock block,
                                                                      BOOL *stop) {
            dispatch_async(self.geoFire.callbackQueue, ^{
                block(key, info.location);
            });
        }];
    } else if (!isNew && changedLocation && info.isInQuery) {
        [self.keyMovedObservers enumerateKeysAndObjectsUsingBlock:^(id observerKey,
                                                                    GFQueryResultBlock block,
                                                                    BOOL *stop) {
            dispatch_async(self.geoFire.callbackQueue, ^{
                block(key, info.location);
            });
        }];
    } else if (wasInQuery && !info.isInQuery) {
        [self.keyExitedObservers enumerateKeysAndObjectsUsingBlock:^(id observerKey,
                                                                     GFQueryResultBlock block,
                                                                     BOOL *stop) {
            dispatch_async(self.geoFire.callbackQueue, ^{
                block(key, info.location);
            });
        }];
    }
}

- (BOOL)queriesContainGeoHash:(GFGeoHash *)geoHash
{
    for (GFGeoHashQuery *query in self.queries) {
        if ([query containsGeoHash:geoHash]) {
            return YES;
        }
    }
    return NO;
}

- (void)childAdded:(FIRDataSnapshot *)snapshot
{
    @synchronized(self) {
        CLLocation *location = [GeoFire locationFromValue:snapshot.value];
        if (location != nil) {
            [self updateLocationInfo:location forKey:snapshot.key];
        } else {
            // TODO: error?
        }
    }
}

- (void)childChanged:(FIRDataSnapshot *)snapshot
{
    @synchronized(self) {
        CLLocation *location = [GeoFire locationFromValue:snapshot.value];
        if (location != nil) {
            [self updateLocationInfo:location forKey:snapshot.key];
        } else {
            // TODO: error?
        }
    }
}

- (void)childRemoved:(FIRDataSnapshot *)snapshot
{
    @synchronized(self) {
        NSString *key = snapshot.key;
        GFQueryLocationInfo *info = self.locationInfos[snapshot.key];
        if (info != nil) {
            [[self.geoFire firebaseRefForLocationKey:snapshot.key] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
                @synchronized(self) {
                    CLLocation *location = [GeoFire locationFromValue:snapshot.value];
                    GFGeoHash *geoHash = (location) ? [[GFGeoHash alloc] initWithLocation:location.coordinate] : nil;
                    // Only notify observers if key is not part of any other geohash query or this actually might not be
                    // a key exited event, but a key moved or entered event. These events will be triggered by updates
                    // to a different query
                    if (![self queriesContainGeoHash:geoHash]) {
                        GFQueryLocationInfo *info = self.locationInfos[key];
                        [self.locationInfos removeObjectForKey:key];
                        // Key was in query, notify about key exited
                        if (info.isInQuery) {
                            [self.keyExitedObservers enumerateKeysAndObjectsUsingBlock:^(id observerKey,
                                                                                         GFQueryResultBlock block,
                                                                                         BOOL *stop) {
                                dispatch_async(self.geoFire.callbackQueue, ^{
                                    block(key, location);
                                });
                            }];
                        }
                    }
                }
            }];
        }
    }
}

- (BOOL)locationIsInQuery:(CLLocation *)location
{
    [NSException raise:NSInternalInconsistencyException format:@"GFQuery is abstract, please implement locationIsInQuery:"];
    return NO;
}

- (NSSet *)queriesForCurrentCriteria
{
    [NSException raise:NSInternalInconsistencyException format:@"GFQuery is abstract, please implement queriesForCurrentCriteria"];
    return nil;
}

- (void)searchCriteriaDidChange
{
    if (self.queries != nil) {
        [self updateQueries];
    }
}

- (void)checkAndFireReadyEvent
{
    if (self.outstandingQueries.count == 0) {
        [self.readyObservers enumerateKeysAndObjectsUsingBlock:^(id key, GFReadyBlock block, BOOL *stop) {
            dispatch_async(self.geoFire.callbackQueue, block);
        }];
    }
}

- (void)updateQueries
{
    NSSet *oldQueries = self.queries;
    NSSet *newQueries = [self queriesForCurrentCriteria];
    NSMutableSet *toDelete = [NSMutableSet setWithSet:oldQueries];
    [toDelete minusSet:newQueries];
    NSMutableSet *toAdd = [NSMutableSet setWithSet:newQueries];
    [toAdd minusSet:oldQueries];
    [toDelete enumerateObjectsUsingBlock:^(GFGeoHashQuery *query, BOOL *stop) {
        GFGeoHashQueryHandle *handle = self.firebaseHandles[query];
        if (handle == nil) {
            [NSException raise:NSInternalInconsistencyException
                        format:@"Wanted to remove a geohash query that was not registered!"];
        }
        FIRDatabaseQuery *queryFirebase = [self firebaseForGeoHashQuery:query];
        [queryFirebase removeObserverWithHandle:handle.childAddedHandle];
        [queryFirebase removeObserverWithHandle:handle.childChangedHandle];
        [queryFirebase removeObserverWithHandle:handle.childRemovedHandle];
        [self.firebaseHandles removeObjectForKey:handle];
        [self.outstandingQueries removeObject:query];
    }];
    [toAdd enumerateObjectsUsingBlock:^(GFGeoHashQuery *query, BOOL *stop) {
        [self.outstandingQueries addObject:query];
        GFGeoHashQueryHandle *handle = [[GFGeoHashQueryHandle alloc] init];
        FIRDatabaseQuery *queryFirebase = [self firebaseForGeoHashQuery:query];
        handle.childAddedHandle = [queryFirebase observeEventType:FIRDataEventTypeChildAdded
                                                        withBlock:^(FIRDataSnapshot *snapshot) {
                                                            [self childAdded:snapshot];
                                                        }];
        handle.childChangedHandle = [queryFirebase observeEventType:FIRDataEventTypeChildChanged
                                                          withBlock:^(FIRDataSnapshot *snapshot) {
                                                              [self childChanged:snapshot];
                                                          }];
        handle.childRemovedHandle = [queryFirebase observeEventType:FIRDataEventTypeChildRemoved
                                                          withBlock:^(FIRDataSnapshot *snapshot) {
                                                              [self childRemoved:snapshot];
                                                          }];
        [queryFirebase observeSingleEventOfType:FIRDataEventTypeValue
                                      withBlock:^(FIRDataSnapshot *snapshot) {
                                          @synchronized(self) {
                                              [self.outstandingQueries removeObject:query];
                                              [self checkAndFireReadyEvent];
                                          }
                                      }];
        self.firebaseHandles[query] = handle;
    }];
    self.queries = newQueries;
    [self.locationInfos enumerateKeysAndObjectsUsingBlock:^(id key, GFQueryLocationInfo *info, BOOL *stop) {
        [self updateLocationInfo:info.location forKey:key];
    }];
    NSMutableArray *oldLocations = [NSMutableArray array];
    [self.locationInfos enumerateKeysAndObjectsUsingBlock:^(id key, GFQueryLocationInfo *info, BOOL *stop) {
        if (![self queriesContainGeoHash:info.geoHash]) {
            [oldLocations addObject:key];
        }
    }];
    [self.locationInfos removeObjectsForKeys:oldLocations];

    [self checkAndFireReadyEvent];
}

- (void)reset
{
    for (GFGeoHashQuery *query in self.queries) {
        GFGeoHashQueryHandle *handle = self.firebaseHandles[query];
        if (handle == nil) {
            [NSException raise:NSInternalInconsistencyException
                        format:@"Wanted to remove a geohash query that was not registered!"];
        }
        FIRDatabaseQuery *queryFirebase = [self firebaseForGeoHashQuery:query];
        [queryFirebase removeObserverWithHandle:handle.childAddedHandle];
        [queryFirebase removeObserverWithHandle:handle.childChangedHandle];
        [queryFirebase removeObserverWithHandle:handle.childRemovedHandle];
    }
    self.firebaseHandles = [NSMutableDictionary dictionary];
    self.queries = nil;
    self.outstandingQueries = [NSMutableSet set];
    self.keyEnteredObservers = [NSMutableDictionary dictionary];
    self.keyExitedObservers = [NSMutableDictionary dictionary];
    self.keyMovedObservers = [NSMutableDictionary dictionary];
    self.readyObservers = [NSMutableDictionary dictionary];
    self.locationInfos = [NSMutableDictionary dictionary];
}

- (void)removeAllObservers
{
    @synchronized(self) {
        [self reset];
    }
}

- (void)removeObserverWithFirebaseHandle:(FirebaseHandle)firebaseHandle
{
    @synchronized(self) {
        NSNumber *handle = [NSNumber numberWithUnsignedInteger:firebaseHandle];
        [self.keyEnteredObservers removeObjectForKey:handle];
        [self.keyExitedObservers removeObjectForKey:handle];
        [self.keyMovedObservers removeObjectForKey:handle];
        [self.readyObservers removeObjectForKey:handle];
        if ([self totalObserverCount] == 0) {
            [self reset];
        }
    }
}

- (NSUInteger)totalObserverCount
{
    return (self.keyEnteredObservers.count +
            self.keyExitedObservers.count +
            self.keyMovedObservers.count +
            self.readyObservers.count);
}

- (FirebaseHandle)observeEventType:(GFEventType)eventType withBlock:(GFQueryResultBlock)block
{
    @synchronized(self) {
        if (block == nil) {
            [NSException raise:NSInvalidArgumentException format:@"Block is not allowed to be nil!"];
        }
        FirebaseHandle firebaseHandle = self.currentHandle++;
        NSNumber *numberHandle = [NSNumber numberWithUnsignedInteger:firebaseHandle];
        switch (eventType) {
            case GFEventTypeKeyEntered: {
                [self.keyEnteredObservers setObject:[block copy]
                                             forKey:numberHandle];
                self.currentHandle++;
                dispatch_async(self.geoFire.callbackQueue, ^{
                    @synchronized(self) {
                        [self.locationInfos enumerateKeysAndObjectsUsingBlock:^(NSString *key,
                                                                                GFQueryLocationInfo *info,
                                                                                BOOL *stop) {
                            if (info.isInQuery) {
                                block(key, info.location);
                            }
                        }];
                    };
                });
                break;
            }
            case GFEventTypeKeyExited: {
                [self.keyExitedObservers setObject:[block copy]
                                            forKey:numberHandle];
                self.currentHandle++;
                break;
            }
            case GFEventTypeKeyMoved: {
                [self.keyMovedObservers setObject:[block copy]
                                           forKey:numberHandle];
                self.currentHandle++;
                break;
            }
            default: {
                [NSException raise:NSInvalidArgumentException format:@"Event type was not a GFEventType!"];
                break;
            }
        }
        if (self.queries == nil) {
            [self updateQueries];
        }
        return firebaseHandle;
    }
}

- (FirebaseHandle)observeReadyWithBlock:(GFReadyBlock)block
{
    @synchronized(self) {
        if (block == nil) {
            [NSException raise:NSInvalidArgumentException format:@"Block is not allowed to be nil!"];
        }
        FirebaseHandle firebaseHandle = self.currentHandle++;
        NSNumber *numberHandle = [NSNumber numberWithUnsignedInteger:firebaseHandle];
        [self.readyObservers setObject:[block copy] forKey:numberHandle];
        if (self.queries == nil) {
            [self updateQueries];
        }
        if (self.outstandingQueries.count == 0) {
            dispatch_async(self.geoFire.callbackQueue, block);
        }
        return firebaseHandle;
    }
}

@end
