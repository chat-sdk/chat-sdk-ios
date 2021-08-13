//
//  BXMPPAuthenticationHandler.h
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 21/11/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import <ChatSDK/Core.h>
#import <ChatSDK/BAbstractAuthenticationHandler.h>

@class BXMPPManager;
@class XMPPJID;

@interface BXMPPAuthenticationHandler : BAbstractAuthenticationHandler {
    BXMPPManager * _manager;
    NSString * _authenticationType;
}

-(NSString *) cachedPassword;
-(void) setCachedPassword: (NSString *) password forJID: (XMPPJID *) jid;

@end
