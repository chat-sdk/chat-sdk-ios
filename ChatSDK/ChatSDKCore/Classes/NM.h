//
//  NM.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 30/05/2017.
//
//

#import <Foundation/Foundation.h>

#import <ChatSDKCore/BNetworkFacade.h>

@protocol PUser;

@interface NM : NSObject

+(id<PCoreHandler>) core;
+(id<PAuthenticationHandler>) auth;
+(id<PUploadHandler>) upload;
+(id<PVideoMessageHandler>) videoMessage;
+(id<PAudioMessageHandler>) audioMessage;
+(id<PImageMessageHandler>) imageMessage;
+(id<PLocationMessageHandler>) locationMessage;
+(id<PPushHandler>) push;
+(id<PContactHandler>) contact;
+(id<PTypingIndicatorHandler>) typingIndicator;
+(id<PModerationHandler>) moderation;
+(id<PSearchHandler>) search;
+(id<PPublicThreadHandler>) publicThread;
+(id<PBlockingHandler>) blocking;
+(id<PLastOnlineHandler>) lastOnline;
+(id<PNearbyUsersHandler>) nearbyUsers;
+(id<PReadReceiptHandler>) readReceipt;
+(id<PStickerMessageHandler>) stickerMessage;
+(id<PSocialLoginHandler>) socialLogin;
+(id<PUser>) currentUser;
+(id) handler: (NSString *) name;
+(id<PHookHandler>) hook;
+(BOOL) isMe: (id<PUser>) user;

@end
