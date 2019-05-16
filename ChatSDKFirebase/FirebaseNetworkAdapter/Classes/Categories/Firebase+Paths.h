//
//  Firebase+Paths2.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 13/03/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import <ChatSDKFirebase/FirebaseAdapter.h>

@class FIRDatabaseReference;

@interface FIRDatabaseReference (Paths)


+(FIRDatabaseReference *) firebaseRef;
// Users
+(FIRDatabaseReference *) usersRef;
+(FIRDatabaseReference *) userRef: (NSString *) firebaseID;
+(FIRDatabaseReference *) userThreadsRef: (NSString *) firebaseID;
+(FIRDatabaseReference *) userMetaRef: (NSString *) firebaseID;
+(FIRDatabaseReference *) userContactsRef: (NSString *) firebaseID;

// Messages
+(FIRDatabaseReference *) threadsRef;
+(FIRDatabaseReference *) threadRef: (NSString *) firebaseID;
+(FIRDatabaseReference *) publicThreadsRef;
+(FIRDatabaseReference *) userOnlineRef: (NSString *) firebaseID;
+(FIRDatabaseReference *) threadMessagesRef: (NSString *) firebaseID;
+(FIRDatabaseReference *) threadTypingRef: (NSString *) firebaseID;
+(FIRDatabaseReference *) threadUsersRef: (NSString *) firebaseID;
+(FIRDatabaseReference *) threadMetaRef: (NSString *) firebaseID;
+(FIRDatabaseReference *) threadLastMessageRef: (NSString *) firebaseID;

+(FIRDatabaseReference *) thread: (NSString *) threadID messageReadRef: (NSString *) messageID;
+(FIRDatabaseReference *) thread: (NSString *) threadID messageRef: (NSString *) messageID;

// Flagged
+(FIRDatabaseReference *) flaggedMessagesRef;
+(FIRDatabaseReference *) flaggedRefWithMessage: (NSString *) messageID;

+(FIRDatabaseReference *) onlineRef: (NSString *) userID;

@end
