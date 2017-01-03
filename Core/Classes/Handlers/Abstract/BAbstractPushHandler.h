//
//  BAbstractPushHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PPushHandler.h>

@interface BAbstractPushHandler : NSObject<PPushHandler>

-(NSString *) safeChannel: (NSString *) channel;

@end
