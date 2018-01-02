//
//  BSocialLoginHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 01/03/2017.
//
//

#import "BFirebaseSocialLoginHandler.h"

#import <ChatSDK/ChatCore.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <GoogleSignIn/GoogleSignIn.h>
#import <TwitterKit/TwitterKit.h>

#import "BGoogleHelper.h"



@implementation BFirebaseSocialLoginHandler

-(id) init {
    if((self = [super init])) {
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:Nil queue:0 usingBlock:^(NSNotification * notificaiton) {
            [FBSDKAppEvents activateApp];
        }];
        

    }
    return self;
}

-(void) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Set up Google
//    NSError* configureError;
//    [[GGLContext sharedInstance] configureWithError: &configureError];
//    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);

    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

    [[Twitter sharedInstance] startWithConsumerKey:[BSettingsManager twitterApiKey]
                                    consumerSecret:[BSettingsManager twitterSecret]];

}

-(void) applicationDidBecomeActive: (UIApplication *) application {
    //[FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if ([[url scheme] isEqualToString:[NSString stringWithFormat:@"fb%@", [BSettingsManager facebookAppId]]]) {
        
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }
    else {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation];
    }
}

-(RXPromise *) loginWithGoogle {
    
    RXPromise * promise = [RXPromise new];
    
    BGoogleHelper * googleHelper = [[BGoogleHelper alloc] init];
    
    [googleHelper loginWithGoogle].thenOnMain(^id(id success) {
        
        GIDAuthentication * authentication = [GIDSignIn sharedInstance].currentUser.authentication;
        [promise resolveWithResult:@[authentication.idToken, authentication.accessToken]];
        
        return Nil;
    }, ^id(NSError * error) {
        [promise rejectWithReason:error];
        return Nil;
    });

    return promise;
}

-(RXPromise *) loginWithTwitter {
   
    RXPromise * promise = [RXPromise new];
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (!error) {
            [promise resolveWithResult:@[session.authToken, session.authTokenSecret]];
        }
        else {
            [promise rejectWithReason:error];
        }
    }];
    return promise;

}

-(RXPromise *) loginWithFacebook {
    
    RXPromise * promise = [RXPromise new];
    
    if([FBSDKAccessToken currentAccessToken]) {
        [promise resolveWithResult:[FBSDKAccessToken currentAccessToken].tokenString];
    }
    else {
                
        // TODO: Check this
        FBSDKLoginManager * manager = [[FBSDKLoginManager alloc] init];
        [manager logInWithReadPermissions:@[] handler:^(FBSDKLoginManagerLoginResult * result, NSError * error) {
            if(!error && [FBSDKAccessToken currentAccessToken].tokenString != Nil) {
                [promise resolveWithResult:[FBSDKAccessToken currentAccessToken].tokenString];
            }
            else {
                [promise rejectWithReason:error];
            }
        }];
    }
    
    return promise;

}

@end
