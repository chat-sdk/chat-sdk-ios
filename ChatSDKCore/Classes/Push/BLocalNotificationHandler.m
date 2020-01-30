//
//  BLocalNotificationHandler.m
//  AFNetworking
//
//  Created by ben3 on 13/12/2019.
//

#import "BLocalNotificationHandler.h"
#import <ChatSDK/Core.h>

@implementation BLocalNotificationHandler

-(BOOL) showLocalNotification: (id<PThread>) thread {
    return BChatSDK.config.showLocalNotifications;
}

@end
