//
//  BContactBookModule.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/04/2017.
//
//

#import "BVideoMessageModule.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>


@implementation BVideoMessageModule

-(void) activate {
    BChatSDK.shared.networkAdapter.videoMessage = [[BVideoMessageHandler alloc] init];
    [BChatSDK.ui registerMessageWithCellClass:BChatSDK.videoMessage.cellClass messageType:@(bMessageTypeVideo)];
}

@end
