//
//  BAbstractCoreHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import <Foundation/Foundation.h>

#import <ChatSDK/PCoreHandler.h>

@interface BAbstractCoreHandler : NSObject<PCoreHandler> {
    id<PUser> _currentUser;
    NSString * _currentUserEntityID;
}

-(id<PThread>) createThreadWithUsers: (NSArray *) users name: (NSString *) name;
-(id<PThread>) createThreadWithUsers: (NSArray *) users name: (NSString *) name type: (bThreadType) type;

-(RXPromise *) prepareSendMessage: (id<PMessage>) messageModel;
-(RXPromise *) updateThread: (id<PThread>) threadModel dataPushed: (void(^)(NSError * error, id<PThread> thread)) dataPushed;
@end
