//
//  BGoogleLoginViewController.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 03/03/2017.
//
//

#import <UIKit/UIKit.h>

#import "PGoogleLoginDelegate.h"
#import <GoogleSignIn/GoogleSignIn.h>

@interface BGoogleLoginViewController : UIViewController <GIDSignInDelegate, GIDSignInUIDelegate>

@property (nonatomic, strong) id<PGoogleLoginDelegate> delegate;


@end

