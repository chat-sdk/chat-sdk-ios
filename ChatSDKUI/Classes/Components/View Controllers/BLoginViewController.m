//
//  BLoginViewController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 21/05/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "BLoginViewController.h"

#import <ChatSDK/ChatUI.h>
#import <ChatSDK/ChatCore.h>

@interface BLoginViewController ()

@end

@implementation BLoginViewController


-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [self init])) {
        super.delegate = self;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        super.delegate = self;
    }
    return self;
}

-(void) viewDidLoad {
    [super viewDidLoad];
    
    // First check to see if the user is already authenticated
    [self showHUD: [NSBundle t:bAuthenticating]];
    [NM.auth authenticateWithCachedToken].thenOnMain(^id(id success) {
        [self authenticationFinished];
        return Nil;
    }, ^id(NSError * error) {
        [self hideHUD];
        return Nil;
    });
    
    self.facebookButton.enabled = [NM.auth accountTypeEnabled:bAccountTypeFacebook];    
    self.twitterButton.enabled = [NM.auth accountTypeEnabled:bAccountTypeTwitter];
    self.googleButton.enabled = [NM.auth accountTypeEnabled:bAccountTypeGoogle];
    self.anonymousButton.enabled = [NM.auth accountTypeEnabled:bAccountTypeAnonymous];
    
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(RXPromise *) loginWithUsername: (NSString *) username password: (NSString *) password {
    return [NM.auth authenticate:[BAccountDetails username:username password:password]];
}

-(RXPromise *) registerWithUsername: (NSString *) username password: (NSString *) password {
    return [NM.auth authenticate:[BAccountDetails signUp:username password:password]];
}

-(RXPromise *) facebook {
    return [NM.auth authenticate:[BAccountDetails facebook]];
}

-(RXPromise *) twitter {
    return [NM.auth authenticate:[BAccountDetails twitter]];
}

-(RXPromise *) googlePlus {
    return [NM.auth authenticate:[BAccountDetails google]];
}

-(RXPromise *) anonymous {
    return [NM.auth authenticate:[BAccountDetails anonymous]];
}


@end
