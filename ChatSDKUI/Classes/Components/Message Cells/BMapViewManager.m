//
//  BMapViewManager.m
//  AFNetworking
//
//  Created by Ben on 3/16/18.
//

#import "BMapViewManager.h"
#import "BMapViewWrapper.h"

@implementation BMapViewManager

static BMapViewManager * manager;

+(BMapViewManager *) sharedManager {
    
    @synchronized(self) {
        
        // If the sharedSoundManager var is nil then we need to allocate it.
        if(manager == nil) {
            // Allocate and initialize an instance of this class
            manager = [[self alloc] init];
        }
    }
    return manager;
}

-(instancetype) init {
    if ((self = [super init])) {
        _mapPool = [NSMutableArray new];
    }
    return self;
}

-(BMapViewWrapper *) mapFromPool {
    for (BMapViewWrapper * m in _mapPool) {
        if (!m.inUse) {
            m.inUse = YES;
            return m;
        }
    }
    BMapViewWrapper * m = [[BMapViewWrapper alloc] init];
    m.inUse = YES;
    [_mapPool addObject:m];
    return m;
}

-(void) returnToPool: (BMapViewWrapper *) map {
    [map.mapView removeFromSuperview];
    map.inUse = NO;
}

@end
