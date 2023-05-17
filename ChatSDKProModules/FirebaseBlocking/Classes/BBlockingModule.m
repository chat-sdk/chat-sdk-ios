//
//  BBroadcastModule.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 30/05/2017.
//
//

#import "BBlockingModule.h"
#import <ChatSDK/Core.h>
#import "BBlockingHandler.h"
#import <Licensing/Licensing-Swift.h>

@implementation BBlockingModule

-(void) activate {
    [Licensing.shared addWithItem:NSStringFromClass(self.class)];

    BChatSDK.shared.networkAdapter.blocking = [[BBlockingHandler alloc] init];
}

@end
