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
        [FIRMessaging messaging].delegate = self;
    }
    return self;
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


-(void) subscribeToPushChannel: (NSString *) channel {
    [[FIRMessaging messaging] subscribeToTopic:channel];
}

-(void) unsubscribeFromPushChannel: (NSString *) channel {
    [[FIRMessaging messaging] unsubscribeFromTopic:channel];
}

-(void) sendPushNotification: (NSDictionary *) data {
    if(data) {
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
}


@end
