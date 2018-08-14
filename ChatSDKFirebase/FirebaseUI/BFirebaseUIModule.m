//
//  BFirebaseUIModule.m
//  ChatSDKSwift
//
//  Created by Ben on 8/30/17.
//  Copyright © 2017 deluge. All rights reserved.
//

#import "BFirebaseUIModule.h"
#import <ChatSDK/Core.h>
#import <FirebaseAuth/FirebaseAuth.h>
#import <FirebaseAuthUI/FirebaseAuthUI.h>
#import <FirebaseCore/FIRApp.h>

@implementation BFirebaseUIModule

-(void) activateWithProviders: (NSArray *) providers {
    
    FIRAuth * auth = [FIRAuth auth];
    FUIAuth * authUI = [FUIAuth authUIWithAuth:auth];
    
    // This allows us to be notified when authentication finishes
    authUI.delegate = self;
    
    // Add the phone provider
    [authUI setProviders:providers];
    
    FUIAuthPickerViewController * controller = [[FUIAuthPickerViewController alloc] initWithAuthUI:authUI];
    
    // Present the controller as the default authentication controller
    [BNetworkManager sharedManager].a.auth.challengeViewController = [[UINavigationController alloc] initWithRootViewController:controller];
}

- (void)authUI:(FUIAuth *)authUI didSignInWithUser:(nullable FIRUser *)user error:(nullable NSError *)error {
    if(!error) {
        [user getIDTokenWithCompletion:^(NSString * token, NSError * error) {
            if (!error) {
                
                NSDictionary * loginInfo = @{bLoginTypeKey: @(bAccountTypeCustom),
                                             bLoginCustomToken: token};
                
                [NM.auth authenticateWithDictionary:loginInfo].thenOnMain(^id(id<PUser> user) {
                    [self notifyDelegate:Nil];
                    return Nil;
                }, ^id(NSError * error) {
                    [self notifyDelegate:error];
                    return Nil;
                });
            }
            else {
                [self notifyDelegate:error];
            }
        }];
    }
    else {
        [self notifyDelegate:error];
    }
}

-(void) notifyDelegate: (NSError *) error {
    if(self.delegate != Nil) {
        [self.delegate authCompletedWithError:error];
    }
}


@end
