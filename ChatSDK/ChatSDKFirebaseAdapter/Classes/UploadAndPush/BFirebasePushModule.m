//
//  BFirebasePushHandlerModule.m
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 03/08/2017.
//  Copyright © 2017 deluge. All rights reserved.
//

#import "BFirebasePushModule.h"
#import "BFirebasePushHandler.h"
#import <ChatSDKCore/ChatCore.h>

@implementation BFirebasePushModule

-(void) activate {
    BFirebasePushHandler * pushHandler = [[BFirebasePushHandler alloc] init];
    // We add this here because with different backends we may do different things
    pushHandler.tokenRefreshed = ^{
        [NM.core pushUser];
    };
    [BNetworkManager sharedManager].a.push = pushHandler;
}


@end
