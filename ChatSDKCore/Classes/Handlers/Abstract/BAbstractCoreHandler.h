//
//  BAbstractCoreHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import <Foundation/Foundation.h>

#import <ChatSDK/PCoreHandler.h>

@interface BAbstractCoreHandler : NSObject<PCoreHandler>

-(id<PThread>) createThreadWithUsers: (NSArray *) users name: (NSString *) name;

@end
