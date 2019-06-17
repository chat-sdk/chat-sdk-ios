//
//  BSyncDataPusher.h
//  ChatSDK Demo
//
//  Created by Ben on 12/4/17.
//  Copyright © 2017 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PUser;
@class RXPromise;
@class BSyncItem;

@interface BSyncDataPusher : NSObject

-(RXPromise *) addItem: (BSyncItem *) item toUser: (id<PUser>) user;
-(RXPromise *) addItem: (BSyncItem *) item toUser: (id<PUser>) user pushItem: (BOOL) pushItem;
-(RXPromise *) removeItem: (BSyncItem *) item fromUser: (id<PUser>) user;

@end
