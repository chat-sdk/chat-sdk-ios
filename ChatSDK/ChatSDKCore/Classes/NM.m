//
//  NM.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 30/05/2017.
//
//

#import "NM.h"

#import "ChatCore.h"

@implementation NM

+(id<PCoreHandler>) core {
    return [BNetworkManager sharedManager].a.core;
}

+(id<PAuthenticationHandler>) auth {
    return [BNetworkManager sharedManager].a.auth;
}

+(id<PUploadHandler>) upload {
    return [BNetworkManager sharedManager].a.upload;
}

+(id<PVideoMessageHandler>) videoMessage {
    return [BNetworkManager sharedManager].a.videoMessage;
}

+(id<PAudioMessageHandler>) audioMessage {
    return [BNetworkManager sharedManager].a.audioMessage;
}

+(id<PImageMessageHandler>) imageMessage {
    return [BNetworkManager sharedManager].a.imageMessage;
}

+(id<PLocationMessageHandler>) locationMessage {
    return [BNetworkManager sharedManager].a.locationMessage;
}

+(id<PPushHandler>) push {
    return [BNetworkManager sharedManager].a.push;
}

+(id<PContactHandler>) contact {
    return [BNetworkManager sharedManager].a.contact;
}

+(id<PTypingIndicatorHandler>) typingIndicator {
    return [BNetworkManager sharedManager].a.typingIndicator;
}

+(id<PModerationHandler>) moderation {
    return [BNetworkManager sharedManager].a.moderation;
}

+(id<PSearchHandler>) search {
    return [BNetworkManager sharedManager].a.search;
}

+(id<PPublicThreadHandler>) publicThread {
    return [BNetworkManager sharedManager].a.publicThread;
}

+(id<PBlockingHandler>) blocking {
    return [BNetworkManager sharedManager].a.blocking;
}

+(id<PLastOnlineHandler>) lastOnline {
    return [BNetworkManager sharedManager].a.lastOnline;
}

+(id<PNearbyUsersHandler>) nearbyUsers {
    return [BNetworkManager sharedManager].a.nearbyUsers;
}

+(id<PReadReceiptHandler>) readReceipt {
    return [BNetworkManager sharedManager].a.readReceipt;
}

+(id<PStickerMessageHandler>) stickerMessage {
    return [BNetworkManager sharedManager].a.stickerMessage;
}

+(id<PSocialLoginHandler>) socialLogin {
    return [BNetworkManager sharedManager].a.socialLogin;
}

+(id<PUser>) currentUser {
    return NM.core.currentUserModel;
}

+(id) handler: (NSString *) name {
    return [[BNetworkManager sharedManager].a handlerWithName:name];
}


@end
