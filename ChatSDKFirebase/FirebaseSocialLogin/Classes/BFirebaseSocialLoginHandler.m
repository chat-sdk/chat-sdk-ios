//
//  BSocialLoginHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 01/03/2017.
//
//

#import "BFirebaseSocialLoginHandler.h"

#import <ChatSDK/Core.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <GoogleSignIn/GoogleSignIn.h>

#import "BGoogleHelper.h"

@import TwitterKit;


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

    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    [[Twitter sharedInstance] startWithConsumerKey:BChatSDK.config.twitterApiKey
                                    consumerSecret:BChatSDK.config.twitterSecret];

}

-(BOOL) application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([[url scheme] hasPrefix:@"fb"]) {
        return [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url options:options];
    }
    else if ([[url scheme] hasPrefix:@"twitterkit"]) {
        return [[Twitter sharedInstance] application:app openURL:url options:options];
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if ([[url scheme] hasPrefix:@"fb"]) {
        
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }
    if ([[url scheme] hasPrefix:@"twitterkit"]) {
        return YES;
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
        
        [manager logInWithReadPermissions:@[@"public_profile", @"email"] handler:^(FBSDKLoginManagerLoginResult * result, NSError * error) {
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
