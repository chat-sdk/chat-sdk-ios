//
//  BJIDEntityID.h
//  AFNetworking
//
//  Created by Ben on 12/1/17.
//

#import <Foundation/Foundation.h>

@class XMPPJID;

// This class converts from a JID to an entity ID. The purpose of wrapping it in a class is that in come cases, it may
// be necessary to perform some processing rather than storing the bare JID
@interface BJIDEntityID : NSObject {
    XMPPJID * _jid;
}

@property (nonatomic, readwrite) BOOL includeServerAddress;

+(id) fromJID: (XMPPJID *) jid;
+(id) fromString: (NSString *) jidString;
@end
