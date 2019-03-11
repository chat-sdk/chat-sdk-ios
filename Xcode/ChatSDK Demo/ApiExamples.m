//
//  ApiExamples.m
//  ChatSDK Demo
//
//  Created by Benjamin Smiley-Andrews on 11/03/2019.
//  Copyright © 2019 deluge. All rights reserved.
//

#import "ApiExamples.h"
#import <ChatSDK/UI.h>

@implementation ApiExamples

-(void) customizeUI {
    // Override login view controller
    BChatSDK.ui.loginViewController = [[UIViewController alloc] initWithNibName:Nil bundle: Nil];
    
    // Register a provider
    [BChatSDK.ui setChatViewController:^BChatViewController *(id<PThread> thread) {
        // You could use a subclass here to customize the class
        return [[BChatViewController alloc] initWithThread:thread];
    }];
}

@end
