//
//  BLoginViewController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 21/05/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "ElmLoginViewController.h"

//#import <ChatSDK/ChatCore.h>
#import <ChatSDK/ChatUI.h>

@interface ElmLoginViewController ()

@end

@implementation ElmLoginViewController

@synthesize emailField;
@synthesize passwordField;
@synthesize chatImageView;

@synthesize loginButton;
@synthesize registerButton;
@synthesize anonymousButton;

@synthesize facebookButton;
@synthesize twitterButton;
@synthesize googleButton;

@synthesize delegate;

@synthesize splashView;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [self init])) {
        
    }
    return self;
}

- (id)init
{
    self = [super initWithNibName:@"BLoginViewController" bundle:[NSBundle chatUIBundle]];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:Nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:Nil];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    [self.view addGestureRecognizer:_tapRecognizer];
    
    loginButton.layer.cornerRadius = 5;
    registerButton.layer.cornerRadius = 5;
    anonymousButton.layer.cornerRadius = 5;
    
    // First check to see if the user is already authenticated
    [self showHUD: [NSBundle t:bAuthenticating]];
    
    facebookButton.hidden = !facebookButton.enabled;
    twitterButton.hidden = !twitterButton.enabled;
//    if (twitterButton.hidden) {
//        twitterButton.keepWidth.equal = 0;
//    }

    googleButton.hidden = !googleButton.enabled;
//    if (googleButton.hidden) {
//        googleButton.keepWidth.equal = 0;
//    }

    anonymousButton.hidden = !anonymousButton.enabled;
    
    [self updateButtonStateForInternetConnection];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self hideHUD];
    
    emailField.text = @"";
    passwordField.text = @"";
    
    _internetConnectionObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kReachabilityChangedNotification object:nil queue:Nil usingBlock:^(NSNotification * notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateButtonStateForInternetConnection];
        });
    }];
    
}

-(void) viewDidDisappear:(BOOL)animated {
    [self hideHUDWithDuration:0];
    
    [[NSNotificationCenter defaultCenter] removeObserver:_internetConnectionObserver];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void) viewTapped {
    [emailField resignFirstResponder];
    [passwordField resignFirstResponder];
}

-(void) keyboardWillShow: (NSNotification *) notification {
    [chatImageView.superview keepAnimatedWithDuration:0.3 layout:^{
        chatImageView.keepVerticalCenter.equal = 0.08;
    }];
}

-(void) keyboardWillHide: (NSNotification *) notification {
    [chatImageView.superview keepAnimatedWithDuration:0.3 layout:^{
        chatImageView.keepVerticalCenter.equal = 0.21;
    }];
}

- (IBAction)loginButtonPressed:(id)sender {
    
    [self hideKeyboard];

    if ([delegate respondsToSelector:@selector(loginWithUsername:password:)]) {
        [self showHUD];
        [self handleLoginAttempt:[delegate loginWithUsername:emailField.text
                                                    password:passwordField.text]];
    }
    
    [emailField resignFirstResponder];
    [passwordField resignFirstResponder];
}

- (IBAction)registerButtonPressed:(id)sender {
    
    [self hideKeyboard];
    
    if ([delegate respondsToSelector:@selector(registerWithUsername:password:)]) {
        [self showHUD];
        [delegate registerWithUsername:emailField.text password:passwordField.text].thenOnMain(
                                                                                               ^id(id success) {
                                                                                                   [self loginButtonPressed:Nil];
                                                                                                   return Nil;
                                                                                               }, ^id(NSError * error) {
                                                                                                   [self alertWithTitle:[NSBundle t:bErrorTitle] withError:error];
                                                                                                   return Nil;
                                                                                               });
    }
}

-(void) hideKeyboard {
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (IBAction)facebookButtonPressed:(id)sender {
    if([delegate respondsToSelector:@selector(facebook)]) {
        [self showHUD];
        [self handleLoginAttempt:[delegate facebook]];
    }
}

-(void) handleLoginAttempt: (RXPromise *) promise {
    [self showHUD];
    
    promise.thenOnMain(
                ^id(id<PUser> user) {
                    [self authenticationFinished];
                    return Nil;
                }, ^id(NSError * error) {
                    [self alertWithTitle:[NSBundle t:bErrorTitle] withError:error];
                    return Nil;
                });
}

- (IBAction)twitterButtonPressed:(id)sender {
    if ([delegate respondsToSelector:@selector(twitter)]) {
        [self showHUD];
        [self handleLoginAttempt:[delegate twitter]];
    }
}

- (IBAction)googleButtonPressed:(id)sender {
    if ([delegate respondsToSelector:@selector(googlePlus)]) {
        [self showHUD];
        [self handleLoginAttempt:[delegate googlePlus]];
    }
}

- (IBAction)anonymousButtonPressed:(id)sender {
    if ([delegate respondsToSelector:@selector(anonymous)]) {
        [self showHUD];
        [self handleLoginAttempt:[delegate anonymous]];
    }
}

- (IBAction)termsAndConditionsButtonPressed:(id)sender {
    BEULAViewController * vc = [[BEULAViewController alloc] init];
    UINavigationController * nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:Nil];
}

-(void) alertWithTitle: (NSString *) title withError: (NSError *) error {

    // Hide the HUD if login fails
    [self hideHUD];
    
    // Remove the "Error Code: ... part of the message"
    NSString * errorMessage = error.localizedDescription;
    if ([errorMessage rangeOfString:@"Error Code:"].length != 0) {
        NSArray * errorArray = [error.localizedDescription componentsSeparatedByString:@")"];
        [UIView alertWithTitle:title withMessage:errorArray.lastObject];
    }
    else {
        [UIView alertWithTitle:title withError: error];
    }
}

-(void) showHUD {
    [self showHUD:[NSBundle t:bLogginIn]];
}

-(void) showHUD: (NSString *) message {
    
    if(_hud) {
        [MBProgressHUD hideHUDForView:splashView animated:NO];
    }
    
    //if (!_hud) {
        _hud = [MBProgressHUD showHUDAddedTo:splashView animated:NO];
        _hud.label.text = message;
        //[_hud hide:NO];
    //}
    
    // Sometimes there are operations that take a very small amount of time
    // to complete - this messes up the animation. Really we only want to show the
    // HUD if the user is waiting over a certain amount of time
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(showHudNow) userInfo:Nil repeats:NO];
}

-(void) showHudNow {
    [_hud showAnimated:YES];
    [splashView fadeToAlpha:1.0 withTime:0.3];
    //[self.view bringSubviewToFront:_hud];
}

-(void) hideHUD {
    [self hideHUDWithDuration:0.3];
}

-(void) hideHUDWithDuration: (float) duration {
    [_timer invalidate];
    _timer = Nil;
    
    [_hud hideAnimated:duration == 0 ? NO : YES];
    
    [splashView fadeToAlpha:0.0 withTime:duration];
}

-(void) authenticationFinished {
    [self dismissViewControllerAnimated:YES completion:Nil];
    [self hideHUD];
}

#pragma TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:emailField]) {
        [passwordField becomeFirstResponder];
    }
    if ([textField isEqual:passwordField]) {
        [passwordField resignFirstResponder];
    }
    return NO;
}

- (void)updateButtonStateForInternetConnection {
    
    BOOL connected = [Reachability reachabilityForInternetConnection].isReachable;
    
    loginButton.enabled = connected;
    registerButton.enabled = connected;
    anonymousButton.enabled = connected;
    facebookButton.enabled = connected;
    twitterButton.enabled = connected;
    googleButton.enabled = connected;
    
    loginButton.alpha = connected ? 1 : 0.6;
    registerButton.alpha = connected ? 1 : 0.6;
    anonymousButton.alpha = connected ? 1 : 0.6;
}



@end
