//
//  BXMPPMUCManager.h
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 29/07/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPModule.h"
#import <ChatSDKXMPP/XMPPMUC.h>

@class XMPPRoomMemoryStorage;
@class XMPPStream;
@class RXPromise;
@class XMPPMUC;
@class XMPPMessage;
@class XMPPJID;
@class XMPPRoom;
@class RoomManager;

@protocol PUser;
@protocol PThread;

@interface BXMPPMUCManager : XMPPModule<XMPPMUCDelegate, XMPPRoomDelegate> {
    XMPPRoomMemoryStorage * _roomStorage;

    NSString * _roomName;
    NSString * _roomDescription;
    NSArray * _users;
    
    NSMutableDictionary * _roomManagers;

}

@property(nonatomic, readonly) XMPPMUC * xmppMUC;
@property(nonatomic, readonly) XMPPRoomMemoryStorage * roomStorage;

-(RXPromise *) createRoomWithName: (NSString *) name description: (NSString *) description users: (NSArray *) users bookmark: (BOOL) bookmark;

-(NSString *) roomHost;
-(NSString *) roomHostWithID: (NSString *) rid;

-(NSError *) sendMessage:(XMPPMessage *)message toThread: (id<PThread>) thread;

-(NSString *) userJidForRoomUserJid: (XMPPJID *) roomJID;
//
-(RXPromise *) joinMultiUserChatRoomWithJID: (NSString *) jid bookmark: (BOOL) bookmark;

-(void) goOffline;

-(nullable RoomManager *) roomManager: (NSString *) threadEntityID;
-(BOOL) handleActionMessage: (XMPPMessage *) message forRoom: (XMPPRoom *) room from: (NSString *) userJID;

@end
