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
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
        
        [BChatSDK.auth authenticate].thenOnMain(^id(id success) {
//            [self pushMainViewController];
            [self stopActivityIndicator];
            return Nil;
        },^id(NSError * error) {
            [self pushLoginViewController];
            [self stopActivityIndicator];
            return Nil;
        });
    } else {
        [self pushLoginViewController];
    }

    [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
        [self pushMainViewController];
    }] withName:bHookDidAuthenticate];

    [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
        [self pushLoginViewController];
    }] withName:bHookDidLogout];
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

@end
