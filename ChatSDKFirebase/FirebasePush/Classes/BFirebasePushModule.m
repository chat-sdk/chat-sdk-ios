//
//  BFirebasePushHandlerModule.m
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 03/08/2017.
//  Copyright © 2017 deluge. All rights reserved.
//

#import "BFirebasePushModule.h"
#import <ChatSDK/FirebasePush.h>

@implementation BFirebasePushModule

-(void) activate {
    BFirebasePushHandler * pushHandler = [[BFirebasePushHandler alloc] init];
    [BNetworkManager sharedManager].a.push = pushHandler;
    pushHandler.tokenRefreshed = ^{
        [NM.core pushUser].thenOnMain(^id(id success) {
            [NM.core goOnline];
            return Nil;
        }, Nil);
    };
}

@end
