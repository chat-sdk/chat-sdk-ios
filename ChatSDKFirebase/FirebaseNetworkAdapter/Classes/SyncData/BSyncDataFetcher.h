//
//  BLocalSyncData.h
//  ChatSDK Demo
//
//  Created by Ben on 12/4/17.
//  Copyright © 2017 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSyncItemDelegate.h"

@protocol PUser;
@protocol BSyncDataListener;

@interface BSyncDataFetcher : NSObject<BSyncItemDelegate> {
    NSMutableDictionary * _data;
    id<PUser> _user;
    NSMutableArray * _listeners;
    NSMutableDictionary * _pathsForItemTypes;
}

-(id) initWithUser: (id<PUser>) user;
-(void) pathOn: (NSString *) path;
-(void) pathOff: (NSString *) path;

-(void) addListener: (id<BSyncDataListener>) listener;
-(void) removeListener: (id<BSyncDataListener>) listener;

-(void) addItemType: (Class) type forPath:(NSString *) path;

-(NSMutableArray *) itemsForPath: (NSString *) path;
-(void) removeItemTypeWithPath: (NSString *) path;

@end
