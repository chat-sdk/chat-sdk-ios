//
//  BXMPPUserManager.h
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 23/02/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XMPP.h"
#import <ChatSDK/PUser.h>

#import "XMPPvCardAvatarModule.h"
#import "XMPPBlocking.h"

@class BXMPPRoster;
@class XMPPRosterMemoryStorage;
@class XMPPvCardCoreDataStorage;
@class XMPPvCardTempModule;
@class XMPPvCardAvatarModule;
@class RXPromise;

@interface BXMPPUserManager : XMPPModule<XMPPvCardAvatarDelegate, XMPPvCardTempModuleDelegate, XMPPBlockingDelegate> {
    BXMPPRoster * _xmppRoster;
    XMPPRosterMemoryStorage * _xmppRosterStorage;
    XMPPvCardCoreDataStorage * _xmppvCardStorage;
    XMPPvCardTempModule * _xmppvCardTempModule;
    XMPPvCardAvatarModule * _xmppvCardAvatarModule;
    XMPPBlocking * _xmppBlocking;
    BOOL _blockingServiceAvailable;
}

@property (nonatomic, readonly) BOOL blockingServiceAvailable;

-(RXPromise *) myvCardTemp;
//-(RXPromise *) vcardForUserWithJID: (NSString *) jid;

-(RXPromise *) vcardForUserWithJID: (NSString *) jid;
-(RXPromise *) updateUserFromvCard: (id<PUser>) user;

-(RXPromise *) updateMyvCardWithUser: (id<PUser>) user updateImage: (BOOL) updateImage;
-(RXPromise *) updateMyvCardWithUser: (id<PUser>) user;

-(RXPromise *) addContact: (id<PUser>) user;
-(RXPromise *) deleteContact: (id<PUser>) user;

-(RXPromise *) acceptPresenceSubscriptionForUser: (id<PUser>) user;
-(RXPromise *) rejectPresenceSubscriptionForUser: (id<PUser>) user;

-(RXPromise *) blockUser: (id<PUser>) user;
-(RXPromise *) unblockUser: (id<PUser>) user;

@end
