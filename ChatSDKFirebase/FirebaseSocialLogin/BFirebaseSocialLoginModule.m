//
//  BFirebaseSocialLoginModule.m
//  ChatSDK Demo
//
//  Created by Ben on 8/29/17.
//  Copyright © 2017 deluge. All rights reserved.
//

#import "BFirebaseSocialLoginModule.h"
#import "SocialLogin.h"
#import <ChatSDK/ChatCore.h>

@implementation BFirebaseSocialLoginModule

-(void) activateWithApplication: (UIApplication *) application withOptions: (NSDictionary *) launchOptions {
    [BNetworkManager sharedManager].a.socialLogin = [[BFirebaseSocialLoginHandler alloc] init];
    [[BNetworkManager sharedManager].a.socialLogin application: application didFinishLaunchingWithOptions:launchOptions];
}

@end
