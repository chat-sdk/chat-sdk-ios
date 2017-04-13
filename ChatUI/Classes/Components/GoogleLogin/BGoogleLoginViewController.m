//
//  BGoogleLoginViewController.m
//  Pods
//
//  Created by Simon Smiley-Andrews on 03/03/2017.
//
//

#import "BGoogleLoginViewController.h"
#import "BSettingsManager.h"
#import "KeepLayout.h"

@interface BGoogleLoginViewController ()

@end

@implementation BGoogleLoginViewController

@synthesize googleLoginPromise;

- (id)init {
    
    self = [super initWithNibName:@"BGoogleLoginViewController" bundle:[NSBundle chatUIBundle]];
    if (self) {
        
        UIImageView * googleLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSBundle res: @"icn_1200_google.png"]]];
        [self.view addSubview:googleLogo];
        
        googleLogo.keepHorizontalCenter.equal = 0.5;
        googleLogo.keepHeight.equal = 200;
        googleLogo.keepWidth.equal = 200;
        googleLogo.keepVerticalCenter.equal = 0.5;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
  
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].clientID = [BSettingsManager googleClientKey]; //@"530766463312-set738214thf1ma67mckei7u5hp2nr2m.apps.googleusercontent.com";

    [[GIDSignIn sharedInstance] setScopes:@[@"https://www.googleapis.com/auth/plus.login", @"https://www.googleapis.com/auth/plus.me"]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![[GIDSignIn sharedInstance] currentUser]) {
        [[GIDSignIn sharedInstance] signIn];
    }
    else {
     
        [self dismissViewControllerAnimated:YES completion:^{
            // We already have a Google user so can we immediately login with Firebase
            [googleLoginPromise resolveWithResult:[GIDSignIn sharedInstance].currentUser];
        }];
    }
}

// Implement the required GIDSignInDelegate methods
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {

    [self dismissViewControllerAnimated:YES completion:^{
        
        if (error == nil) {
            [googleLoginPromise resolveWithResult:user];
        }
        else {
            [googleLoginPromise rejectWithReason:error];
        }
    }];
}

// Inside our login method
// Create a new promise
// Create a new instance of the google login view controller

// Make a GoogleLoginViewDelegate - loginWas successfull - loginFailedWitherror
// Google helper implements the Googledelegate
// Google viewController.delete = self
// return promise
// In the helper we have a class property wihich is the promise

// Self.promise = rxpromise new
// GoogleLoginViewController.promise = promise

// Inside the login was successful - resolve promise
// Inside the login was failed - resolve promise

// Google will tell us
// Have to add the delegate property to the view controller which then should notify it's delegate - the google helper

@end
