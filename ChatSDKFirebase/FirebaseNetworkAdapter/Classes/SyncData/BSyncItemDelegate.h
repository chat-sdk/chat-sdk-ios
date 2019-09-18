//
//  BSyncItemDelegate.h
//  ChatSDK Demo
//
//  Created by Ben on 12/4/17.
//  Copyright © 2017 deluge. All rights reserved.
//

#ifndef BSyncItemDelegate_h
#define BSyncItemDelegate_h

@class BSyncItem;

@protocol BSyncItemDelegate <NSObject>

@optional
-(void) itemChanged: (BSyncItem *) item;

@end

#endif /* BSyncItemDelegate_h */
