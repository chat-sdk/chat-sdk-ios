//
//  BSplashScreenViewController.h
//  AFNetworking
//
//  Created by Benjamin Smiley-Andrews on 08/03/2019.
//

#import <UIKit/UIKit.h>
#import <ChatSDK/PSplashScreenViewController.h>
NS_ASSUME_NONNULL_BEGIN

@interface BSplashScreenViewController : UIViewController<PSplashScreenViewController>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

NS_ASSUME_NONNULL_END
