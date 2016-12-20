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

#define bNotificationLogout @"bNLogout"

#define bNotificationMessageAdded @"bNMessageAdded"
#define bNotificationMessageAddedKeyMessage @"bNMessageAddedKeyMessage"

#define bNotificationMessageUpdated @"bNMessageUpdated"
#define bNotificationMessageUpdatedKeyMessage @"bNMessageUpdatedKeyMessage"

#define bNotificationUserUpdated @"bNUserUpdated"
#define bNotificationThreadRead @"bNThreadRead"
#define bNotificationThreadDeleted @"bNThreadDeleted"
#define bNotificationBadgeUpdated @"bNBadgeUpdated"

#define bNotificationThreadUsersUpdated @"bNThreadUsersUpdated"

#define bNotificationReadReceiptUpdated @"bNReadReceiptUpdated"
#define bNotificationReadReceiptUpdatedKeyMessage @"bNReadReceiptUpdatedKeyMessage"

//#define bNotificationTypingStarted @"bNTypingStarted"
//#define bNotificationTypingStartedKeyThread @"bNTypingStartedKeyThread"
//#define bNotificationTypingStartedKeyUser @"bNTypingStartedKeyUser"

#define bNotificationTypingStateChanged @"bNTypingStateChanged"
#define bNotificationTypingStateChangedKeyThread @"bNTypingStateChangedKeyThread"
#define bNotificationTypingStateChangedKeyMessage @"bNTypingStateChangedKeyMessage"


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

@end

