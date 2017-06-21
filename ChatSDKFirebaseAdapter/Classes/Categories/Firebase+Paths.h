//
//  Firebase+Paths2.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 13/03/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

//#import <Foundation/Foundation.h>
//#import "Firebase.h"
//#import <Firebase/Firebase.h>
//@import Firebase
//#import <Firebase/Firebase.h>

//@import FirebaseDatabase;
//@import Firebase;
//#import <Firebase/Firebase.h>
#import <ChatSDKFirebaseAdapter/ChatFirebaseAdapter.h>


@class FIRDatabaseReference;

@interface FIRDatabaseReference (Paths)


+(FIRDatabaseReference *) firebaseRef;

// Users
+(FIRDatabaseReference *) usersRef;
+(FIRDatabaseReference *) userRef: (NSString *) firebaseID;
+(FIRDatabaseReference *) userThreadsRef: (NSString *) firebaseID;
+(FIRDatabaseReference *) userMetaRef: (NSString *) firebaseID;

// Messages
+(FIRDatabaseReference *) threadsRef;
+(FIRDatabaseReference *) threadRef: (NSString *) firebaseID;
+(FIRDatabaseReference *) publicThreadsRef;
+(FIRDatabaseReference *) userOnlineRef: (NSString *) firebaseID;
+(FIRDatabaseReference *) threadMessagesRef: (NSString *) firebaseID;
+(FIRDatabaseReference *) threadTypingRef: (NSString *) firebaseID;
+(FIRDatabaseReference *) threadUsersRef: (NSString *) firebaseID;

// Flagged
+(FIRDatabaseReference *) flaggedRefWithThread: (NSString *) threadID message: (NSString *) messageID;

// Indexes
+(FIRDatabaseReference *) indexRef;
+(FIRDatabaseReference *) searchIndexRef;

-(FIRDatabaseReference *) child: (NSString *) component;

@end
