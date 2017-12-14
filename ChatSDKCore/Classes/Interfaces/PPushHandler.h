//
//  BPushHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 31/03/2016.
//
//

#ifndef PPushHandler_h
#define PPushHandler_h

#import <ChatSDK/PMessage.h>

// Setup some defines for push notifications
#define bAction @"action"
#define bAlert @"ios-alert"
#define bContent @"content"
#define bMessageEntityID @"message_entity_id"
#define bThreadEntityID @"thread_entity_id"
#define bMessageDate @"message_date"
#define bMessageSenderEntityID @"message_sender_entity_id"
#define bMessage_Type @"message_type"
#define bMessagePayload @"message_payload"
#define bBadge @"ios-badge"

#define bIOSSound @"ios-sound"
#define bDefault @"default"

@protocol PPushHandler <NSObject>

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

-(void) registerForPushNotificationsWithApplication: (UIApplication *) app launchOptions: (NSDictionary *) options;

-(void) subscribeToPushChannel: (NSString *) channel;
-(void) unsubscribeToPushChannel: (NSString *) channel;

-(void) pushToChannels: (NSArray *) channels withData:(NSDictionary *) data;
-(void) pushForMessage: (id<PMessage>) message;
-(void) pushToUsers: (NSArray *) users withData: (NSDictionary *) data;

@end

#endif /* PPushHandler_h */
