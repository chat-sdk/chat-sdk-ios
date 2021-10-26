//
//  XMPPPresence+ChatSDK.h
//  AFNetworking
//
//  Created by Ben on 10/8/18.
//

#import <Foundation/Foundation.h>
//#import "XMPPPresence.h"
#import <ChatSDKVendor/XMPPFramework.h>

@class XMPPPresence;

@interface XMPPPresence(ChatSDK)

+(XMPPPresence *) presenceWithType: (NSString *) type status: (nullable NSString *) status state: (nullable NSString *) state priority: (nullable NSNumber *) priority;

@end

