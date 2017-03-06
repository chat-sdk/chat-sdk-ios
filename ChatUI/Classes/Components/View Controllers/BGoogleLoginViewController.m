//
//  BGoogleLoginViewController.m
//  Pods
//
//  Created by Simon Smiley-Andrews on 03/03/2017.
//
//

#import "BGoogleLoginViewController.h"
#import "BSettingsManager.h"

#import <ChatSDK/ChatCore.h>
#import <ChatSDK/ChatUI.h>

@interface BGoogleLoginViewController ()

@end

@implementation BGoogleLoginViewController

- (id)init {
    
    self = [super initWithNibName:@"BGoogleLoginViewController" bundle:[NSBundle chatUIBundle]];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO: Remove this
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].clientID = [BSettingsManager googleClientKey]; //@"530766463312-set738214thf1ma67mckei7u5hp2nr2m.apps.googleusercontent.com";
    
    [[GIDSignIn sharedInstance] setScopes:@[@"https://www.googleapis.com/auth/plus.login", @"https://www.googleapis.com/auth/plus.me"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [[GIDSignIn sharedInstance] signIn];
}

// Implement the required GIDSignInDelegate methods
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {

    NSLog(@"victory");
    
    //[self showHUD];
    //googleSignInOn = NO;
    
//    if (error == nil) {
//        
//        [[BNetworkManager sharedManager].authenticationAdapter authenticateWithDictionary:@{bLoginTypeKey: @(bAccountTypeGoogle)}].thenOnMain(^id(id<PUser> user) {
//            
//            [self authenticationFinished];
//            return Nil;
//        }, ^id(NSError * error) {
//            [self alertWithTitle:[NSBundle t:bErrorTitle] withError:error];
//            return Nil;
//        });
//    }
//    else {
//        [self alertWithTitle:[NSBundle t:bErrorTitle] withError:error];
//    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
