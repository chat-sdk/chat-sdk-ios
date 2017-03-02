//
//  PSocialLoginHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 01/03/2017.
//
//

#ifndef PSocialLoginHandler_h
#define PSocialLoginHandler_h

@class RXPromise;

@protocol PSocialLoginHandler <NSObject>

-(void) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

-(RXPromise *) loginWithGoogle;
-(RXPromise *) loginWithTwitter;
-(RXPromise *) loginWithFacebook;

@end

#endif /* PSocialLoginHandler_h */
