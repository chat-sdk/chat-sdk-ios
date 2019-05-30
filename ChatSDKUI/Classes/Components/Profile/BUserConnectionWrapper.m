//
//  BUserConnectionWrapper.m
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 19/08/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import "BUserConnectionWrapper.h"
#import <ChatSDK/Core.h>

#define bAskKey @"ask"

@implementation BUserConnectionWrapper

+(BUserConnectionWrapper *) wrapperWithConnection:(id<PUserConnection>)connection {
    return [[self alloc] initWithConnection:connection];
}

-(id) initWithConnection:(id<PUserConnection>) connection {
    if ((self = [self init])) {
        _connection = connection;
    }
    return self;
}

-(NSString *) ask {
    return [_connection.meta metaStringForKey:bAskKey];
}

-(void) setAsk: (NSString *) ask {
    [_connection setMetaValue:ask forKey:bAskKey];
}

@end
