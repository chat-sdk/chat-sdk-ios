//
//  BFirebaseModerationHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PModerationHandler.h>

@interface BFirebaseModerationHandler : NSObject<PModerationHandler>

@property (nonatomic, readwrite) NSMutableArray *flaggedMessages;

@end
