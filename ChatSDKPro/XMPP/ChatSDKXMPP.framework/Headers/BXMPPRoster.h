//
//  BXMPPRoster.h
//  AFNetworking
//
//  Created by Ben on 11/14/18.
//

#import "XMPPFramework.h"

NS_ASSUME_NONNULL_BEGIN

@interface BXMPPRoster : XMPPRoster

- (void)removeUser:(XMPPJID *)jid withGroup: (NSString *) group;

@end

NS_ASSUME_NONNULL_END
