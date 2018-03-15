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

@protocol PMessage;

// Essentially, the last bit decides whether the thread is public
// or private.
typedef enum {
    // Group types
    bThreadTypePrivateGroup = 0x1,
    bThreadType1to1 = 0x2,
    bThreadTypePublicGroup = 0x4,
    
    // The broadcast channel is publically viewable in the public broadcast list
    bThreadTypePublicBroadcast = 0x8,
    
    // The proadcast is only available to members
    bThreadTypePrivateBroadcast = 0x10,
    
    // The broadcast is hidden but messages are threaded into
    // 1-to-1 chats. So if I broadcast to 5 users, it would
    // appear that I was sending a personal 1-to-1 message to
    // each of the users
    bThreadTypeThreadedBroadcast = 0x20,
    
    // To maintain backwards compatibility
    bThreadTypePrivateV3 = 0,
    bThreadTypePublicV3 = 1,
    
    // Filters
    bThreadFilterPrivate = bThreadType1to1 | bThreadTypePrivateGroup | bThreadTypePrivateBroadcast | bThreadTypeThreadedBroadcast,
    
    bThreadFilterBroadcast = bThreadTypePublicBroadcast | bThreadTypePrivateBroadcast | bThreadTypeThreadedBroadcast,
    
    bThreadFilterPublic = bThreadTypePublicGroup | bThreadTypePublicBroadcast,
    bThreadFilterGroup = bThreadTypePrivateGroup | bThreadTypePublicGroup | bThreadFilterBroadcast,
    
    bThreadFilterPrivateThread = bThreadTypePrivateGroup | bThreadType1to1,
    
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

-(void) setDeleted: (NSNumber *) deleted;
-(NSNumber *) deleted_;

-(void) addUser: (id<PUser>) user;
-(void) removeUser:(id<PUser>) user;
-(void) addMessage: (id<PMessage>) message;
-(void) removeMessage: (id<PMessage>) message;

-(NSString *) displayName;

-(NSSet *) users;
-(id<PUser>) otherUser;
-(id<PMessage>) lazyLastMessage;

-(void) markRead;
-(int) unreadMessageCount;

-(id<PThread>) model;

-(NSArray *) messagesOrderedByDateAsc;
-(NSArray *) messagesOrderedByDateDesc;
-(NSArray *) allMessages;
-(BOOL) hasMessages;

-(NSArray *) loadMoreMessages: (NSInteger) numberOfMessages;
-(void) resetMessages;

-(NSDictionary *) metaDictionary;
-(void) setMetaDictionary: (NSDictionary *) meta;
-(UIImage *)imageForThread;
-(NSDate *) orderDate;
-(void) clearMessageCache;

@end

