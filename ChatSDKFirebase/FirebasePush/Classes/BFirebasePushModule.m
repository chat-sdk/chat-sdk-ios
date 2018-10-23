//
//  BFirebasePushHandlerModule.m
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 03/08/2017.
//  Copyright © 2017 deluge. All rights reserved.
//

#import "BFirebasePushModule.h"
#import <ChatSDKFirebase/FirebasePush.h>

@implementation BFirebasePushModule

-(void) activate {
    BFirebasePushHandler * pushHandler = [[BFirebasePushHandler alloc] init];
    [BNetworkManager sharedManager].a.push = pushHandler;
//    pushHandler.tokenRefreshed = ^{
//        [BChatSDK.core pushUser].thenOnMain(^id(id success) {
//            [BChatSDK.core goOnline];
//            return Nil;
//        }, Nil);
//    };
}

@end
