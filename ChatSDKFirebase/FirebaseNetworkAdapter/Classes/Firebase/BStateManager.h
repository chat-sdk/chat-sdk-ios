//
//  BStateManager.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 10/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RXPromise;

@interface BStateManager : NSObject

+(RXPromise *) userOn: (NSString *) entityID;
+(RXPromise *) userOff: (NSString *) entityID;

@end
