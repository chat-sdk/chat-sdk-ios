//
//  BFirebaseSocialLoginModule.m
//  ChatSDK Demo
//
//  Created by Ben on 8/29/17.
//  Copyright © 2017 deluge. All rights reserved.
//

#import "BFirebaseSocialLoginModule.h"
#import "SocialLogin.h"
#import <ChatSDK/Core.h>

@implementation BFirebaseSocialLoginModule

-(void) activate {
    [BNetworkManager sharedManager].a.socialLogin = [[BFirebaseSocialLoginHandler alloc] init];
}

@end
