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
#import <ChatSDKFirebase/ChatSDKFirebase-Swift.h>

@implementation BFirebasePushHandler

@synthesize delegates = _delegates;

-(instancetype) init {
    if((self = [super init])) {
        _delegates = [NSMutableArray new];
        FIRMessaging.messaging.delegate = self;
        FIRMessaging.messaging.autoInitEnabled = YES;
    }
    return self;
}

-(void) messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
    for (id<FIRMessagingDelegate> delegate in _delegates) {
        if ([delegate respondsToSelector:@selector(messaging:didReceiveRegistrationToken:)]) {
            [delegate messaging:messaging didReceiveRegistrationToken:fcmToken];
        }
    }
}

- (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
//    NSLog(@"FCM registration token: %@", fcmToken);
//    for (id<FIRMessagingDelegate> delegate in _delegates) {
//        if ([delegate respondsToSelector:@selector(messaging:didRefreshRegistrationToken:)]) {
//            [delegate messaging:messaging didRefresh];
//        }
//    }
    
    

    
    
}

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [FIRMessaging messaging].APNSToken = deviceToken;
    [FIRMessaging.messaging tokenWithCompletion:^(NSString * token, NSError * error) {
        if (!error) {
            NSLog(@"FCM getToken %@", token);
            _apnsSet = YES;
            if (_channel) {
                [self subscribeToPushChannel:_channel];
            }
        } else {
            NSLog(@"FCM getToken %@", error.localizedDescription);
        }
    }];

    NSLog(@"FCM didRegisterForRemoteNotificationsWithDeviceToken");
}


-(void) subscribeToPushChannel: (NSString *) channel {
    if (_apnsSet) {
        NSLog(@"FCM Subscribe to channel: %@", channel);
        [[FIRMessaging messaging] subscribeToTopic:channel completion:^(NSError * error) {
            if (error) {
                NSLog(@"FCM Error %@", error.localizedDescription);
            } else {
                NSLog(@"FCM Success");
            }
        }];
    } else {
        _channel = channel;
    }
}

-(void) unsubscribeFromPushChannel: (NSString *) channel {
    _channel = nil;
    [[FIRMessaging messaging] unsubscribeFromTopic:channel completion:^(NSError * error) {
        NSLog(@"FCM Unsubscribe to channel: %@", channel);
    }];
}

-(void) sendPushNotification: (NSDictionary *) data {
    if(data) {
        [[FirebasePushModule.shared.functions HTTPSCallableWithName:@"pushToChannels"] callWithObject:data completion:^(FIRHTTPSCallableResult * result, NSError * error) {
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
}


@end

