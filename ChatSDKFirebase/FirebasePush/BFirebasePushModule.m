//
//  BFirebasePushHandlerModule.m
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 03/08/2017.
//  Copyright © 2017 deluge. All rights reserved.
//

#import "BFirebasePushModule.h"
#import "BFirebasePushHandler.h"
#import <ChatSDK/ChatCore.h>
#import "BFirebaseUploadHandler.h"
#import <Firebase/Firebase.h>

@implementation BFirebasePushModule

-(void) activateForFirebaseWithApplication: (UIApplication *) application withOptions: (NSDictionary *) launchOptions {
    BFirebasePushHandler * pushHandler = [[BFirebasePushHandler alloc] init];
    // We add this here because with different backends we may do different things
    pushHandler.tokenRefreshed = ^{
        [NM.core pushUser];
    };
    [BNetworkManager sharedManager].a.push = pushHandler;
    [pushHandler registerForPushNotificationsWithApplication:application launchOptions:launchOptions];
}

-(void) activateForXMPPWithApplication: (UIApplication *) application withOptions: (NSDictionary *) launchOptions {
    BFirebasePushHandler * pushHandler = [[BFirebasePushHandler alloc] init];
    // We add this here because with different backends we may do different things
    pushHandler.tokenRefreshed = ^{
//        [NM.core goOnline];
        [NM.core pushUser].thenOnMain(^id(id success) {
            [NM.core goOnline];
            return Nil;
        }, Nil);
    };
    [BNetworkManager sharedManager].a.push = pushHandler;
    [pushHandler registerForPushNotificationsWithApplication:application launchOptions:launchOptions];
}

@end
