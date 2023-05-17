//
//  BContactBookModule.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/04/2017.
//
//

#import "BAudioMessageModule.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>
#import "BAudioMessageHandler.h"

@implementation BAudioMessageModule

-(void) activate {
    BChatSDK.shared.networkAdapter.audioMessage = [[BAudioMessageHandler alloc] init];
    [BChatSDK.ui registerMessageWithCellClass:BChatSDK.audioMessage.cellClass messageType:@(bMessageTypeAudio)];
}

@end
