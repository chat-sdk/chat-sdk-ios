//
//  BAbstractPushHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BAbstractPushHandler.h"

#import <ChatSDKCore/ChatCore.h>

@implementation BAbstractPushHandler

// Check when recipients was last online
// Don't use push notifications for public threads because
// they could have hundreds of users and we don't want to be spammed
// with push notifications
-(void) pushForMessage: (id<PMessage>) message {
    if (message.thread.type.intValue & bThreadFilterPrivate) {
        [self pushToUsers:message.thread.users.allObjects withMessage:message];
    }
}

-(void) pushToUsers: (NSArray *) users withMessage: (id<PMessage>) message {
    
    // We're identifying each user using push channels. This means that
    // when a user signs up, they register with parse on a particular
    // channel. In this case user_[user id] this means that we can
    // send a push to a specific user if we know their user id.
    NSMutableArray * userChannels = [NSMutableArray new];
    id<PUser> currentUserModel = NM.currentUser;
    for (id<PUser> user in users) {
        if(![user isEqual:currentUserModel] && !user.online.boolValue)
            [userChannels addObject:user.pushChannel];
    }
    
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
    
    text = [NSString stringWithFormat:@"%@: %@", message.userModel.name, text];
    
    // How can we increment the badge number wih backendless
    NSDictionary * dict = @{bAction: @"",
                            bContent: text,
                            bAlert: text,
                            bMessageEntityID: message.entityID,
                            bThreadEntityID: message.thread.entityID,
                            bMessageDate: [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]],
                            bMessageSenderEntityID:message.userModel.entityID,
                            bMessage_Type: message.type.stringValue,
                            // TODO: Check this
                            bMessagePayload: message.textString,
                            bBadge: @"Increment",
                            bIOSSound: bDefault};
    
    [self pushToChannels:userChannels withData:dict];
}

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    assert(NO);
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    assert(NO);
}

-(void) registerForPushNotificationsWithApplication: (UIApplication *) app launchOptions: (NSDictionary *) options {
    assert(NO);
}

-(void) subscribeToPushChannel: (NSString *) channel {
    assert(NO);
}

-(void) unsubscribeToPushChannel: (NSString *) channel {
    assert(NO);
}

-(void) pushToChannels: (NSArray *) channels withData:(NSDictionary *) data {
    assert(NO);
}

-(NSString *) safeChannel: (NSString *) channel {
    return [[channel stringByReplacingOccurrencesOfString:@"@" withString:@"a"] stringByReplacingOccurrencesOfString:@"." withString:@"d"];
}


@end
