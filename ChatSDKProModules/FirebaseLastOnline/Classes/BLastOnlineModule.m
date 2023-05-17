//
//  BLastOnlineModule.m
//  ChatSDKSwift
//
//  Created by Ben on 4/16/18.
//  Copyright © 2018 deluge. All rights reserved.
//

#import "BLastOnlineModule.h"
#import "BFirebaseLastOnlineHandler.h"
#import <ChatSDK/Core.h>

@implementation BLastOnlineModule

-(void) activate {
    BChatSDK.shared.networkAdapter.lastOnline = [[BFirebaseLastOnlineHandler alloc] init];
}

@end
