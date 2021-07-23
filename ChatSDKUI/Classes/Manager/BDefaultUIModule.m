//
//  BDefaultUIModule.m
//  AFNetworking
//
//  Created by Ben on 2/1/18.
//

#import "BDefaultUIModule.h"
#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

@implementation BDefaultUIModule

-(void) activate {
    BChatSDK.shared.interfaceAdapter = [[BDefaultInterfaceAdapter alloc] init];
}

-(id<PInterfaceAdapter>) getInterfaceAdapter {
    return [[BDefaultInterfaceAdapter alloc] init];
}

@end
