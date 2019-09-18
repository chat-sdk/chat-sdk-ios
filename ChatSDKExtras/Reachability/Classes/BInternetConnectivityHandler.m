//
//  BInternetConnectivity.m
//  AFNetworking
//
//  Created by Ben on 10/10/18.
//

#import "BInternetConnectivityHandler.h"
#import <ChatSDK/Core.h>
#import <Reachability/Reachability.h>

@implementation BInternetConnectivityHandler

-(instancetype) init {
    if ((self = [super init])) {
        [[Reachability reachabilityForInternetConnection] startNotifier];
        [[NSNotificationCenter defaultCenter] addObserverForName:kReachabilityChangedNotification object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
            [BHookNotification notificationInternetConnectivityDidChange];
        }];
    }
    return self;
}

-(BOOL) isConnected {
    return [Reachability reachabilityForInternetConnection].isReachable;
}

@end
