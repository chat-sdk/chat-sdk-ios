//
//  PEntity.h
//  NekNominate
//
//  Created by Benjamin Smiley-andrews on 26/02/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

@protocol PEntity <NSObject>

-(NSString *) entityID;
-(void) setEntityID: (NSString *) uid;
-(BOOL) isEqualToEntity: (id<PEntity>) entity;

@end
