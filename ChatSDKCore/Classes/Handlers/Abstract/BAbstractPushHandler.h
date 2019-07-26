//
//  BAbstractPushHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PPushHandler.h>

@class BLocalNotificationDelegate;

#define bChatSDKNotificationCategory @"co.chatsdk.QuickReply"
#define bChatSDKReplyAction @"co.chatsdk.ReplyAction"
#define bChatSDKOpenAppAction @"co.chatsdk.OpenAppAction"

@interface BAbstractPushHandler : NSObject<PPushHandler> {
    BLocalNotificationDelegate * notificationDelegate;
}

-(NSString *) safeChannel: (NSString *) channel;

@end
