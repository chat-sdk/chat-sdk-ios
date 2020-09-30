//
//  BAbstractThreadHandler.h
//  AFNetworking
//
//  Created by ben3 on 06/07/2020.
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PThreadHandler.h>

NS_ASSUME_NONNULL_BEGIN

@interface BAbstractThreadHandler : NSObject<PThreadHandler>

-(id<PThread>) createThreadWithUsers: (NSArray *) users name: (NSString *) name;
-(id<PThread>) createThreadWithUsers: (NSArray *) users name: (NSString *) name type: (bThreadType) type;

-(RXPromise *) prepareSendMessage: (id<PMessage>) messageModel;


@end

NS_ASSUME_NONNULL_END
