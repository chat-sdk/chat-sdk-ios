//
//  NM.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 30/05/2017.
//
//

#import "NM.h"

#import "Core.h"

@implementation NM

+(id<PCoreHandler>) core {
    return self.a.core;
}

+(id<PAuthenticationHandler>) auth {
    return self.a.auth;
}

+(id<PUploadHandler>) upload {
    return self.a.upload;
}

+(id<PVideoMessageHandler>) videoMessage {
    return self.a.videoMessage;
}

+(id<PAudioMessageHandler>) audioMessage {
    return self.a.audioMessage;
}

+(id<PImageMessageHandler>) imageMessage {
    return self.a.imageMessage;
}

+(id<PLocationMessageHandler>) locationMessage {
    return self.a.locationMessage;
}

+(id<PPushHandler>) push {
    return self.a.push;
}

+(id<PContactHandler>) contact {
    return self.a.contact;
}

+(id<PTypingIndicatorHandler>) typingIndicator {
    return self.a.typingIndicator;
}

+(id<PModerationHandler>) moderation {
    return self.a.moderation;
}

+(id<PSearchHandler>) search {
    return self.a.search;
}

+(id<PPublicThreadHandler>) publicThread {
    return self.a.publicThread;
}

+(id<PBlockingHandler>) blocking {
    return self.a.blocking;
}

+(id<PLastOnlineHandler>) lastOnline {
    return self.a.lastOnline;
}

+(id<PNearbyUsersHandler>) nearbyUsers {
    return self.a.nearbyUsers;
}

+(id<PReadReceiptHandler>) readReceipt {
    return self.a.readReceipt;
}

+(id<PStickerMessageHandler>) stickerMessage {
    return self.a.stickerMessage;
}

+(id<PSocialLoginHandler>) socialLogin {
    return self.a.socialLogin;
}

+(id<PUsersHandler>) users {
    return self.a.users;
}

+(id<PUser>) currentUser {
    return NM.core.currentUserModel;
}

+(BOOL) isMe: (id<PUser>) user {
    return [[self currentUser].entityID isEqualToString:user.entityID];
}

+(id) handler: (NSString *) name {
    return [self.a handlerWithName:name];
}

+(id<PHookHandler>) hook {
    return self.a.hook;
}
    
+(id<BNetworkFacade>) a {
    return [BNetworkManager sharedManager].a;
}


@end
