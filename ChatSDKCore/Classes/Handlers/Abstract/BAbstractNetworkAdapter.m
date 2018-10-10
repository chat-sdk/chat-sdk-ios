//
//  BAbstractNetworkAdapter.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/11/2016.
//
//

#import "BAbstractNetworkAdapter.h"

#import <ChatSDK/Core.h>

@implementation BAbstractNetworkAdapter {
    NSMutableDictionary * _handlers;
}

-(instancetype) init {
    if((self = [super init])) {
        self.contact = [[BBaseContactHandler alloc] init];
        self.imageMessage = [[BBaseImageMessageHandler alloc] init];
        self.locationMessage = [[BBaseLocationMessageHandler alloc] init];
        self.hook = [[BBaseHookHandler alloc] init];
        self.connectivity = [[BBaseInternetConnectivityHandler alloc] init];
        _handlers = [NSMutableDictionary new];
    }
    return self;
}

-(void) setHandler:(id)handler withName:(NSString *) name {
    if(handler && name) {
        _handlers[name] = handler;
    }
}

-(id) handlerWithName:(NSString *)name {
    if(name) {
        return _handlers[name];
    }
    return Nil;
}

@end
