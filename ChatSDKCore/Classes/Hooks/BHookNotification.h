//
//  BHookNotification.h
//  AFNetworking
//
//  Created by Ben on 12/13/18.
//

#import <Foundation/Foundation.h>

@protocol PMessage;
@protocol PUser;

@interface BHookNotification : NSObject

+(void) notificationMessageWillSend: (id<PMessage>) message;
+(void) notificationMessageDidSend: (id<PMessage>) message;
+(void) notificationMessageWillUpload: (id<PMessage>) message;
+(void) notificationMessageDidUpload: (id<PMessage>) message;
+(void) notificationMessageReceived: (id<PMessage>) message;

+(void) notificationContactWillBeAdded: (id<PUser>) user;
+(void) notificationContactWasAdded: (id<PUser>) user;
+(void) notificationContactWillBeDeleted: (id<PUser>) user;
+(void) notificationContactWasDeleted: (id<PUser>) user;

+(void) notificationDidAuthenticate: (id<PUser>) user;
+(void) notificationWillLogout: (id<PUser>) user;
+(void) notificationDidLogout: (id<PUser>) user;
+(void) notificationUserOn: (id<PUser>) user;
+(void) notificationInternetConnectivityDidChange;

@end
