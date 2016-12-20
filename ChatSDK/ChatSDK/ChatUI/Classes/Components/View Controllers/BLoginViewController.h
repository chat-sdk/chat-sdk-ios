//
//  BLoginViewController.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 21/05/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>

@class MBProgressHUD;

@interface BLoginViewController : UIViewController<UITextFieldDelegate, GIDSignInDelegate, GIDSignInUIDelegate> {
    UITapGestureRecognizer * _tapRecognizer;
    NSTimer * _timer;
    MBProgressHUD * _hud;
    
    id _internetConnectionObserver;
    
    BOOL googleSignInOn; // There is a delay when a user logs in with Google, we can use this BOOL to show HUD while we call the delegate method
}

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIImageView *chatImageView;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *anonymousButton;

@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *googleButton;


@property (weak, nonatomic) IBOutlet UIImageView *splashView;

@end
