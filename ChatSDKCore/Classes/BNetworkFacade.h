//
//  BNetworkFacade.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 01/03/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

@class RXPromise;

// TODO: Make these triangular brackets
//#import "BChatState.h"
//#import "BSubscriptionType.h"

@protocol PCoreHandler;
@protocol PPushHandler;
@protocol PUploadHandler;
@protocol PVideoMessageHandler;
@protocol PAudioMessageHandler;
@protocol PImageMessageHandler;
@protocol PLocationMessageHandler;
@protocol PAuthenticationHandler;
@protocol PContactHandler;
@protocol PTypingIndicatorHandler;
@protocol PModerationHandler;
@protocol PSearchHandler;
@protocol PPublicThreadHandler;
@protocol PLastOnlineHandler;
@protocol PBlockingHandler;
@protocol PNearbyUsersHandler;
@protocol PReadReceiptHandler;
@protocol PStickerMessageHandler;
@protocol PSocialLoginHandler;
@protocol PHookHandler;
@protocol PUsersHandler;

// Depricated: Use bHookLogout (and hook system) instead
#define bNotificationLogout @"bNLogout"

#define bNotificationMessageAdded @"bNMessageAdded"
#define bNotificationMessageAddedKeyMessage @"bNMessageAddedKeyMessage"

#define bNotificationMessageRemoved @"bNMessageRemoved"
#define bNotificationMessageRemovedKeyMessage @"bNMessageRemovedKeyMessage"

#define bNotificationMessageUpdated @"bNMessageUpdated"
#define bNotificationMessageUpdatedKeyMessage @"bNMessageUpdatedKeyMessage"

#define bNotificationFlaggedMessageAdded @"bNFlaggedMessageAdded"
#define bNotificationFlaggedMessageAdded_PMessage @"bNFlaggedMessageAdded_PMessage"

#define bNotificationFlaggedMessageRemoved @"bNFlaggedMessageRemoved"
#define bNotificationFlaggedMessageRemoved_PMessage @"bNFlaggedMessageRemoved_PMessage"

#define bNotificationUserUpdated @"bNUserUpdated"
#define bNotificationUserUpdated_PUser @"bNUserUpdated_PUser"

#define bNotificationThreadRead @"bNThreadRead"
#define bNotificationThreadDeleted @"bNThreadDeleted"
#define bNotificationBadgeUpdated @"bNBadgeUpdated"

#define bNotificationPresentChatView @"bNPresentChatView"
#define bNotificationPresentChatView_PThread @"bNPresentChatView_PThread"

#define bNotificationThreadUsersUpdated @"bNThreadUsersUpdated"
#define bNotificationThreadMetaUpdated @"bNThreadMetaUpdated"

#define bNotificationReadReceiptUpdated @"bNReadReceiptUpdated"
#define bNotificationReadReceiptUpdatedKeyMessage @"bNReadReceiptUpdatedKeyMessage"

//#define bNotificationTypingStarted @"bNTypingStarted"
//#define bNotificationTypingStartedKeyThread @"bNTypingStartedKeyThread"
//#define bNotificationTypingStartedKeyUser @"bNTypingStartedKeyUser"

#define bNotificationTypingStateChanged @"bNTypingStateChanged"
#define bNotificationTypingStateChangedKeyThread @"bNTypingStateChangedKeyThread"
#define bNotificationTypingStateChangedKeyMessage @"bNTypingStateChangedKeyMessage"

#define bNotificationAuthenticationComplete @"bNAuthenticationComplete"


@protocol BNetworkFacade <NSObject>

// Handlers
-(id<PCoreHandler>) core;
-(id<PAuthenticationHandler>) auth;
-(id<PPushHandler>) push;
-(id<PUploadHandler>) upload;
-(id<PVideoMessageHandler>) videoMessage;
-(id<PAudioMessageHandler>) audioMessage;
-(id<PImageMessageHandler>) imageMessage;
-(id<PLocationMessageHandler>) locationMessage;
-(id<PContactHandler>) contact;
-(id<PTypingIndicatorHandler>) typingIndicator;
-(id<PModerationHandler>) moderation;
-(id<PSearchHandler>) search;
-(id<PPublicThreadHandler>) publicThread;
-(id<PLastOnlineHandler>) lastOnline;
-(id<PBlockingHandler>) blocking;
-(id<PNearbyUsersHandler>) nearbyUsers;
-(id<PReadReceiptHandler>) readReceipt;
-(id<PStickerMessageHandler>) stickerMessage;
-(id<PSocialLoginHandler>) socialLogin;
-(id<PHookHandler>) hook;
-(id<PUsersHandler>) users;
-(id) handlerWithName: (NSString *) name;

-(void) setCore: (id<PCoreHandler>) core;
-(void) setAuth: (id<PAuthenticationHandler>) auth;
-(void) setPush: (id<PPushHandler>) push;
-(void) setUpload: (id<PUploadHandler>) upload;
-(void) setVideoMessage: (id<PVideoMessageHandler>) videoMessage;
-(void) setAudioMessage: (id<PAudioMessageHandler>) audioMessage;
-(void) setImageMessage: (id<PImageMessageHandler>) imageMessage;
-(void) setLocationMessage: (id<PLocationMessageHandler>) locationMessage;
-(void) setContact: (id<PContactHandler>) contact;
-(void) setTypingIndicator: (id<PTypingIndicatorHandler>) typingIndicator;
-(void) setModeration: (id<PModerationHandler>) moderation;
-(void) setSearch: (id<PSearchHandler>) search;
-(void) setPublicThread: (id<PPublicThreadHandler>) publicThread;
-(void) setLastOnline: (id<PLastOnlineHandler>) lastOnline;
-(void) setBlocking: (id<PBlockingHandler>) blocking;
-(void) setNearbyUsers: (id<PNearbyUsersHandler>) nearbyUsers;
-(void) setReadReceipt: (id<PReadReceiptHandler>) readReceipt;
-(void) setStickerMessage: (id<PStickerMessageHandler>) stickerMessage;
-(void) setSocialLogin: (id<PSocialLoginHandler>) socialLogin;
-(void) setHandler: (id) handler withName: (NSString *) name;
-(void) setHookHandler: (id<PHookHandler>) hook;
-(void) setUsers: (id<PUsersHandler>) users;

@end

