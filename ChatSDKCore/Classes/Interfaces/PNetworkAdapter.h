//
//  PNetworkAdapter.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 01/03/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

@class RXPromise;

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
@protocol PFileMessageHandler;
@protocol PHookHandler;
@protocol PUsersHandler;
@protocol PEncryptionHandler;
@protocol PInternetConnectivityHandler;
@protocol PEventHandler;
@protocol PThreadHandler;
@protocol CallHandler;

#define bNotificationFlaggedMessageAdded @"bNFlaggedMessageAdded"
#define bNotificationFlaggedMessageAdded_PMessage @"bNFlaggedMessageAdded_PMessage"

#define bNotificationFlaggedMessageRemoved @"bNFlaggedMessageRemoved"
#define bNotificationFlaggedMessageRemoved_PMessage @"bNFlaggedMessageRemoved_PMessage"

#define bNotificationPresentChatView @"bNPresentChatView"
#define bNotificationPresentChatView_PThread @"bNPresentChatView_PThread"

@protocol PNetworkAdapter <NSObject>

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
-(id<PFileMessageHandler>) fileMessage;
-(id<PHookHandler>) hook;
-(id<PUsersHandler>) users;
-(id<PInternetConnectivityHandler>) connectivity;
-(id<PEncryptionHandler>) encryption;
-(id<PEventHandler>) event;
-(id<PThreadHandler>) thread;
-(id<CallHandler>) call;
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
-(void) setFileMessage: (id<PFileMessageHandler>) fileMessage;
-(void) setHandler: (id) handler withName: (NSString *) name;
-(void) setHookHandler: (id<PHookHandler>) hook;
-(void) setUsers: (id<PUsersHandler>) users;
-(void) setEncryption: (id<PEncryptionHandler>) encryption;
-(void) setEvent: (id<PEventHandler>) event;
-(void) setThread: (id<PThreadHandler>) thread;
-(void) setConnectivity: (id<PInternetConnectivityHandler>) connectivity;
-(void) setCall: (id<CallHandler>) call;

@optional

-(void) activate;

@end

