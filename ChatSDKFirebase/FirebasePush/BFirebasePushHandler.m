//
//  BFirebasePushHandler.m
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 02/08/2017.
//  Copyright © 2017 deluge. All rights reserved.
//

#import "BFirebasePushHandler.h"
#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import <ChatSDK/ChatCore.h>

#define bPushThreadEntityID @"chat_sdk_thread_entity_id"
#define bPushUserEntityID @"chat_sdk_user_entity_id"

@implementation BFirebasePushHandler

-(instancetype) init {
    if((self = [super init])) {
//        [FIRApp configure];
        [FIRMessaging messaging].delegate = self;
    }
    return self;
}

-(void) registerForPushNotificationsWithApplication: (UIApplication *) app launchOptions: (NSDictionary *) options {
    

//    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    } else {
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//        // For iOS 10 display notification (sent via APNS)
//        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
//        UNAuthorizationOptions authOptions =
//        UNAuthorizationOptionAlert
//        | UNAuthorizationOptionSound
//        | UNAuthorizationOptionBadge;
//        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        }];
#endif
//    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
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
    if (application.applicationState != UIApplicationStateActive) {
        // TODO: Do we need to show the notficaiton?
        NSString * threadEntityID = userInfo[bPushThreadEntityID];
        if(threadEntityID) {
            id<PThread> thread = [[BStorageManager sharedManager].a fetchOrCreateEntityWithID:threadEntityID withType:bThreadEntity];
            [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationPresentChatView object:Nil userInfo: @{bNotificationPresentChatView_PThread: thread}];
        }
    }
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
    NSString * text = message.textString;
    
    if (message.type.intValue == bMessageTypeLocation) {
        text = [NSBundle core_t:bLocationMessage];
    }
    if (message.type.intValue == bMessageTypeImage) {
        text = [NSBundle core_t:bImageMessage];
    }
    if (message.type.intValue == bMessageTypeAudio) {
        text = [NSBundle core_t:bAudioMessage];
    }
    if (message.type.intValue == bMessageTypeVideo) {
        text = [NSBundle core_t:bVideoMessage];
    }
    if (message.type.intValue == bMessageTypeSticker) {
        text = [NSBundle core_t:bStickerMessage];
    }
    
//    text = [NSString stringWithFormat:@"%@: %@", message.userModel.name, text];
    
    // How can we increment the badge number wih backendless
//    NSDictionary * dict = @{bAction: @"",
//                            bContent: text,
//                            bAlert: text,
//                            bMessageEntityID: message.entityID,
//                            bThreadEntityID: message.thread.entityID,
//                            bMessageDate: [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]],
//                            bMessageSenderEntityID:message.userModel.entityID,
//                            bMessage_Type: message.type.stringValue,
//                            // TODO: Check this
//                            bMessagePayload: message.textString,
//                            bBadge: @"Increment",
//                            bIOSSound: bDefault};
//
    NSDictionary * dict = @{@"title": message.userModel.name,
                            @"body": text,
                            @"badge": @1,
                            bPushThreadEntityID: message.thread.entityID,
                            bPushUserEntityID: message.userModel.entityID};

    [self pushToUsers:users withData:dict];
}

-(void) pushToUsers: (NSArray *) users withData: (NSDictionary *) data {
    // We're identifying each user using push channels. This means that
    // when a user signs up, they register with parse on a particular
    // channel. In this case user_[user id] this means that we can
    // send a push to a specific user if we know their user id.
    NSMutableArray * userChannels = [NSMutableArray new];
    id<PUser> currentUserModel = NM.currentUser;
    for (id<PUser> user in users) {
        NSString * pushToken = [user metaValueForKey:bUserPushTokenKey];
        if(![user isEqual:currentUserModel] && pushToken /* && !user.online.boolValue */)
            [userChannels addObject:pushToken];
    }
    
    [self pushToChannels:userChannels withData:data];

}

-(void) pushToChannels: (NSArray *) channels withData:(NSDictionary *) data {
    
//    NSString * topic = @"";
//    for(NSString * channel in channels) {
//        NSString * t = [NSString stringWithFormat:@"'%@' in topics", [self safeChannel:channel]];
//        topic = [topic stringByAppendingString:t];
//        if(![channel isEqualToString:channels.lastObject]) {
//            topic = [topic stringByAppendingString:@" && "];
//        }
//    }

    NSString * serverKey = [NSString stringWithFormat:@"key=%@", [BSettingsManager firebaseCloudMessagingServerKey]];

    for(NSString * channel in channels) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [requestSerializer setValue:serverKey forHTTPHeaderField:@"Authorization"];
        
        manager.requestSerializer = requestSerializer;
        
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        NSDictionary *params = @{@"to": channel,
                                 @"notification": data,
                                 @"data": data};
        
        [manager POST:@"https://fcm.googleapis.com/fcm/send" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    
}


@end
