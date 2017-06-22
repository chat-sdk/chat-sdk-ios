//
//  PUserWrapper.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 12/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import "PUser.h"
#import "PEntityWrapper.h"

@protocol PUserWrapper <PEntityWrapper>

-(id<PUser, PEntity>) model;

@end

