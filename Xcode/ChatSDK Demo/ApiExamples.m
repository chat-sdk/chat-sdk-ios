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

-(void) searchForUser: (NSString *) value {
    [BChatSDK.search usersForIndexes:@[bUserNameKey, bUserEmailKey, bUserPhoneKey] withValue:value limit:0 userAdded:^(id<PUser> user) {
    }];
}

-(void) createThreadWithUsers: (NSArray *) users {
    [BChatSDK.core createThreadWithUsers:users name:@"Name" threadCreated:^(NSError * error, id<PThread> thread) {
        
    }];
}

@end
