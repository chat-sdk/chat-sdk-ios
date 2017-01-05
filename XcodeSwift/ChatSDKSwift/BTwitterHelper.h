//
//  BTwitterHelper.h
//  Chat SDK Firebase
//
//  Created by Benjamin Smiley-andrews on 16/06/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RXPromise;

// This class is a work around - there's a problem with the Twitter pods
// which means that they can't be included in the sub pods - just the
// main project
@interface BTwitterHelper : NSObject

+(BTwitterHelper *) sharedHelper;
-(RXPromise *) login;

@end
