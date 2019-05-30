//
//  BFirebaseEventHandler.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 10/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PEventHandler.h>

@protocol PUser;

@interface BFirebaseEventHandler : NSObject<PEventHandler>

-(void) userOn: (NSString *) entityID;
-(void) userOff: (NSString *) entityID;

-(void) threadsOn: (id<PUser>) user;
-(void) publicThreadsOn: (id<PUser>) user;
-(void) contactsOn: (id<PUser>) user;
-(void) moderationOn: (id<PUser>) user;

-(void) threadsOff: (id<PUser>) user;
-(void) publicThreadsOff: (id<PUser>) user;
-(void) contactsOff: (id<PUser>) user;
-(void) moderationOff: (id<PUser>) user;

@end
