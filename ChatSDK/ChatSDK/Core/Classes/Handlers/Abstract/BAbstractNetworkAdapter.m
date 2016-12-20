//
//  BAbstractNetworkAdapter.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/11/2016.
//
//

#import "BAbstractNetworkAdapter.h"

#import <ChatSDK/ChatCore.h>

@implementation BAbstractNetworkAdapter

-(id) init {
    if((self = [super init])) {
        self.contact = [[BBaseContactHandler alloc] init];
        self.imageMessage = [[BBaseImageMessageHandler alloc] init];
        self.locationMessage = [[BBaseLocationMessageHandler alloc] init];
    }
    return self;
}

@end
