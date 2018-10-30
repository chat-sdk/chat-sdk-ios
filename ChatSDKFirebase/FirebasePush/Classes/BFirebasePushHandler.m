//
//  BFirebasePushHandler.m
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 02/08/2017.
//  Copyright © 2017 deluge. All rights reserved.
//

#import "BFirebasePushHandler.h"
#import <ChatSDK/Core.h>
#import <ChatSDKFirebase/FirebasePush.h>

@implementation BFirebasePushHandler

-(instancetype) init {
    if((self = [super init])) {
//        [FIRApp configure];
        [FIRMessaging messaging].delegate = self;
        
        [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
            id<PUser> user = data[bHookWillLogout_PUser];
            if (user) {
                [self unsubscribeFromPushChannel:user.pushChannel];
            }
        }] withName:bHookWillLogout];

        [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
            id<PUser> user = data[bHookDidAuthenticate_PUser];
            if (user) {
                [self subscribeToPushChannel:user.pushChannel];
            }
        }] withName:bHookDidAuthenticate];

        
//         Send a local notification when a message comes in
//        [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * value) {
//            id<PMessage> message = (id<PMessage>) value[bHookMessageReceived_PMessage];
//
//            if (!message.senderIsMe) {
//
//#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//
//                UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
//                content.title = [NSString localizedUserNotificationStringForKey:message.userModel.name arguments:nil];
//                content.body = [NSString localizedUserNotificationStringForKey:message.textString
//                                                                     arguments:nil];
//                content.sound = [UNNotificationSound defaultSound];
//
//                /// 4. update application icon badge number
//                content.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);
//
//                content.categoryIdentifier = bChatSDKNotificationCategory;
//
//                // Deliver the notification in five seconds.
//                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger
//                                                              triggerWithTimeInterval:10 repeats:NO];
//
//                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:message.entityID
//                                                                                      content:content
//                                                                                      trigger:trigger];
//                /// 3. schedule localNotification
//                UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//                [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
//                    if (!error) {
//                        NSLog(@"add NotificationRequest succeeded!");
//                    }
//                }];
//
//            }
//
//#endif
//
//        }] withName: bHookMessageRecieved];
//
    }
    return self;
}

-(void) registerForPushNotificationsWithApplication: (UIApplication *) app launchOptions: (NSDictionary *) options {
    
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

    UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];
    notificationDelegate = [[BLocalNotificationDelegate alloc] init];
    center.delegate = notificationDelegate;
    
    [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert
                                                                        completionHandler:^(BOOL granted, NSError * error) {
                                                                            if(granted) {
                                                                                NSLog(@"Local notifications granted");

                                                                                UNTextInputNotificationAction * replyAction = [UNTextInputNotificationAction actionWithIdentifier:bChatSDKReplyAction
                                                                                                                                                                            title:[NSBundle t: bReply]
                                                                                                                                                                          options:UNNotificationActionOptionNone
                                                                                                                                                             textInputButtonTitle:[NSBundle t: bSend]
                                                                                                                                                             textInputPlaceholder:[NSBundle t: bWriteSomething]];
                                                                                
                                                                                UNNotificationAction * openAction = [UNNotificationAction actionWithIdentifier:bChatSDKOpenAppAction
                                                                                                                                                         title:[NSBundle t:bOpen]
                                                                                                                                                       options:UNNotificationActionOptionForeground];
                                                                                
                                                                                UNNotificationCategory * category = [UNNotificationCategory categoryWithIdentifier:BChatSDK.config.pushNotificationAction ? BChatSDK.config.pushNotificationAction : bChatSDKNotificationCategory
                                                                                                                                                           actions:@[replyAction, openAction]
                                                                                                                                                 intentIdentifiers:@[]
                                                                                                                                                           options:UNNotificationCategoryOptionCustomDismissAction];

                                                                                NSSet * categories = [NSSet setWithObjects:category, nil];
                                                                                
                                                                                [center setNotificationCategories:categories];
                                                                                
                                                                                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * settings) {
                                                                                    NSLog(@"Settings");
                                                                                }];
                                                                                
                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                                                                                });

                                                                            }
    }];

#else
    

    UIUserNotificationType allNotificationTypes =
    (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    
    UIMutableUserNotificationAction * replyAction = [[UIMutableUserNotificationAction alloc] init];
    replyAction.identifier = bChatSDKReplyAction;
    replyAction.title = @"Reply";
    replyAction.activationMode = UIUserNotificationActivationModeBackground;
    replyAction.authenticationRequired = NO;
    replyAction.destructive = NO;
    replyAction.behavior = UIUserNotificationActionBehaviorTextInput;
    
    UIMutableUserNotificationAction * openAction = [[UIMutableUserNotificationAction alloc] init];
    openAction.identifier = bChatSDKOpenAppAction;
    openAction.title = @"Open App";
    openAction.activationMode = UIUserNotificationActivationModeBackground;
    openAction.authenticationRequired = NO;
    openAction.destructive = NO;
    openAction.behavior = UIUserNotificationActionBehaviorDefault;
    
    UIMutableUserNotificationCategory *notificationCategory = [[UIMutableUserNotificationCategory alloc] init];
    [notificationCategory setIdentifier:BChatSDK.config.pushNotificationAction ? BChatSDK.config.pushNotificationAction : bChatSDKNotificationCategory];
    
    [notificationCategory setActions:@[replyAction, openAction] forContext:UIUserNotificationActionContextDefault];
    [notificationCategory setActions:@[replyAction, openAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet * categories = [NSSet setWithArray:@[notificationCategory]];
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:categories];

    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];

#endif
    
    NSString *fcmToken = [FIRMessaging messaging].FCMToken;
    NSLog(@"FCM registration token: %@", fcmToken);
    
}

-(void) messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {

}

- (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSLog(@"FCM registration token: %@", fcmToken);
}


- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [FIRMessaging messaging].APNSToken = deviceToken;
    NSLog(@"Success");
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    if (application.applicationState != UIApplicationStateActive) {
        // TODO: Do we need to show the notficaiton?
        NSString * threadEntityID = userInfo[bPushThreadEntityID];
        if(threadEntityID) {
            id<PThread> thread = [BChatSDK.db fetchOrCreateEntityWithID:threadEntityID withType:bThreadEntity];
            
            if (BChatSDK.auth.userAuthenticatedThisSession) {
                [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationPresentChatView object:Nil userInfo: @{bNotificationPresentChatView_PThread: thread}];
            }
            else {
                BBackgroundPushAction * action = [BBackgroundPushAction actionWithType:bPushActionTypeOpenThread payload:@{bPushThreadEntityID: threadEntityID}];
                [BChatSDK.shared.pushQueue addToQueue:action];
            }
        }
//    }
}

-(void) subscribeToPushChannel: (NSString *) channel {
    [[FIRMessaging messaging] subscribeToTopic:channel];
}

-(void) unsubscribeFromPushChannel: (NSString *) channel {
    [[FIRMessaging messaging] unsubscribeFromTopic:channel];
}

-(void) pushForMessage: (id<PMessage>) message {
    
    if (!message.textString || !message.textString.length || !BChatSDK.config.clientPushEnabled) {
        return;
    }
    
    // Get a list of recipients
    NSMutableDictionary * users = [NSMutableDictionary new];
    for(id<PUser> user in message.thread.users) {
        if(!user.isMe && user.entityID && user.entityID.length && user.name && user.name.length) {
            if (!user.online.boolValue || !BChatSDK.config.onlySendPushToOfflineUsers) {
                users[user.pushChannel] = user.name;
            }
        }
    }
    
    if(!users.allKeys.count) {
        return;
    }
    
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithDictionary: @{@"userIds" : users,
                                                                                  @"body": message.textString,
                                                                                  @"type": message.type,
                                                                                  @"senderId": message.userModel.entityID,
                                                                                  @"threadId": message.thread.entityID,
                                                                                  @"action": BChatSDK.config.pushNotificationAction ? BChatSDK.config.pushNotificationAction : bChatSDKNotificationCategory,
                                                                                  }];
    
    if(BChatSDK.config.pushNotificationSound) {
        data[@"sound"] = BChatSDK.config.pushNotificationSound;
    }
    
    [[[FIRFunctions functions] HTTPSCallableWithName:@"pushToChannels"] callWithObject:data completion:^(FIRHTTPSCallableResult * result, NSError * error) {
        if (error) {
            if (error.domain == FIRFunctionsErrorDomain) {
                FIRFunctionsErrorCode code = error.code;
                NSString *message = error.localizedDescription;
                NSObject *details = error.userInfo[FIRFunctionsErrorDetailsKey];
            }
            // ...
        }
        else {
            NSLog(@"Success");
        }
    }];

}


@end
