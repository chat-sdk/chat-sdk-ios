//
//  BConfiguration.m
//  AFNetworking
//
//  Created by Ben on 11/7/17.
//

#import "BConfiguration.h"
#import <ChatSDK/BCoreDefines.h>

@implementation BConfiguration

@synthesize messageColorMe;
@synthesize messageColorReply;

-(id) init {
    if((self = [super init])) {
        messageColorMe = bDefaultMessageColorMe;
        messageColorReply = bDefaultMessageColorReply;
    }
    return self;
}

+(BConfiguration *) configuration {
    return [[self alloc] init];
}

@end
