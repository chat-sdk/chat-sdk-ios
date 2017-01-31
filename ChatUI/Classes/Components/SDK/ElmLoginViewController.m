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
#import <ChatSDK/ChatUIElements.h>

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

@synthesize splashView;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [self init])) {
        
    }
    return self;
}

- (id)init
{
    self = [super initWithNibName:@"ElmLoginViewController" bundle:[NSBundle bundleWithName:ChatUIElementsBundle]];
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
    
    if(self._viewDidLoad != Nil) {
        self._viewDidLoad();
    }
    
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
        
        [self updateButtonStateForInternetConnection];
    }];
    
    if(self._viewWillAppear != Nil) {
        self._viewWillAppear();
    }
    
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

    // Login using the details provided
    [self showHUD];
    if(self._loginButtonPressed != Nil) {
        [self handleLoginAttempt:self._loginButtonPressed(emailField.text, passwordField.text)];
    }

    
    [emailField resignFirstResponder];
    [passwordField resignFirstResponder];
}

- (IBAction)registerButtonPressed:(id)sender {
    
    [self hideKeyboard];
    
    // Let the user know we are registering
    [self showHUD];
    
    self._registerButtonPressed(emailField.text, passwordField.text).thenOnMain(
                                                        ^id(id success) {
                                                            [self loginButtonPressed:Nil];
                                                            return Nil;
                                                        }, ^id(NSError * error) {
                                                            [self alertWithTitle:[NSBundle t:bErrorTitle] withError:error];
                                                            return Nil;
                                                        });
    
}

-(void) hideKeyboard {
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (IBAction)facebookButtonPressed:(id)sender {
    [self showHUD];
    if(self._facebookButtonPressed != Nil) {
        [self handleLoginAttempt:self._facebookButtonPressed()];
    }
}

-(void) handleLoginAttempt: (RXPromise *) promise {
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
    [self showHUD];
    if(self._twitterButtonPressed != Nil) {
        [self handleLoginAttempt:self._twitterButtonPressed()];
    }
}

- (IBAction)googleButtonPressed:(id)sender {
    [self showHUD];
    if(self._googlePlusButtonPressed != Nil) {
        [self handleLoginAttempt:self._googlePlusButtonPressed()];
    }
}

- (IBAction)anonymousButtonPressed:(id)sender {
    [self showHUD];
    if(self._anonymousButtonPressed != Nil) {
        [self handleLoginAttempt:self._anonymousButtonPressed()];
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
