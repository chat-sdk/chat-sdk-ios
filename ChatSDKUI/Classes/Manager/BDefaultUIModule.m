//
//  BDefaultUIModule.m
//  AFNetworking
//
//  Created by Ben on 2/1/18.
//

#import "BDefaultUIModule.h"
#import <ChatSDK/ChatCore.h>
#import <ChatSDK/ChatUI.h>

@implementation BDefaultUIModule

-(void) activate {
    [BInterfaceManager sharedManager].a = [[BDefaultInterfaceAdapter alloc] init];
    // Set the login screen
    NM.auth.challengeViewController = [[BLoginViewController alloc] initWithNibName:Nil bundle:Nil];
    if(![BChatSDK config].defaultBlankAvatar) {
        [BChatSDK config].defaultBlankAvatar = [NSBundle imageNamed:bDefaultProfileImage framework:@"ChatSDK" bundle:@"ChatUI"];
    }
    
}

@end
