//
//  BLocalNotificationHandler.h
//  AFNetworking
//
//  Created by ben3 on 13/12/2019.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PThread;

@interface BLocalNotificationHandler : NSObject

-(BOOL) showLocalNotification: (id<PThread>) thread;

@end

NS_ASSUME_NONNULL_END
