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

@interface BSyncDataFetcher : NSObject<BSyncItemDelegate> {
    NSMutableDictionary * _data;
    id<PUser> _user;
    NSMutableArray * _listeners;
}

@end
