//
//  BHookNotification.h
//  AFNetworking
//
//  Created by Ben on 12/13/18.
//

#import <Foundation/Foundation.h>

@protocol PMessage;

@interface BHookNotification : NSObject

+(void) notificationMessageWillSend: (id<PMessage>) message;
+(void) notificationMessageDidSend: (id<PMessage>) message;
+(void) notificationMessageWillUpload: (id<PMessage>) message;
+(void) notificationMessageDidUpload: (id<PMessage>) message;
+(void) notificationMessageReceived: (id<PMessage>) message;

@end
