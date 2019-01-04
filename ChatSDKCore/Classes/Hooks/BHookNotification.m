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

+(void) notificationMessageDidSend: (id<PMessage>) message {
    [BChatSDK.hook executeHookWithName:bHookMessageDidSend data:@{bHook_PMessage: message}];
}

+(void) notificationMessageWillUpload: (id<PMessage>) message {
    [BChatSDK.hook executeHookWithName:bHookMessageWillUpload data:@{bHook_PMessage: message}];
}

+(void) notificationMessageDidUpload: (id<PMessage>) message {
    [BChatSDK.hook executeHookWithName:bHookMessageDidUpload data:@{bHook_PMessage: message}];
}

+(void) notificationMessageReceived: (id<PMessage>) message {
    [BChatSDK.hook executeHookWithName:bHookMessageRecieved data:@{bHook_PMessage: message}];
}


@end
