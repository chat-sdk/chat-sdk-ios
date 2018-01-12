//
//  BSyncDataListener.h
//  ChatSDK Demo
//
//  Created by Ben on 12/4/17.
//  Copyright © 2017 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSyncItemDelegate.h"

@class BSyncItem;

@protocol BSyncDataListener <BSyncItemDelegate>
    
@optional
-(void) itemAdded: (BSyncItem *) item;
-(void) itemRemoved: (BSyncItem *) item;

@end
