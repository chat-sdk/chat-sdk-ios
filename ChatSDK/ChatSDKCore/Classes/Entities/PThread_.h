//
//  PThread_.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 09/04/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

@class PUser;

#import "PEntity.h"
#import "PUser.h"
#import "PElmThread.h"

// Essentially, the last bit decides whether the thread is public
// or private.
typedef enum {
    // Group types
    bThreadTypePrivateGroup = 0x1,
    bThreadType1to1 = 0x2,
    bThreadTypePublicGroup = 0x4,
    bThreadTypeBroadcast = 0x8,

    // Descriptors
    bThreadTypePrivate = bThreadType1to1 | bThreadTypePrivateGroup,
    bThreadTypePublic = bThreadTypePublicGroup,
    bThreadTypeGroup = bThreadTypePrivateGroup | bThreadTypePublicGroup,
    
    // To maintain backwards compatibility
    bThreadTypePrivateV3 = 0,
    bThreadTypePublicV3 = 1,
    
} bThreadType;

@protocol PThread <PEntity, PHasMeta, PElmThread>

-(void) setCreator: (id<PUser>) user;
-(id<PUser>) creator;

-(void) setEntityID: (NSString *) entityID;
-(NSString *) entityID;

-(void) setCreationDate: (NSDate *) date;
-(NSDate *) creationDate;

-(void) setType: (NSNumber *) type;
-(NSNumber *) type;

-(void) setName: (NSString *) name;
-(NSString *) name;
-(NSString *) memberListString;

-(void) setLastMessageAdded: (NSDate *) date;
-(NSDate *) lastMessageAdded;

-(void) setDeleted: (NSNumber *) deleted;
-(NSNumber *) deleted_;

-(void) addUser: (id<PUser>) user;
- (void)removeUser:(id<PUser>) user;

-(NSArray *) messages;

-(NSString *) displayName;

-(NSSet *) users;
-(id<PUser>) otherUser;

-(void) markRead;
-(int) unreadMessageCount;

-(id<PThread>) model;

-(NSArray *) messagesOrderedByDateAsc;
-(NSArray *) messagesOrderedByDateDesc;

-(UIImage *)imageForThread;
-(NSDate *) orderDate;

@end

