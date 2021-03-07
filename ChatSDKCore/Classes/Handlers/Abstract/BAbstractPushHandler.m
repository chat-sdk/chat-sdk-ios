//
//  BAbstractPushHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BAbstractPushHandler.h"

#import <UserNotifications/UserNotifications.h>
#import <ChatSDK/Core.h>

@implementation BAbstractPushHandler

-(instancetype) init {
    if((self = [super init])) {
        [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
            id<PUser> user = data[bHook_PUser];
            if (user) {
                [self unsubscribeFromPushChannel:user.pushChannel];
            }
        }] withName:bHookWillLogout];
        
        [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
            id<PUser> user = data[bHook_PUser];
            if (user) {
                [self subscribeToPushChannel:user.pushChannel];
            }
        }] withName:bHookDidAuthenticate];
        
    }
    return self;
}

-(void) registerForPushNotificationsWithApplication: (UIApplication *) app launchOptions: (NSDictionary *) options {
    
        UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];
        notificationDelegate = [[BLocalNotificationDelegate alloc] init];
        center.delegate = notificationDelegate;
        
        void (^handler)(BOOL, NSError *) = ^(BOOL granted, NSError * error) {
            if(granted) {
                [BChatSDK.shared.logger log:@"Local notifications granted"];
                
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
        };
        
        [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert
                              completionHandler:handler];
        
}

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    assert(NO);
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSString * threadEntityID = userInfo[bPushThreadEntityID];
    if(threadEntityID) {
        id<PThread> thread = [BChatSDK.db fetchEntityWithID:threadEntityID withType:bThreadEntity];
        
        // TODO: Check this
        // If the thread is muted, don't show the push
        if (!thread || thread.meta[bMute]) {
            return;
        }
        
        if (BChatSDK.auth.isAuthenticatedThisSession) {
            [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationPresentChatView object:Nil userInfo: @{bNotificationPresentChatView_PThread: thread}];
        }
        else {
            BBackgroundPushAction * action = [BBackgroundPushAction actionWithType:bPushActionTypeOpenThread payload:@{bPushThreadEntityID: threadEntityID}];
            [BChatSDK.shared.pushQueue addToQueue:action];
        }
    }
}

-(void) subscribeToPushChannel: (NSString *) channel {
    assert(NO);
}

-(void) unsubscribeFromPushChannel: (NSString *) channel {
    assert(NO);
}


-(NSDictionary *) pushDataForMessage: (id<PMessage>) message {
    
    if (!BChatSDK.config.clientPushEnabled) {
        return Nil;
    }

    NSString * text = message.text;
    if (!text) {
        text = @"";
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
        return Nil;
    }
    
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithDictionary: @{@"userIds" : users,
                                                                                  @"body": text,
                                                                                  @"type": message.type,
                                                                                  @"senderName": BChatSDK.currentUser.name,
                                                                                  @"senderId": message.userModel.entityID,
                                                                                  @"threadId": message.thread.entityID,
                                                                                  @"action": BChatSDK.config.pushNotificationAction ? BChatSDK.config.pushNotificationAction : bChatSDKNotificationCategory,
                                                                                  }];
    
    if (BChatSDK.encryption) {
        data[@"encrypted-message"] = message.meta[@"encrypted-message"];
    }
    
    if(BChatSDK.config.pushNotificationSound) {
        data[@"sound"] = BChatSDK.config.pushNotificationSound;
    }
    
    return data;
}

-(void) sendPushNotification: (NSDictionary *) data {
    assert(NO);
}




@end
