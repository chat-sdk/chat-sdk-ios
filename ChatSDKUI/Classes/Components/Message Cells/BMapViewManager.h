//
//  BMapViewManager.h
//  AFNetworking
//
//  Created by Ben on 3/16/18.
//

#import <Foundation/Foundation.h>

@class BMapViewWrapper;

@interface BMapViewManager : NSObject {
    NSMutableArray * _mapPool;
}

+(BMapViewManager *) sharedManager;
-(BMapViewWrapper *) mapFromPool;
-(void) returnToPool: (BMapViewWrapper *) map;

@end
