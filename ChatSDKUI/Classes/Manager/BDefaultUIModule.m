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
    // Set the login screen
    // TODO:
//    BChatSDK.auth.challengeViewController = [[BLoginViewController alloc] initWithNibName:Nil bundle:Nil];
    if(!BChatSDK.config.defaultBlankAvatar) {
        BChatSDK.config.defaultBlankAvatar = [NSBundle imageNamed:bDefaultProfileImage bundle:bUIBundleName];
    }
    
}

@end
