//
//  BXMPPThreadWrapper.h
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 12/09/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    bInviteStatusNone,
    bInviteStatusPending,
    bInviteStatusAccepted,
    bInviteStatusDeclined,
} bInviteStatus;

@protocol PThread;
@protocol PUser;

#define bInviteStatusKey @"inviteStatus"

@interface BXMPPThreadWrapper : NSObject {
    id<PThread> _thread;
}

+(instancetype) wrapperWithThread: (id<PThread>) thread;
-(instancetype) initWithThread: (id<PThread>) thread;
-(void) setInviteStatus: (bInviteStatus) status forUser: (id<PUser>) user;
-(bInviteStatus) inviteStatusForUser: (id<PUser>) user;

@end
