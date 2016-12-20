//
//  BStateManager.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 10/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BStateManager : NSObject

+(void) userOn: (NSString *) entityID;
+(void) userOff: (NSString *) entityID;

@end
