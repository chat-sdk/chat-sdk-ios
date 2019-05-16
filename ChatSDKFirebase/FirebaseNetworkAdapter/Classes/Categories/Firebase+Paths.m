//
//  Firebase+Paths2.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 13/03/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "Firebase+Paths.h"

#import <ChatSDKFirebase/FirebaseAdapter.h>

@implementation FIRDatabaseReference (Paths)

+(FIRDatabaseReference *) firebaseRef {
    return [[[FIRDatabase database] reference] c: BChatSDK.config.rootPath];
}

-(FIRDatabaseReference *) c: (NSString *) component {
    return [self child:component];
}

#pragma Users

// users
+(FIRDatabaseReference *) usersRef {
    return [[self firebaseRef] child:bUsersPath];
}

// users/[user id]
+(FIRDatabaseReference *) userRef: (NSString *) firebaseID {
    return [[self usersRef] child:firebaseID];
}

+(FIRDatabaseReference *) userMetaRef: (NSString *) firebaseID {
    return [[[self usersRef] child:firebaseID] child:bMetaPath];
}

+(FIRDatabaseReference *) userThreadsRef: (NSString *) firebaseID {
    return [[self userRef:firebaseID] child:bThreadsPath];
}

+(FIRDatabaseReference *) userContactsRef: (NSString *) firebaseID {
    return [[self userRef:firebaseID] child:bContactsPath];
}

+(FIRDatabaseReference *) userOnlineRef: (NSString *) firebaseID {
    return [[self userRef: firebaseID] child:bOnlinePath];
}

+(FIRDatabaseReference *) onlineRef: (NSString *) firebaseID {
    return [[[self firebaseRef] child:bOnlinePath] child:firebaseID];
}

#pragma Flag ref

+(FIRDatabaseReference *) flaggedMessagesRef {
    return [[self.firebaseRef c:bFlaggedKey] c:bMessagesPath];
}

+(FIRDatabaseReference *) flaggedRefWithMessage: (NSString *) messageID {
    return [[self flaggedMessagesRef] c:messageID];
}

#pragma Messages / Threads

+(FIRDatabaseReference *) threadsRef {
    return [[self firebaseRef] child:bThreadsPath];
}

+(FIRDatabaseReference *) threadRef: (NSString *) firebaseID {
    return [[self threadsRef] child:firebaseID];
}

+(FIRDatabaseReference *) threadLastMessageRef: (NSString *) firebaseID {
    return [[[self threadsRef] child:firebaseID] child:bLastMessage];;
}

+(FIRDatabaseReference *) threadUsersRef: (NSString *) firebaseID {
    return [[[self threadsRef] child:firebaseID] child:bUsersPath];
}

+(FIRDatabaseReference *) threadMessagesRef: (NSString *) firebaseID  {
    return [[self threadRef:firebaseID] child:bMessagesPath];
}

+(FIRDatabaseReference *) publicThreadsRef {
    return [[self firebaseRef] child:bPublicThreadsPath];
}

+(FIRDatabaseReference *) threadTypingRef: (NSString *) firebaseID {
    return [[self threadRef:firebaseID] child:bTypingPath];
}

+(FIRDatabaseReference *) threadMetaRef: (NSString *) firebaseID {
    return [[self threadRef:firebaseID] child:bMetaPath];
}

+(FIRDatabaseReference *) thread: (NSString *) threadID messageRef: (NSString *) messageID {
    return [[self threadMessagesRef:threadID] child:messageID];
}

+(FIRDatabaseReference *) thread: (NSString *) threadID messageReadRef: (NSString *) messageID {
    return [[self thread:threadID messageRef:messageID] child:bReadPath];
}


@end
