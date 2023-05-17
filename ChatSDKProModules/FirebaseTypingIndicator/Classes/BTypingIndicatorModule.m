//
//  BContactBookModule.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/04/2017.
//
//

#import "BTypingIndicatorModule.h"


#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

#import "BFirebaseTypingIndicatorHandler.h"

@implementation BTypingIndicatorModule

-(void) activate {
    BChatSDK.shared.networkAdapter.typingIndicator = [[BFirebaseTypingIndicatorHandler alloc] init];
}

@end
