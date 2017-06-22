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
    if ((self = [super init])) {
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
    }, Nil);
    
    self.facebookButton.enabled = [NM.auth accountTypeEnabled:bAccountTypeFacebook];    
    self.twitterButton.enabled = [NM.auth accountTypeEnabled:bAccountTypeTwitter];
    self.googleButton.enabled = [NM.auth accountTypeEnabled:bAccountTypeGoogle];
    self.anonymousButton.enabled = [NM.auth accountTypeEnabled:bAccountTypeAnonymous];
    
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(RXPromise *) loginWithUsername: (NSString *) username password: (NSString *) password {
    return [NM.auth authenticateWithDictionary:@{bLoginTypeKey: @(bAccountTypePassword),
                                                                                bLoginEmailKey: username,
                                                                                bLoginPasswordKey: password}];

}

-(RXPromise *) registerWithUsername: (NSString *) username password: (NSString *) password {
    return [NM.auth authenticateWithDictionary:@{bLoginTypeKey: @(bAccountTypeRegister),
                                                                                bLoginEmailKey: username,
                                                                                bLoginPasswordKey: password}];
}

-(RXPromise *) facebook {
    return [NM.auth authenticateWithDictionary:@{bLoginTypeKey: @(bAccountTypeFacebook)}];
}

-(RXPromise *) twitter {
    return [NM.auth authenticateWithDictionary:@{bLoginTypeKey: @(bAccountTypeTwitter)}];
}

-(RXPromise *) googlePlus {
    return [NM.auth authenticateWithDictionary:@{bLoginTypeKey: @(bAccountTypeGoogle)}];
}

-(RXPromise *) anonymous {
    return [NM.auth authenticateWithDictionary:@{bLoginTypeKey: @(bAccountTypeAnonymous)}];
}


@end
