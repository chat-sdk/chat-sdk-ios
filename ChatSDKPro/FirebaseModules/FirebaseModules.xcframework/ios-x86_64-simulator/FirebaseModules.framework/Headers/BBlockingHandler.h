//
//  BBroadcastHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 30/05/2017.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDK/Core.h>

@class RXPromise;

@interface BBlockingHandler : NSObject<PBlockingHandler> {
    NSMutableArray * _blockedUsers;
}



@end
