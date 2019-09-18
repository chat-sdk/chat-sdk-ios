//
//  PEntityWrapper.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 12/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

@protocol PEntityWrapper <NSObject>

-(NSString *) entityID;
-(id<PEntity>) model;

@end