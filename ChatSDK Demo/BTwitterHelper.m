//
//  BTwitterHelper.m
//  Chat SDK Firebase
//
//  Created by Benjamin Smiley-andrews on 16/06/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import "BTwitterHelper.h"
#import <TwitterKit/TwitterKit.h>

#import <ChatSDK/ChatCore.h>

@implementation BTwitterHelper

static BTwitterHelper * helper;

+(BTwitterHelper *) sharedHelper {
    
    @synchronized(self) {
        
        // If the sharedSoundManager var is nil then we need to allocate it.
        if(helper == nil) {
            // Allocate and initialize an instance of this class
            helper = [[self alloc] init];
        }
    }
    return helper;
}

-(id) init {
    if ((self = [super init])) {
        [[Twitter sharedInstance] startWithConsumerKey:[BSettingsManager twitterApiKey]
                                        consumerSecret:[BSettingsManager twitterSecret]];

        // When this is called, we try to login and return the promise
        [[NSNotificationCenter defaultCenter] addObserverForName:bTwitterLoginStartNotification object:Nil queue:0 usingBlock:^(NSNotification * notification) {
            RXPromise * promise = [self login];
            [[NSNotificationCenter defaultCenter] postNotificationName:bTwitterLoginPromiseNotification object:Nil userInfo:@{bTwitterLoginPromise: promise}];
        }];
        
    }
    return self;
}

-(RXPromise *) login {
    RXPromise * promise = [RXPromise new];
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (!error) {
            NSDictionary * details = @{bTwitterAuthToken: session.authToken,
                                       bTwitterSecret: session.authTokenSecret};
            
            [promise resolveWithResult:details];
        }
        else {
            [promise rejectWithReason:error];
        }
    }];
    return promise;
}

@end
