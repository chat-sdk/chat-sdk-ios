//
//  Firebase+Paths2.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 13/03/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "Firebase+Paths.h"

#import <FirebaseDatabase/FirebaseDatabase.h>

#import <ChatSDKCore/BSettingsManager.h>
#import <ChatSDKCore/BKeys.h>

@implementation FIRDatabaseReference (Paths)


+(FIRDatabaseReference *) firebaseRef {
    return [[[FIRDatabase database] reference] c: [BSettingsManager firebaseRootPath]];
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
    return [[[self usersRef] child:firebaseID] child:bMetaDataPath];
}

+(FIRDatabaseReference *) userThreadsRef: (NSString *) firebaseID {
    return [[self userRef:firebaseID] child:bThreadsPath];
}


+(FIRDatabaseReference *) userOnlineRef: (NSString *) firebaseID {
    return [[self userRef: firebaseID] child:bOnlinePath];
}

#pragma Flag ref

+(FIRDatabaseReference *) flaggedRefWithThread: (NSString *) threadID message: (NSString *) messageID {
    return [[[[[self.firebaseRef c: bFlaggedKey]  c:bThreadsPath] c:threadID] c:bMessagesPath] c:messageID];
}

#pragma Messages / Threads

+(FIRDatabaseReference *) threadsRef {
    return [[self firebaseRef] child:bThreadsPath];
}

+(FIRDatabaseReference *) threadRef: (NSString *) firebaseID {
    return [[self threadsRef] child:firebaseID];
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

#pragma Indexes

+(FIRDatabaseReference *) indexRef {
    return [[self firebaseRef] child:bIndexPath];
}

+(FIRDatabaseReference *) searchIndexRef {
    return [[self firebaseRef] child:bSearchIndexPath];
}


@end
