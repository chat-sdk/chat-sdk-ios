//
//  BGoogleLoginViewController.m
//  Pods
//
//  Created by Simon Smiley-Andrews on 03/03/2017.
//
//

#import "BGoogleLoginViewController.h"

#import <ChatSDK/UI.h>

@interface BGoogleLoginViewController ()

@end

@implementation BGoogleLoginViewController

@synthesize delegate;

- (id)init {
    
    self = [super initWithNibName:@"BGoogleLoginViewController" bundle:Nil];
    if (self) {
        
        UIImageView * googleLogo = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"icn_200_google.png"]];
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
    [GIDSignIn sharedInstance].clientID = BChatSDK.config.googleClientKey;

    [[GIDSignIn sharedInstance] setScopes:@[@"https://www.googleapis.com/auth/plus.login", @"https://www.googleapis.com/auth/plus.me"]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![[GIDSignIn sharedInstance] currentUser]) {
        [[GIDSignIn sharedInstance] signIn];
    }
    else {
     
        [self dismissViewControllerAnimated:NO completion:^{
            if (delegate) {
                [delegate loginWasSuccessful];
                delegate = Nil;
            }
        }];
    }
}

// Implement the required GIDSignInDelegate methods
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {

    [self dismissViewControllerAnimated:NO completion:^{
        if (delegate) {
            if (error) {
                [delegate loginFailedWithError:error];
            }
            else {
                [delegate loginWasSuccessful];
            }
            delegate = Nil;
        }
    }];
}

@end
