//
//  BSplashScreenViewController.h
//  AFNetworking
//
//  Created by Benjamin Smiley-Andrews on 08/03/2019.
//

#import <UIKit/UIKit.h>
#import <ChatSDK/PSplashScreenViewController.h>
NS_ASSUME_NONNULL_BEGIN

@interface BSplashScreenViewController : UIViewController<PSplashScreenViewController> {
    BOOL _impl_shouldPushViewControllerOnAuth;
    BOOL _shouldPushViewControllerOnAuth;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

-(void) setShouldPushViewControllerOnAuth: (BOOL) shouldPush;
-(BOOL) shouldPushViewControllerOnAuth;

-(void) runViewDidLoad;
-(void) startActivityIndicator;
-(void) stopActivityIndicator;
-(void) pushLoginViewController;
-(void) pushMainViewController;

-(void) pushPostLoginViewController;
-(void) pushPostSignUpViewController;

@end

NS_ASSUME_NONNULL_END
