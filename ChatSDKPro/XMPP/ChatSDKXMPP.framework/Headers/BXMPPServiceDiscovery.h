//
//  BXMPPServiceIdentifier.h
//  AFNetworking
//
//  Created by Ben on 11/17/17.
//

#import <Foundation/Foundation.h>
#import <ChatSDKXMPP/XMPPAdapter.h>

typedef void(^ServiceDiscoveryListener)();

@interface BXMPPServiceDiscovery : XMPPModule<XMPPStreamDelegate> {
    NSMutableDictionary * _requests;
    NSMutableArray * _services;
    RXPromise * _requestingServices;
    NSMutableArray<ServiceDiscoveryListener> * _serviceDiscoveryListeners;
}

@property (nonatomic, readwrite) XMPPJID * searchService;
@property (nonatomic, readwrite) XMPPJID * mucService;
@property (nonatomic, readwrite) XMPPJID * pubSubService;

@property (nonatomic, readonly) NSArray * services;

//-(id) initWithStream: (XMPPStream *) stream queue: (dispatch_queue_t) queue;
-(RXPromise *) requestServices;
-(NSArray *) servicesWithFeature: (NSString *) feature;

-(BOOL) simpleCommunicationBlockingSupported;

-(void) addServiceDiscoveryListener: (ServiceDiscoveryListener) listener;
-(RXPromise *) infoForService: (XMPPJID *) jid;

@end
