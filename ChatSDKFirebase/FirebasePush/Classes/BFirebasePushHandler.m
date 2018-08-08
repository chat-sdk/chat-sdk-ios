//
//  BFirebasePushHandler.m
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 02/08/2017.
//  Copyright © 2017 deluge. All rights reserved.
//

#import "BFirebasePushHandler.h"
#import <ChatSDK/Core.h>
#import <ChatSDK/FirebasePush.h>

@implementation BFirebasePushHandler

-(instancetype) init {
    if((self = [super init])) {
//        [FIRApp configure];
        [FIRMessaging messaging].delegate = self;
        
//         Send a local notification when a message comes in
//        [NM.hook addHook:[BHook hook:^(NSDictionary * value) {
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
    
    _userPushToken = fcmToken;

    // Set the push key when authentication finishes
    BHook * hook = [BHook hook:^(NSDictionary * data) {
        _authFinished = YES;
        
        if(self.tokenRefreshed != Nil && [self updateUserPushToken]) {
            self.tokenRefreshed();
        }
    }];
    
    [NM.hook addHook:hook withName:bHookUserAuthFinished];
    
//    [NM.currentUser setMetaValue:fcmToken forKey:@""];
    
}

-(void) messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    _userPushToken = fcmToken;
    if(_authFinished && self.tokenRefreshed != Nil && [self updateUserPushToken]) {
        self.tokenRefreshed();
    }
}

- (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSLog(@"FCM registration token: %@", fcmToken);
    
    _userPushToken = fcmToken;
    
    if(_authFinished && self.tokenRefreshed != Nil && [self updateUserPushToken]) {
        self.tokenRefreshed();
    }
}


- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [FIRMessaging messaging].APNSToken = deviceToken;
    NSLog(@"Success");
}

-(BOOL) updateUserPushToken {
    if(_userPushToken && _userPushToken.length && NM.currentUser) {
        NSString * currentToken = [NM.currentUser metaValueForKey:bUserPushTokenKey];
        if(![currentToken isEqualToString: _userPushToken]) {
            [NM.currentUser setMetaValue:_userPushToken forKey:bUserPushTokenKey];
            return YES;
        }
    }
    return NO;
}


- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    if (application.applicationState != UIApplicationStateActive) {
        // TODO: Do we need to show the notficaiton?
        NSString * threadEntityID = userInfo[bPushThreadEntityID];
        if(threadEntityID) {
            id<PThread> thread = [[BStorageManager sharedManager].a fetchOrCreateEntityWithID:threadEntityID withType:bThreadEntity];
            [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationPresentChatView object:Nil userInfo: @{bNotificationPresentChatView_PThread: thread}];
        }
//    }
}

-(void) subscribeToPushChannel: (NSString *) channel {
    NSString * safeChannel = [self safeChannel:channel];
    [[FIRMessaging messaging] subscribeToTopic:safeChannel];
}

-(void) unsubscribeToPushChannel: (NSString *) channel {
    NSString * safeChannel = [self safeChannel:channel];
    [[FIRMessaging messaging] unsubscribeFromTopic:safeChannel];
}

-(void) pushToUsers: (NSArray *) users withMessage: (id<PMessage>) message {
    
    // Format the message that we're going to push
    NSString * text = [NSBundle textForMessage: message];
    
    NSString * title = message.userModel.name ? message.userModel.name : @"";
    
    NSDictionary * data = @{
//                            @"title": title,
//                            @"body": text ? text : @"",
                            bPushThreadEntityID: message.thread.entityID,
                            bPushUserEntityID: message.userModel.entityID};
    
    NSDictionary * notification = @{@"title": title,
                                    @"body": text ? text : @"",
                                    @"badge": @1,
                                    @"priority": @"high",
                                    @"click_action": BChatSDK.config.pushNotificationAction ? BChatSDK.config.pushNotificationAction : bChatSDKNotificationCategory};

    [self pushToUsers:users withNotification: notification withData:data];
}

-(void) pushToUsers: (NSArray *) users withNotification: (NSDictionary *) notification withData: (NSDictionary *) data {
    // We're identifying each user using push channels. This means that
    // when a user signs up, they register with parse on a particular
    // channel. In this case user_[user id] this means that we can
    // send a push to a specific user if we know their user id.
    NSMutableArray * userChannels = [NSMutableArray new];
    id<PUser> currentUserModel = NM.currentUser;
    for (id<PUser> user in users) {
        NSString * pushToken = [user metaValueForKey:bUserPushTokenKey];
        if(![user isEqual:currentUserModel] && pushToken && (!user.online.boolValue || !BChatSDK.config.onlySendPushToOfflineUsers))
            [userChannels addObject:pushToken];
    }
    
    [self pushToChannels:userChannels withNotification:notification withData:data];

}

-(void) pushToChannels: (NSArray *) channels withNotification: (NSDictionary *) notification withData:(NSDictionary *) data {
    
    if (!BChatSDK.config.clientPushEnabled) {
        return;
    }
    
    NSString * serverKey = [NSString stringWithFormat:@"key=%@", BChatSDK.config.firebaseCloudMessagingServerKey];

    for(NSString * channel in channels) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [requestSerializer setValue:serverKey forHTTPHeaderField:@"Authorization"];
        
        manager.requestSerializer = requestSerializer;
        
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        NSDictionary *params = @{@"to": channel,
                                 @"notification": notification,
                                 @"data": data,
                                 @"sound": [BChatSDK config].pushNotificationSound,
//                                 @"apns": @{
//                                         @"notification": notification
//                                         }
                                 };
        
        [manager POST:@"https://fcm.googleapis.com/fcm/send" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    
}

@end
