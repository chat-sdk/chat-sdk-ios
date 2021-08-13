//
//  BFirebaseUIModule.m
//  ChatSDKSwift
//
//  Created by Ben on 8/30/17.
//  Copyright © 2017 deluge. All rights reserved.
//

#import "FirebaseUIModule.h"
#import <ChatSDK/Core.h>
#import <FirebaseAuth/FirebaseAuth.h>
//#import <FirebaseCore/FIRApp.h>

@implementation FirebaseUIModule {
    NSArray * _providers;
}

-(FUIAuthPickerViewController *) viewControllerForProviders: (NSArray *) providers {
    FIRAuth * auth = [FIRAuth auth];
    FUIAuth * authUI = [FUIAuth authUIWithAuth:auth];
    
    // This allows us to be notified when authentication finishes
    authUI.delegate = self;
    
    // Add the phone provider
    [authUI setProviders:providers];
    
    return [[FUIAuthPickerViewController alloc] initWithAuthUI:authUI];
}

-(void) activate {
    BChatSDK.ui.loginViewController = [self viewControllerForProviders:_providers];
}

-(void) setProviders: (NSArray *) providers {
    _providers = providers;
}

-(void)authUI:(FUIAuth *)authUI
    didSignInWithAuthDataResult:(nullable FIRAuthDataResult *)authDataResult
         error:(nullable NSError *)error {
    if (!error) {
        
        [BChatSDK.auth authenticate].thenOnMain(^id(id<PUser> user) {
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
}

-(void) notifyDelegate: (NSError *) error {
    if(self.delegate != Nil) {
        [self.delegate authCompletedWithError:error];
    }
}

-(void) dealloc {
    NSLog(@"Dealloc");
}

@end
