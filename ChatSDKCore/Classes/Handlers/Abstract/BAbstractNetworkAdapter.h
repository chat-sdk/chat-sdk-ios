//
//  BAbstractNetworkAdapter.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/11/2016.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PNetworkAdapter.h>

@interface BAbstractNetworkAdapter : NSObject<PNetworkAdapter>

@property (nonatomic, readwrite) id<PCoreHandler> core;
@property (nonatomic, readwrite) id<PPushHandler> push;
@property (nonatomic, readwrite) id<PUploadHandler> upload;
@property (nonatomic, readwrite) id<PVideoMessageHandler> videoMessage;
@property (nonatomic, readwrite) id<PAudioMessageHandler> audioMessage;
@property (nonatomic, readwrite) id<PImageMessageHandler> imageMessage;
@property (nonatomic, readwrite) id<PLocationMessageHandler> locationMessage;
@property (nonatomic, readwrite) id<PAuthenticationHandler> auth;
@property (nonatomic, readwrite) id<PContactHandler> contact;
@property (nonatomic, readwrite) id<PTypingIndicatorHandler> typingIndicator;
@property (nonatomic, readwrite) id<PModerationHandler> moderation;
@property (nonatomic, readwrite) id<PSearchHandler> search;
@property (nonatomic, readwrite) id<PPublicThreadHandler> publicThread;
@property (nonatomic, readwrite) id<PBlockingHandler> blocking;
@property (nonatomic, readwrite) id<PLastOnlineHandler> lastOnline;
@property (nonatomic, readwrite) id<PNearbyUsersHandler> nearbyUsers;
@property (nonatomic, readwrite) id<PReadReceiptHandler> readReceipt;
@property (nonatomic, readwrite) id<PStickerMessageHandler> stickerMessage;
@property (nonatomic, readwrite) id<PFileMessageHandler> fileMessage;
@property (nonatomic, readwrite) id<PSocialLoginHandler> socialLogin;
@property (nonatomic, readwrite) id<PUsersHandler> users;
@property (nonatomic, readwrite) id<PHookHandler> hook;
@property (nonatomic, readwrite) id<PEncryptionHandler> encryption;
@property (nonatomic, readwrite) id<PInternetConnectivityHandler> connectivity;
@property (nonatomic, readwrite) id<PEventHandler> event;

@end
