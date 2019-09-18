//
//  BHookNotification.h
//  AFNetworking
//
//  Created by Ben on 12/13/18.
//

#import <Foundation/Foundation.h>

@protocol PUser;
@protocol PThread;
@protocol PMessage;

@interface BHookNotification : NSObject

+(void) notificationMessageWillSend: (id<PMessage>) message;
+(void) notificationMessageSending: (id<PMessage>) message;
+(void) notificationMessageDidSend: (id<PMessage>) message;
+(void) notificationMessageWillUpload: (id<PMessage>) message;
+(void) notificationMessageDidUpload: (id<PMessage>) message;
+(void) notificationMessageReceived: (id<PMessage>) message;

+(void) notificationContactWillBeAdded: (id<PUser>) user;
+(void) notificationContactWasAdded: (id<PUser>) user;
+(void) notificationContactWillBeDeleted: (id<PUser>) user;
+(void) notificationContactWasDeleted: (id<PUser>) user;

+(void) notificationMessageWillBeDeleted: (id<PMessage>) message;
+(void) notificationMessageWasDeleted;

+(void) notificationDidAuthenticate: (id<PUser>) user type: (NSString *) type;
+(void) notificationWillLogout: (id<PUser>) user;
+(void) notificationDidLogout: (id<PUser>) user;
+(void) notificationUserOn: (id<PUser>) user;
+(void) notificationInternetConnectivityDidChange;
+(void) notificationUserWillDisconnect;

+(void) notificationThreadAdded: (id<PThread>) thread;
+(void) notificationThreadRemoved: (id<PThread>) thread;

@end
