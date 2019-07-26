//
//  BHookNotification.m
//  AFNetworking
//
//  Created by Ben on 12/13/18.
//

#import "BHookNotification.h"
#import <ChatSDK/Core.h>

@implementation BHookNotification

+(void) notificationMessageWillSend: (id<PMessage>) message {
    [BChatSDK.hook executeHookWithName:bHookMessageWillSend data:@{bHook_PMessage: message}];
}

+(void) notificationMessageSending: (id<PMessage>) message {
    [BChatSDK.hook executeHookWithName:bHookMessageSending data:@{bHook_PMessage: message}];
}

+(void) notificationMessageDidSend: (id<PMessage>) message {
    [BChatSDK.hook executeHookWithName:bHookMessageDidSend data:@{bHook_PMessage: message}];
}

+(void) notificationMessageWillUpload: (id<PMessage>) message {
    [BChatSDK.hook executeHookWithName:bHookMessageWillUpload data:@{bHook_PMessage: message}];
}

+(void) notificationMessageDidUpload: (id<PMessage>) message {
    [BChatSDK.hook executeHookWithName:bHookMessageDidUpload data:@{bHook_PMessage: message}];
}

+(void) notificationMessageWillBeDeleted: (id<PMessage>) message {
    [BChatSDK.hook executeHookWithName:bHookMessageWillBeDeleted data:@{bHook_PMessage: message}];
}

+(void) notificationMessageWasDeleted {
    [BChatSDK.hook executeHookWithName:bHookMessageWasDeleted data:@{}];
}

+(void) notificationMessageReceived: (id<PMessage>) message {
    [BChatSDK.hook executeHookWithName:bHookMessageRecieved data:@{bHook_PMessage: message}];
}

+(void) notificationDidAuthenticate: (id<PUser>) user {
    [BChatSDK.hook executeHookWithName:bHookDidAuthenticate data:@{bHook_PUser: user}];
}

+(void) notificationDidAuthenticate: (id<PUser>) user type: (NSString *) type {
    if (!type) {
        type = bHook_AuthenticationTypeCached;
    }
    [BChatSDK.hook executeHookWithName:bHookDidAuthenticate data:@{bHook_PUser: user, bHook_AuthenticationType: type}];
}

+(void) notificationWillLogout: (id<PUser>) user {
    [BChatSDK.hook executeHookWithName:bHookWillLogout data:@{bHook_PUser:user}];
}

+(void) notificationDidLogout: (id<PUser>) user {
    [BChatSDK.hook executeHookWithName:bHookDidLogout data:@{bHook_PUser:user}];
}

+(void) notificationUserOn: (id<PUser>) user {
    [BChatSDK.hook executeHookWithName:bHookUserOn data:@{bHook_PUser:user}];
}

+(void) notificationContactWillBeAdded: (id<PUser>) user {
    [BChatSDK.hook executeHookWithName:bHookContactWillBeAdded data:@{bHook_PUser:user}];
}

+(void) notificationContactWasAdded: (id<PUser>) user {
    [BChatSDK.hook executeHookWithName:bHookContactWasAdded data:@{bHook_PUser:user}];
}

+(void) notificationContactWillBeDeleted: (id<PUser>) user {
    [BChatSDK.hook executeHookWithName:bHookContactWillBeDeleted data:@{bHook_PUser:user}];
}

+(void) notificationContactWasDeleted: (id<PUser>) user {
    [BChatSDK.hook executeHookWithName:bHookContactWasDeleted data:@{bHook_PUser:user}];
}

+(void) notificationInternetConnectivityDidChange {
    [BChatSDK.hook executeHookWithName:bHookInternetConnectivityDidChange data:@{}];
}

+(void) notificationUserWillDisconnect {
    [BChatSDK.hook executeHookWithName:bHookUserWillDisconnect data:@{}];
}

+(void) notificationThreadAdded: (id<PThread>) thread {
    [BChatSDK.hook executeHookWithName:bHookThreadAdded data:@{bHook_PThread:thread}];
}

+(void) notificationThreadRemoved: (id<PThread>) thread {
    [BChatSDK.hook executeHookWithName:bHookThreadRemoved data:@{bHook_PThread:thread}];
}



@end
