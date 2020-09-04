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
#import <ChatSDK/ChatSDK-Swift.h>

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
    
    // Localization
    self.emailField.placeholder = [NSBundle t:bEmail];
    self.passwordField.placeholder = [NSBundle t:bPassword];
    
    self.emailField.backgroundColor = [Colors getWithName: Colors.loginTextFieldBackgroundColor];
    self.passwordField.backgroundColor = [Colors getWithName: Colors.loginTextFieldBackgroundColor];
    
    [self.loginButton setTitle:[NSBundle t:bLogin] forState:UIControlStateNormal];

    self.loginButton.backgroundColor = [Colors getWithName: Colors.loginButton];
    self.registerButton.backgroundColor = [Colors getWithName: Colors.registerButton];
    
    self.loginButton.layer.cornerRadius = 5;
    self.registerButton.layer.cornerRadius = 5;

    [self.registerButton setTitle:[NSBundle t:bRegister] forState:UIControlStateNormal];
    [self.forgotPasswordButton setTitle:[NSBundle t:bForgotPassword] forState:UIControlStateNormal];
    [self.termsAndConditionsButton setTitle:[NSBundle t:bTermsAndConditions] forState:UIControlStateNormal];
    
    UIButton * activeSocialButton = Nil;

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
