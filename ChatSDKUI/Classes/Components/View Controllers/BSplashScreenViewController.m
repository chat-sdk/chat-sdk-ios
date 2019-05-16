//
//  BSplashScreenViewController.m
//  AFNetworking
//
//  Created by Benjamin Smiley-Andrews on 08/03/2019.
//

#import "BSplashScreenViewController.h"
#import <ChatSDK/UI.h>

@interface BSplashScreenViewController ()

@end

@implementation BSplashScreenViewController

-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:@"BSplashScreenViewController" bundle:[NSBundle uiBundle]])) {
        _shouldPushViewControllerOnAuth = YES;
        _impl_shouldPushViewControllerOnAuth = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self runViewDidLoad];
}

-(void) runViewDidLoad {
    if (BChatSDK.config.logoImage) {
        self.imageView.image = BChatSDK.config.logoImage;
    }
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self stopActivityIndicator];
    
    if (BChatSDK.auth.isAuthenticatedThisSession) {
        // Just load up the Chat SDK
        [self pushMainViewController];
        
    } else if (BChatSDK.auth.isAuthenticated) {
        [self startActivityIndicator];
        
        _impl_shouldPushViewControllerOnAuth = NO;
        [BChatSDK.auth authenticate].thenOnMain(^id(id success) {
            [self pushMainViewController];
            [self stopActivityIndicator];
            _impl_shouldPushViewControllerOnAuth = YES;
            return Nil;
        },^id(NSError * error) {
            [self pushLoginViewController];
            [self stopActivityIndicator];
            _impl_shouldPushViewControllerOnAuth = YES;
            return Nil;
        });
    } else {
        [self pushLoginViewController];
    }
    
    [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
        if (self.impl_shouldPushViewControllerOnAuth) {
            NSString * type = data[bHook_AuthenticationType];
            if ([type isEqualToString:bHook_AuthenticationTypeCached]) {
                [self pushMainViewController];
            }
            if ([type isEqualToString:bHook_AuthenticationTypeLogin]) {
                [self pushPostLoginViewController];
            }
            if ([type isEqualToString:bHook_AuthenticationTypeSignUp]) {
                [self pushPostSignUpViewController];
            }
        }
    }] withName:bHookDidAuthenticate];
    
    [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
        [self pushLoginViewController];
    }] withName:bHookDidLogout];
}

-(BOOL) impl_shouldPushViewControllerOnAuth {
    return _shouldPushViewControllerOnAuth && _impl_shouldPushViewControllerOnAuth;
}

-(void) startActivityIndicator {
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
}

-(void) stopActivityIndicator {
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
}

-(void) pushLoginViewController {
    [self.navigationController setViewControllers:@[self, BChatSDK.ui.loginViewController] animated:NO];
}

-(void) pushMainViewController {
    [self.navigationController setViewControllers:@[self, BChatSDK.ui.mainViewController] animated:YES];
}

-(void) pushPostLoginViewController {
    [self pushMainViewController];
}

-(void) pushPostSignUpViewController {
    [self pushMainViewController];
}

-(void) setShouldPushViewControllerOnAuth: (BOOL) shouldPush {
    _shouldPushViewControllerOnAuth = shouldPush;
}

-(BOOL) shouldPushViewControllerOnAuth {
    return _shouldPushViewControllerOnAuth;
}


@end
