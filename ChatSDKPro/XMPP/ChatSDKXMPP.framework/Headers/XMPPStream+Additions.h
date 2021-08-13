//
//  XMPPStream+Additions.h
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 04/09/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"

@class RXPromise;

@interface XMPPStream(Additions)

-(RXPromise *) submitIQ: (NSXMLElement *) iq;
-(RXPromise *) submitQuery: (NSXMLElement *) query type: (NSString *) type to: (XMPPJID *) to attributes: (NSDictionary *) attributes;

@end
