//
//  BLoginViewController.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 21/05/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;
@class RXPromise;
@class BHook;

@protocol ElmLoginViewDelegate;

@interface ElmLoginViewController : UIViewController<UITextFieldDelegate> {
    UITapGestureRecognizer * _tapRecognizer;
    NSTimer * _timer;
    MBProgressHUD * _hud;
    BHook * _internetConnectionHook;
        
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
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *termsAndConditionsButton;

@property (nonatomic, readwrite, weak) id<ElmLoginViewDelegate> delegate;

-(void) showHUD: (NSString *) message;
-(void) showHUD;
-(void) showHudNow;
-(void) hideHUD;
-(void) hideHUDWithDuration: (float) duration;
-(void) authenticationFinished;

-(IBAction)loginButtonPressed:(id)sender;
-(IBAction)registerButtonPressed:(id)sender;
-(void) handleLoginAttempt: (RXPromise *) promise;
-(IBAction)termsAndConditionsButtonPressed:(id)sender;
-(void) hideKeyboard;

@end
