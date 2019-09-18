//
//  BLoginViewController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 21/05/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "BLoginViewController.h"

#import <ChatSDK/UI.h>
#import <ChatSDK/Core.h>

@interface BLoginViewController ()

@end

@implementation BLoginViewController


-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        super.delegate = self;
    }
    return self;
}

-(instancetype) init
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
//    [self showHUD: [NSBundle t:bAuthenticating]];
//    [BChatSDK.auth authenticate].thenOnMain(^id(id success) {
//        [self authenticationFinished];
//        return Nil;
//    }, ^id(NSError * error) {
//        [self hideHUD];
//        return Nil;
//    });
    
    // Localization
    self.emailField.placeholder = [NSBundle t:bEmail];
    self.passwordField.placeholder = [NSBundle t:bPassword];
    [self.loginButton setTitle:[NSBundle t:bLogin] forState:UIControlStateNormal];
    [self.registerButton setTitle:[NSBundle t:bRegister] forState:UIControlStateNormal];
    [self.forgotPasswordButton setTitle:[NSBundle t:bForgotPassword] forState:UIControlStateNormal];
    [self.termsAndConditionsButton setTitle:[NSBundle t:bTermsAndConditions] forState:UIControlStateNormal];
    
    UIButton * activeSocialButton = Nil;
    
    if (![BChatSDK.auth accountTypeEnabled:bAccountTypeFacebook]) {
        [self hideView:self.facebookButton withViewToRight:self.googleButton];
    }
    else {
        activeSocialButton = self.facebookButton;
    }

    if (![BChatSDK.auth accountTypeEnabled:bAccountTypeGoogle]) {
        [self hideView:self.googleButton withViewToRight:self.twitterButton];
    }
    else {
        activeSocialButton = self.googleButton;
    }

    if (![BChatSDK.auth accountTypeEnabled:bAccountTypeTwitter]) {
        [self hideView:self.twitterButton withViewToRight:Nil];
    }
    else {
        activeSocialButton = self.twitterButton;
    }

    if (![BChatSDK.auth accountTypeEnabled:bAccountTypeAnonymous]) {
        [self hideView:self.anonymousButton withViewToRight:Nil];
    }
    else {
        if(!activeSocialButton) {
            self.anonymousButton.keepTopOffsetTo(self.loginButton).equal = 8;
        }
        else {
            self.anonymousButton.keepTopOffsetTo(activeSocialButton).equal = 8;
        }
    }
    
    self.forgotPasswordButton.hidden = !BChatSDK.config.forgotPasswordEnabled;
    self.termsAndConditionsButton.hidden = !BChatSDK.config.termsAndConditionsEnabled;
    
    if(!self.anonymousButton.enabled) {
        self.anonymousButton.keepHeight.equal = 0;
    }
    
    if(BChatSDK.config.loginUsernamePlaceholder) {
        self.emailField.placeholder = BChatSDK.config.loginUsernamePlaceholder;
    }
    
    if(BChatSDK.config.logoImage) {
        self.chatImageView.image = BChatSDK.config.logoImage;
    }
    if(BChatSDK.config.loginScreenAppName) {
        self.titleLabel.text = BChatSDK.config.loginScreenAppName;
    }
    else {
        // TODO: Convert this to a text view rather than a link...
//        NSString * poweredBy = @"Powered by ";
//        NSString * chatSDK = @"Chat SDK";
//        NSString * fullString = [poweredBy stringByAppendingString:chatSDK];
//        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:fullString];
//        [str addAttribute: NSLinkAttributeName value: @"http://www.chatsdk.co" range: NSMakeRange(poweredBy.length, chatSDK.length)];
//        self.titleLabel.attributedText = str;
    }
    
}

-(void) hideView: (UIView *) view withViewToRight: (UIView *) rightView {
    view.keepHeight.equal = 0;
    view.keepWidth.equal = 0;
    if (rightView) {
        rightView.keepLeftOffsetTo(view).equal = 0;
    }
    view.hidden = YES;
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(RXPromise *) loginWithUsername: (NSString *) username password: (NSString *) password {
    return [BChatSDK.auth authenticate:[BAccountDetails username:username password:password]];
}

-(RXPromise *) registerWithUsername: (NSString *) username password: (NSString *) password {
    return [BChatSDK.auth authenticate:[BAccountDetails signUp:username password:password]];
}

-(RXPromise *) facebook {
    return [BChatSDK.auth authenticate:[BAccountDetails facebook]];
}

-(RXPromise *) twitter {
    return [BChatSDK.auth authenticate:[BAccountDetails twitter]];
}

-(RXPromise *) googlePlus {
    return [BChatSDK.auth authenticate:[BAccountDetails google]];
}

-(RXPromise *) anonymous {
    return [BChatSDK.auth authenticate:[BAccountDetails anonymous]];
}

-(RXPromise *) resetPasswordWithCredential: (NSString *) credential {
    return [BChatSDK.auth resetPasswordWithCredential:credential];
}

-(NSString *) usernamePlaceholder {
    return BChatSDK.config.loginUsernamePlaceholder;
}



@end
