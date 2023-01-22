//
//  BLocationUpdater.m
//  AFNetworking
//
//  Created by Benjamin Smiley-Andrews on 08/04/2019.
//

#import "BLocationUpdater.h"
#import "NearbyUsers.h"
#import <ChatSDK/Core.h>

@implementation BLocationUpdater

#define bLocationUpdateTime 10

-(instancetype) init {
    if((self = [super init])) {
        
        _items = [NSMutableArray new];
        
        _locationManager = [[BLocationManager alloc] init];
        
        // When we come into the foreground make sure to force a location update
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:Nil queue:0 usingBlock:^(NSNotification * notification) {
            if (BChatSDK.auth.isAuthenticated) {
                [self startUpdatingLocation: YES];
            }
        }];
        

        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:Nil queue:0 usingBlock:^(NSNotification * notification) {
            [self stopUpdatingLocation];
        }];
        
        
        [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
            [self startUpdatingLocation: YES];
        }] withName:bHookDidAuthenticate];
        
        [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
            [self stopUpdatingLocation];
        }] withName:bHookWillLogout];

    }
    return self;
}

- (void)startUpdatingLocation {
    [self startUpdatingLocation:NO];
}

- (void)startUpdatingLocation: (BOOL) force {
    if (![self isUpdating]) {
        _locationTimer = [NSTimer scheduledTimerWithTimeInterval:bLocationUpdateTime
                                                          target:self
                                                        selector:@selector(updateLocation)
                                                        userInfo:nil
                                                         repeats:YES];
        [self updateLocation:force];
    }
}

- (void)stopUpdatingLocation {
    if (self.isUpdating) {
        [_locationTimer invalidate];
        _locationTimer = nil;
        for (id<PGeoItem> item in _items) {
            [[BGeoFireManager sharedManager] removeItem: item];
        }
    }
}

-(BOOL)isUpdating {
    return _locationTimer != Nil;
}

-(void) updateLocation {
    [self updateLocation: NO];
}

-(void) updateLocation: (BOOL) force {
    [_locationManager updateLocation].thenOnMain(^id(CLLocation * location) {
        if ([[BGeoFireManager sharedManager] updateLocation:_locationManager.currentLocation] || force) {
            for (id<PGeoItem> item in _items) {
                [[BGeoFireManager sharedManager] addItemAtCurrentLocation:item removeOnDisconnect:YES];
            }
        }
        return Nil;
    }, Nil);
}

-(CLLocation *) currentLocation {
    return _locationManager.currentLocation;
}

-(void) addItem: (BGeoItem *) item {
    if (![_items containsObject:item]) {
        [_items addObject:item];
        [self updateLocation: YES];
    }
}

-(void) removeItem: (BGeoItem *) item {
    [_items removeObject:item];
}

-(RXPromise *) reset {
    NSMutableArray * promises = [NSMutableArray new];
    for (id<PGeoItem> item in _items) {
        [promises addObject:[[BGeoFireManager sharedManager] removeItem: item]];
    }
    [_items removeAllObjects];
    if (promises.count) {
        return [RXPromise all:promises];
    } else {
        return [RXPromise resolveWithResult:Nil];
    }
}

@end
