//
//  PThreadWrapper.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 12/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import "PThread_.h"
#import "PEntityWrapper.h"

@class BPromise;

@protocol PThreadWrapper <PEntityWrapper>

-(id<PThread, PEntity>) model;

@end