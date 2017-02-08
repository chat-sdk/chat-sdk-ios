//
//  BLoginViewController.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 21/05/2014.
//  Copyright (c) 2014 chatsdk.co All rights reserved. The Chat SDK is issued under the MIT liceense and is available for free at http://github.com/chat-sdk
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;

@interface BLoginViewController : UIViewController<UITextFieldDelegate> {
    UITapGestureRecognizer * _tapRecognizer;
    NSTimer * _timer;
    MBProgressHUD * _hud;
    id _internetConnectionObserver;
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
