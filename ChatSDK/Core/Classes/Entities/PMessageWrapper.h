//
//  PMessageWrapper.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 12/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import "PMessage.h"
#import "PEntityWrapper.h"

@protocol PMessageWrapper <PEntityWrapper>

-(id<PMessage, PEntity>) model;

@end
