//
//  XMPPManager.h
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 17/02/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
#import "XMPPCapabilities.h"
#import "XMPPMessageCarbons.h"


@class XMPPReconnect;
@class XMPPCapabilitiesCoreDataStorage;
@class XMPPCapabilities;
@class XMPPStreamManagement;
@class XMPPMessageCarbons;
@class XMPPMessageDeliveryReceipts;
@class XMPPAutoTime;
@class XMPPRegistration;

@class BXMPPUserManager;
@class BXMPPMUCManager;
@class BXMPPSearchHelper;
@class BXMPPChatManager;
@class BXMPPServiceDiscovery;
@class BXMPPMUCMessageManager;
@class BXMPPTypingIndicatorManager;
@class MamManager;
@class DeliveryReceiptListener;
@class XMPPBookmarksModule;
@class XMPPPrivateXMLStorageManager;
@class XMPPPrivacy;
@class OutgoingMessageQueue;
@class EntityTimeManager;
@class CapabilitiesListener;
@class PrivacyLists;
@class XMPPCallbackManager;
@class PubSubManager;
@class XMPPJingle;
@class JingleListener;
@class UserResourceTracker;
@class ConnectionManager;

@class RXPromise;

@protocol PMessage;
@protocol PUser;
@protocol XMPPStreamManagementStorage;
@protocol PThread;
@protocol JingleListener;

#define bHookXMPPSetupStream @"bHookXMPPSetupStream"
#define bHookXMPPTeardownStream @"bHookXMPPTeardownStream"

typedef void(^Completion)(void);

@interface BXMPPManager : NSObject<XMPPStreamDelegate, XMPPCapabilitiesDelegate, XMPPMessageCarbonsDelegate> {
    XMPPStream * _xmppStream;
    XMPPReconnect * _xmppReconnect;
    XMPPCapabilitiesCoreDataStorage * _xmppCapabilitiesStorage;
    XMPPCapabilities * _xmppCapabilities;
    XMPPMessageCarbons * _xmppMessageCarbons;
    XMPPMessageDeliveryReceipts * _xmppMessageDeliveryReceipts;
    XMPPAutoTime * _xmppTime;
    XMPPRegistration * _xmppRegistration;
    XMPPPrivacy * _xmppPrivacy;
    
    XMPPJingle * _xmppJingle;
    
    MamManager * _mamManager;
    
    BXMPPServiceDiscovery * _serviceDiscovery;
    
    XMPPStreamManagement * _xmppStreamManagement;
    id<XMPPStreamManagementStorage> _xmppStreamManagementStorage;
    
    BXMPPUserManager * _userManager;
    BXMPPMUCManager * _mucManager;
    BXMPPChatManager * _chatManager;
    BXMPPMUCMessageManager * _mucMessageManager;
    BXMPPTypingIndicatorManager * _typingIndicatorManager;
    DeliveryReceiptListener * _deliveryReceiptListener;
    ConnectionManager * _connectionManager;
        
    XMPPBookmarksModule * _bookmarksModule;
    XMPPPrivateXMLStorageManager * _privateStorageManager;
    
    EntityTimeManager * _entityTimeManager;
    CapabilitiesListener * _capabilitiesListener;
    
    dispatch_queue_t _xmppDispatchQueue;
    
    RXPromise * _joiningGroupChatsPromise;
    
    NSTimer * _connectionTimer;
    OutgoingMessageQueue * _outgoingMessageQueue;
    PrivacyLists * _privacyLists;
    XMPPCallbackManager * _xmppCallbackManager;
    
    PubSubManager * _pubSubManager;
    UserResourceTracker * _userResourceTracker;
//    JingleListener * _jingleListener;
        
}

@property (nonatomic, readonly) XMPPStream * stream;

@property (nonatomic, readonly) BXMPPUserManager * userManager;
@property (nonatomic, readonly) BXMPPMUCManager * mucManager;
@property (nonatomic, readonly) BXMPPChatManager * chatManager;
@property (nonatomic, readonly) BXMPPSearchHelper * searchHelper;
@property (nonatomic, readonly) BXMPPTypingIndicatorManager * typingIndicatorManager;
@property (nonatomic, readonly) BXMPPServiceDiscovery * serviceDiscovery;

@property (nonatomic, readonly) XMPPBookmarksModule * bookmarksModule;
@property (nonatomic, readonly) XMPPPrivateXMLStorageManager * privateStorageManager;
@property (nonatomic, readonly) XMPPRegistration * xmppRegistration;
@property (nonatomic, readonly) XMPPAutoTime * xmppTime;
@property (nonatomic, readonly) XMPPPrivacy * xmppPrivacy;
@property (nonatomic, readonly) XMPPCallbackManager * xmppCallbackManager;
@property (nonatomic, readonly) OutgoingMessageQueue * outgoingMessageQueue;
@property (nonatomic, readonly) PubSubManager * pubSubManager;
@property (nonatomic, readonly) MamManager * mamManager;
@property (nonatomic, readonly) DeliveryReceiptListener * deliveryReceiptListener;
@property (nonatomic, readonly) XMPPJingle * xmppJingle;
@property (nonatomic, readonly) UserResourceTracker * userResourceTracker;
@property (nonatomic, readonly) ConnectionManager * connectionManager;

@property (nonatomic, readonly) EntityTimeManager * entityTimeManager;
@property (nonatomic, readonly) CapabilitiesListener * capabilitiesListener;
@property (nonatomic, readonly) PrivacyLists * privacyLists;

@property (nonatomic, readonly) dispatch_queue_t xmppDispatchQueue;

@property (nonatomic, readwrite) BOOL customCertificateEvaluation;

+(nonnull BXMPPManager *) shared;

//-(NSDate *) xmppServerDate;
+(nonnull XMPPJID *) hostJID;

-(nonnull RXPromise *) authenticateWithJID: (XMPPJID *) jid password: (NSString *) password;
-(RXPromise *) registerWithJID: (XMPPJID *) jid password: (NSString *) password;

-(void) teardownStream;

-(nonnull RXPromise *) sendPresenceWithType: (NSString *) type status: (NSString *) status state: (NSString *) state priority: (NSNumber *) priority;

-(RXPromise *) getLastOnlineForUser: (NSString *) userEntityID;

-(BOOL) userIsAuthenticated;
-(nonnull RXPromise *) sendMessage: (id<PMessage>) message;
-(NSTimeInterval) getTimeDifferenceBetweenServerAndDevice;

+(NSString *) hostAddress;
+(NSString *) domain;
+(NSNumber *) port;
+(NSString *) resource;

-(void) reconnect;
-(void) softReconnect;

-(void) setDeliveryReceiptsEnabled: (BOOL) enabled;
-(void) setReadReceiptsEnabled: (BOOL) enabled;

+(void) setHostAddress: (NSString *) hostAddress domain: (NSString *) domain port: (NSNumber *) port resource: (NSString *) resource;

-(nonnull RXPromise *) sendUnavailablePresence;
-(nonnull RXPromise *) sendAvailablePresence;
-(nonnull RXPromise *) sendXMPPMessage: (XMPPMessage *) xmppMessage thread: (id<PThread>) thread;
-(RXPromise *) joinExistingGroupChats;

-(void) updateLastOnlineTime;
-(NSDate *) lastOnlineTime;

@end
