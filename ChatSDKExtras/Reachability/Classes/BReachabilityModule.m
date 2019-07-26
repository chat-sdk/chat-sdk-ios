//
//  ReachabilityModule.m
//  AFNetworking
//
//  Created by Ben on 10/10/18.
//

#import "BReachabilityModule.h"

#import <ChatSDK/Core.h>
#import "BInternetConnectivityHandler.h"

@implementation BReachabilityModule

-(void) activate {
    BInternetConnectivityHandler * handler = [[BInternetConnectivityHandler alloc] init];
    BChatSDK.shared.networkAdapter.connectivity = handler;
}


@end
