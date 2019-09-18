//
//  BLocalNotificationDelegate.h
//  ChatSDKSwift
//
//  Created by Ben on 4/19/18.
//  Copyright © 2018 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

@import UserNotifications;

@interface BLocalNotificationDelegate : NSObject<UNUserNotificationCenterDelegate>


@end

#endif
