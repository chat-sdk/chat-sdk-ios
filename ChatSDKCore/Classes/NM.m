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
    return [NM.core;
}

+(id<PAuthenticationHandler>) auth {
    return [NM.auth;
}

+(id<PUploadHandler>) upload {
    return [NM.upload;
}

+(id<PVideoMessageHandler>) videoMessage {
    return [NM.videoMessage;
}

+(id<PAudioMessageHandler>) audioMessage {
    return [NM.audioMessage;
}

+(id<PImageMessageHandler>) imageMessage {
    return [NM.imageMessage;
}

+(id<PLocationMessageHandler>) locationMessage {
    return [NM.locationMessage;
}

+(id<PPushHandler>) push {
    return [NM.push;
}

+(id<PContactHandler>) contact {
    return [NM.contact;
}

+(id<PTypingIndicatorHandler>) typingIndicator {
    return [NM.typingIndicator;
}

+(id<PModerationHandler>) moderation {
    return [NM.moderation;
}

+(id<PSearchHandler>) search {
    return [NM.search;
}

+(id<PPublicThreadHandler>) publicThread {
    return [NM.publicThread;
}

+(id<PBlockingHandler>) blocking {
    return [NM.blocking;
}

+(id<PLastOnlineHandler>) lastOnline {
    return [NM.lastOnline;
}

+(id<PNearbyUsersHandler>) nearbyUsers {
    return [NM.nearbyUsers;
}

+(id<PReadReceiptHandler>) readReceipt {
    return [NM.readReceipt;
}

+(id<PStickerMessageHandler>) stickerMessage {
    return [NM.stickerMessage;
}

+(id<PSocialLoginHandler>) socialLogin {
    return [NM.socialLogin;
}

+(id<PUsersHandler>) users {
    return [NM.users;
}

+(id<PUser>) currentUser {
    return NM.core.currentUserModel;
}

+(BOOL) isMe: (id<PUser>) user {
    return [[self currentUser].entityID isEqualToString:user.entityID];
}

+(id) handler: (NSString *) name {
    return [[NM handlerWithName:name];
}

+(id<PHookHandler>) hook {
    return [NM.hook;
}


@end
