//
//  BLocalNotificationDelegate.m
//  ChatSDKSwift
//
//  Created by Ben on 4/19/18.
//  Copyright © 2018 deluge. All rights reserved.
//

#import "BLocalNotificationDelegate.h"

#import <ChatSDK/Core.h>

@implementation BLocalNotificationDelegate

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    
    BOOL showLocalNotification = BChatSDK.config.showLocalNotifications;
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSString * threadEntityID = userInfo[bPushThreadEntityID];
    if (threadEntityID) {
        id<PThread> thread = [BChatSDK.db fetchEntityWithID:threadEntityID withType:bThreadEntity];
        if (thread) {
            showLocalNotification = [BChatSDK.ui showLocalNotification:thread];

            // Check if we show notifications for public threads
            if (thread.type.intValue & bThreadFilterPublic) {
                showLocalNotification = showLocalNotification && BChatSDK.config.showLocalNotificationsForPublicChats;
            }
            
            // Check if the thread is muted
            showLocalNotification = showLocalNotification && !thread.meta[bMute];
        } else {
            showLocalNotification = NO;
        }
        
        if (showLocalNotification) {
            completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
        }
    }

}

// The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from application:didFinishLaunchingWithOptions:.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler  {
    NSDictionary * userInfo = [NSMutableDictionary dictionaryWithDictionary:response.notification.request.content.userInfo];

    if ([response.actionIdentifier isEqualToString:bChatSDKReplyAction]) {
        if ([response isKindOfClass:[UNTextInputNotificationResponse class]]) {
            UNTextInputNotificationResponse * inputResponse = (UNTextInputNotificationResponse *) response;
            NSString * text = inputResponse.userText;
            NSString * threadEntityID = userInfo[bPushThreadEntityID];
            
            if (threadEntityID && text) {

                UIBackgroundTaskIdentifier taskIndentifier = UIBackgroundTaskInvalid;
                taskIndentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                    [[UIApplication sharedApplication] endBackgroundTask:taskIndentifier];
                }];
                [BChatSDK.thread sendMessageWithText:text withThreadEntityID:threadEntityID].then(^id(id result) {
                    [[UIApplication sharedApplication] endBackgroundTask:taskIndentifier];
                    return Nil;
                }, ^id(NSError * error) {
                    [[UIApplication sharedApplication] endBackgroundTask:taskIndentifier];
                    return Nil;
                });
            }
        }
        completionHandler();
    }
    else {
        [BChatSDK application:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
    }

}

@end

