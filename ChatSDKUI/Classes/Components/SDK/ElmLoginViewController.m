//
//  BLoginViewController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 21/05/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "ElmLoginViewController.h"

//#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

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

@synthesize forgotPasswordButton;

@synthesize delegate;

-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:@"BLoginViewController" bundle:[NSBundle uiBundle]])) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:Nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:Nil];
    }
    return self;
}

-(instancetype) init
{
    self = [self initWithNibName:Nil bundle:Nil];
    if (self) {
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
    
    [self updateInterfaceForReachabilityStateChange];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    __weak __typeof__(self) weakSelf = self;
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self hideHUD];
    
    emailField.text = @"";
    passwordField.text = @"";

    if (BChatSDK.config.debugUsername) {
        self.emailField.text = BChatSDK.config.debugUsername;
    }
    
    if (BChatSDK.config.debugPassword) {
        self.passwordField.text = BChatSDK.config.debugPassword;
    }
    
    _internetConnectionHook = [BHook hook:^(NSDictionary * data) {
        __typeof__(self) strongSelf = weakSelf;
        [strongSelf updateInterfaceForReachabilityStateChange];
    }];
    [BChatSDK.hook addHook:_internetConnectionHook withName:bHookInternetConnectivityDidChange];

}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self hideHUDWithDuration:0];
    
    [BChatSDK.hook removeHook:_internetConnectionHook];
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
    __weak __typeof__(self) weakSelf = self;
    [chatImageView.superview keepAnimatedWithDuration:0.3 layout:^{
        __typeof__(self) strongSelf = weakSelf;
        strongSelf.chatImageView.keepVerticalCenter.equal = 0.08;
    }];
}

-(void) keyboardWillHide: (NSNotification *) notification {
    __weak __typeof__(self) weakSelf = self;
    [chatImageView.superview keepAnimatedWithDuration:0.3 layout:^{
        __typeof__(self) strongSelf = weakSelf;
        strongSelf.chatImageView.keepVerticalCenter.equal = 0.21;
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
    
    __weak __typeof__(self) weakSelf = self;
    if ([delegate respondsToSelector:@selector(registerWithUsername:password:)]) {
        [self showHUD];
        [delegate registerWithUsername:emailField.text password:passwordField.text].thenOnMain(
                                                                                               ^id(id success) {
                                                                                                   __typeof__(self) strongSelf = weakSelf;
                                                                                                   [strongSelf loginButtonPressed:Nil];
                                                                                                   return Nil;
                                                                                               }, ^id(NSError * error) {
                                                                                                   __typeof__(self) strongSelf = weakSelf;
                                                                                                   [strongSelf alertWithTitle:[NSBundle t:bErrorTitle] withError:error];
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
    
    __weak __typeof__(self) weakSelf = self;
    promise.thenOnMain(
                ^id(id<PUser> user) {
                    __typeof__(self) strongSelf = weakSelf;
                    [strongSelf authenticationFinished];
                    return Nil;
                }, ^id(NSError * error) {
                    __typeof__(self) strongSelf = weakSelf;
                    [strongSelf alertWithTitle:[NSBundle t:bErrorTitle] withError:error];
                    [strongSelf hideHUD];
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
    UINavigationController * nvc = BChatSDK.ui.termsOfServiceNavigationController;
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
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    _hud.label.text = message;
    
    // Sometimes there are operations that take a very small amount of time
    // to complete - this messes up the animation. Really we only want to show the
    // HUD if the user is waiting over a certain amount of time
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(showHudNow) userInfo:Nil repeats:NO];
}

-(void) showHudNow {
    [_hud showAnimated:YES];
}

-(void) hideHUD {
    [self hideHUDWithDuration:0.3];
}

-(void) hideHUDWithDuration: (float) duration {
    [_timer invalidate];
    _timer = Nil;
    
    [_hud hideAnimated:duration == 0 ? NO : YES];
}

-(void) authenticationFinished {
    [self hideHUDWithDuration:0];
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

- (void)updateInterfaceForReachabilityStateChange {
    
    BOOL connected = BChatSDK.connectivity.isConnected;

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

- (IBAction)forgotPasswordPressed:(id)sender {
    __weak __typeof__(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSBundle t:bForgotPassword]
                                                                   message:[NSBundle t:bEnterCredentialToResetPassword]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *submit = [UIAlertAction actionWithTitle:[NSBundle t:bOk] style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       __typeof__(self) strongSelf = weakSelf;
                                                       if (alert.textFields.count > 0) {
                                                           UITextField *textField = [alert.textFields firstObject];
                                                           [strongSelf impl_resetPasswordWithCredential:textField.text];
                                                       }
                                                   }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:[NSBundle t:bCancel] style:UIAlertActionStyleCancel handler:Nil];
    
    [alert addAction:submit];
    [alert addAction:cancel];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        __typeof__(self) strongSelf = weakSelf;
        textField.placeholder = strongSelf.delegate.usernamePlaceholder;
    }];
    
    [self presentViewController:alert animated:YES completion:Nil];
    
}

-(void) impl_resetPasswordWithCredential: (NSString *) credential {
    __weak __typeof__(self) weakSelf = self;

    [delegate resetPasswordWithCredential:credential].thenOnMain(^id(id success) {
        __typeof__(self) strongSelf = weakSelf;

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSBundle t:bSuccess]
                                                                       message:[NSBundle t:bEnterCredentialToResetPassword]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:[NSBundle t:bOk] style:UIAlertActionStyleCancel handler:Nil];
        [alert addAction:cancel];
        
        [strongSelf presentViewController:alert animated:YES completion:Nil];
        return Nil;
    }, ^id(NSError * error) {
        __typeof__(self) strongSelf = weakSelf;

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSBundle t:bErrorTitle]
                                                                       message:[error localizedDescription]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:[NSBundle t:bOk] style:UIAlertActionStyleCancel handler:Nil];
        [alert addAction:cancel];
        [strongSelf presentViewController:alert animated:YES completion:Nil];
        return Nil;
    });
}

@end
