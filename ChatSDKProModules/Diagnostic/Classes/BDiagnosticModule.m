//
//  BContactBookModule.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/04/2017.
//
//

#import "BDiagnosticModule.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>
#import "BMessageBurstChatOption.h"

@implementation BDiagnosticModule

-(void) activate {
    [[BInterfaceManager sharedManager].a addChatOption:[[BMessageBurstChatOption alloc] init]];
}

@end
