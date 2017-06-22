//
//  PLinkedAccount.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 27/05/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

@protocol PUserAccount <NSObject>

-(void) setType: (NSNumber *) type;
-(NSNumber *) type;

-(void) setToken: (NSString *) token;
-(NSString *) token;

@end