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
    bThreadTypeNone = 0x0,
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
    bThreadFilterAll = 0xFFFF,

    bThreadFilterPrivateThread = bThreadTypePrivateGroup | bThreadType1to1,
    
} bThreadType;

@protocol PThread <PEntity, PElmThread>

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

-(void) setDeletedDate: (NSDate *) date;
-(NSDate *) deletedDate;

-(BOOL) addUser: (id<PUser>) user;
-(BOOL) removeUser:(id<PUser>) user;

-(void) addMessageAndSort: (id<PMessage>) message;
-(void) addMessage: (id<PMessage>) message;
-(void) addMessage: (id<PMessage>) theMessage toStart: (BOOL) toStart;
-(void) removeMessage: (id<PMessage>) message;
-(void) removeAllMessages;

-(BOOL) containsUser: (id<PUser>) user;

-(NSString *) displayName;

-(NSSet *) users;
-(id<PUser>) otherUser;
-(id<PMessage>) newestMessage;

// Active members - i.e. doesn't include banned members
-(NSArray<PUser> *) members;

-(void) markRead;
-(int) unreadMessageCount;

-(id<PThread>) model;

-(NSArray *) messagesOrderedByDateAsc;
-(NSArray *) messagesOrderedByDateDesc;

-(NSArray *) messagesOrderedByDateNewestFirst;
-(NSArray *) messagesOrderedByDateOldestFirst;

-(NSArray *) allMessages;
-(BOOL) hasMessages;

-(NSString *) imageURL;

-(NSDate *) orderDate;

-(void) setMeta: (NSDictionary *) meta;
-(NSDictionary *) meta;
-(void) setMetaValue: (id) value forKey: (NSString *) key;
-(void) removeMetaValueForKey: (NSString *) key;

-(BOOL) isReadOnly;

-(void) setDraft: (NSString *) draft;
-(NSString *) draft;
-(BOOL) typeIs: (bThreadType) type;
 
-(BOOL) addConnection: (PUser *) user;
-(BOOL) removeConnection: (PUser *) user;
-(NSArray<PUserConnection> *) connections;
-(id<PUserConnection>) connection: (NSString *) entityID;

-(void) markDeleted: (BOOL) notify;

@end

