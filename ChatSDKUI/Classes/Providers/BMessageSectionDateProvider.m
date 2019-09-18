//
//  BMessageSectionDateProvider.m
//  AFNetworking
//
//  Created by ben3 on 14/08/2019.
//

#import "BMessageSectionDateProvider.h"
#import <ChatSDK/UI.h>

@implementation BMessageSectionDateProvider

-(NSObject *) provideString: (id<PMessage>) message {
    return [message.date dateAgo];
}

@end
