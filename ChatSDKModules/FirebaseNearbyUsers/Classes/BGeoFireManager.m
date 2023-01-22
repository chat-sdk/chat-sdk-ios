//
//  BGeoFireManager.m
//  Pods
//
//  Created by Simon Smiley-Andrews on 22/03/2016.
//
//

#import "BGeoFireManager.h"

#import <ChatSDK/Core.h>
#import <ChatSDKFirebase/FirebaseAdapter.h>
#import "NearbyUsers.h"

@implementation BGeoFireManager

@synthesize location = _location;

static BGeoFireManager * manager;

+(BGeoFireManager *) sharedManager {
    
    @synchronized(self) {        
        // If the sharedSoundManager var is nil then we need to allocate it.
        if(manager == nil) {
            // Allocate and initialize an instance of this class
            manager = [[self alloc] init];
        }
    }
    
    
    return manager;
}

-(id) init {
    if ((self = [super init])) {
        
        _listeners = [NSMutableArray new];
        _events = [NSMutableArray new];
        _items = [NSMutableArray new];

        // Set the push key when authentication finishes
        BHook * logoutHook = [BHook hook:^(NSDictionary * data) {
            [self stopListeningForItems];
        }];
        [BChatSDK.hook addHook:logoutHook withName:bHookDidLogout];

        BHook * disconnectHook = [BHook hook:^(NSDictionary * data) {
            _location = Nil;
        }];
        [BChatSDK.hook addHook:disconnectHook withName:bHookUserWillDisconnect];


    }
    return self;
}

-(void) addListener: (id<PNearbyUsersListener>) listener {
    [_listeners addObject:listener];
}

-(void) removeListener: (id<PNearbyUsersListener>) listener {
    [_listeners removeObject:listener];
}

-(int) userCount {
    int i = 0;
    for (BGeoItem * item in _items) {
        if ([item typeIs:bGeoItemTypeUser] ) {
            if (![BChatSDK.currentUserID isEqual:item.entityID]) {
                i++;
            }
        }
    }
    return i;
}

- (BOOL) startListeningForItemsInRadius: (double) radiusInMetres {

    // Stop listening to the old location
    [self stopListeningForItems];
    
    if(_location) {
        NSString * currentUserEntityID = BChatSDK.currentUser.entityID;

        GeoFire * geoFire = [BGeoFireManager geoFireRef];

        // Set the search radius value to determine the search area
        _circleQuery = [geoFire queryAtLocation:_location withRadius:radiusInMetres/1000.0];
        
        [_circleQuery observeEventType:GFEventTypeKeyEntered withBlock:^(NSString * itemID, CLLocation *location) {
            NSLog(@"Item entered + %@", itemID);
            BGeoItem * item = [self itemForID:itemID location:location];
//            if (![_items containsObject:item]) {
//                [_items addObject:item];
//            }
            BGeoEvent * event = [BGeoEvent event:item withType:bGeoEventTypeEntered];
            [_events addObject:event];
            [self event:event];
        }];
        
        [_circleQuery observeEventType:GFEventTypeKeyExited withBlock:^(NSString * itemID, CLLocation *location) {
            BGeoItem * item = [self itemForID:itemID location:location];
            BGeoEvent * event = [BGeoEvent event:item withType:bGeoEventTypeExited];
            
            [_items removeObject:item];
            
            BGeoEvent * eventToRemove = Nil;
            for (BGeoEvent * e in _events) {
                if ([event.item isEqual:item]) {
                    eventToRemove = e;
                }
            }
            if (eventToRemove) {
                [_events removeObject:eventToRemove];
            }
            
            [self event:event];
        }];
        
        [_circleQuery observeEventType:GFEventTypeKeyMoved withBlock:^(NSString * itemID, CLLocation *location) {
            BGeoItem * item = [self itemForID:itemID location:location];
            BGeoEvent * event = [BGeoEvent event:item withType:bGeoEventTypeMoved];
            [self event:event];
        }];
        
        return YES;
    }
    return NO;
}

-(void) event: (BGeoEvent *) event {
    for (id<PNearbyUsersListener> listener in _listeners) {
        [listener event:event];
    }
}

-(BGeoItem *) itemForID: (NSString *) itemID location: (CLLocation *) location {
    BGeoItem * item = Nil;
    for (BGeoItem * theItem in _items) {
        if ([theItem.itemID isEqualToString:itemID]) {
            item = theItem;
            break;
        }
    }
    if (!item) {
        item = [BGeoItem item:itemID];
    }
    item.location = location;
    if (![_items containsObject:item]) {
        [_items addObject:item];
    }
    return item;
}

-(void) stopListeningForItems {
    [_circleQuery removeAllObservers];
    _circleQuery = Nil;
    [_items removeAllObjects];
    [_events removeAllObjects];
}

-(void) resetLocation {
    _location = nil;
}

-(BOOL) addItemAtCurrentLocation:(BGeoItem *) item removeOnDisconnect: (BOOL) removeOnDisconnect {
    if (_location) {
        [self addItem:item atLocation:_location removeOnDisconnect:removeOnDisconnect];
        return YES;
    }
    return NO;
}

-(void) addItem: (BGeoItem *) item atLocation: (CLLocation *) location removeOnDisconnect: (BOOL) removeOnDisconnect {
    GeoFire * geoFire = [BGeoFireManager geoFireRef];
    
    [geoFire setLocation:location forKey:item.itemID withCompletionBlock:^(NSError * error) {
        if (!error) {
            // Remove the value when we disconnect
            if (removeOnDisconnect) {
                [[[BGeoFireManager ref] child:item.itemID] onDisconnectRemoveValueWithCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
                    NSLog(@"Listener added");
                }];
            }
        }
    }];
}

-(NSArray *) events {
    return _events;
}

-(NSArray *) items {
    return _items;
}

-(NSArray *) usersNotMe {
    NSMutableArray * notMe = [NSMutableArray new];
    for (BGeoItem * item in _items) {
        if ([item typeIs:bGeoItemTypeUser] && ![BChatSDK.currentUserID isEqual:item.entityID]) {
            [notMe addObject:item];
        }
    }
    return notMe;
}

-(RXPromise *) removeItem: (BGeoItem *) item {
    RXPromise * promise = [RXPromise new];
    [[[BGeoFireManager ref] child: item.itemID] removeValueWithCompletionBlock:^(NSError * error, FIRDatabaseReference * ref) {
        if(!error) {
            [promise resolveWithResult:Nil];
        } else {
            [promise rejectWithReason:error];
        }
    }];
    return promise;
}

-(BOOL) updateLocation: (CLLocation *) location {
    if (_location && [_location distanceFromLocation:location] < BChatSDK.config.nearbyUsersMinimumLocationChangeToUpdateServer) {
        return NO;
    }
    _location = [location copy];
    NSLog(@"NearbyUsers: GeoFireManager _location %@ location %@", _location, location);
    [self startListeningForItemsInRadius:BChatSDK.config.nearbyUserDistanceBands.lastObject.doubleValue];
    return YES;
}

+(GeoFire *) geoFireRef {
    return [[GeoFire alloc] initWithFirebaseRef:[self ref]];
}

+(FIRDatabaseReference *) ref {
    return [[FIRDatabaseReference firebaseRef] child:bLocationPath];
}

-(CLLocation *) currentLocation {
    return _location;
}


@end
