//
//  BFirebasePushHandler.h
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 02/08/2017.
//  Copyright © 2017 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ChatSDK/BAbstractPushHandler.h>
#import <FirebaseMessaging/FirebaseMessaging.h>

@class BLocalNotificationDelegate;

@interface BFirebasePushHandler : BAbstractPushHandler<FIRMessagingDelegate> {
    NSString * _userPushToken;
    BOOL _authFinished;
    
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    BLocalNotificationDelegate * notificationDelegate;
#endif
    
}

@property (nonatomic, readwrite) void(^tokenRefreshed)();

@end
