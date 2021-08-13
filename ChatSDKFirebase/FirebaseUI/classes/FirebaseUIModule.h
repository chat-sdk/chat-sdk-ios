//
//  BFirebaseUIModule.h
//  ChatSDKSwift
//
//  Created by Ben on 8/30/17.
//  Copyright © 2017 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PModule.h>

@import FirebaseAuthUI;

@protocol FUIAuthDelegate;

@protocol FirebaseUIModuleDelegate <NSObject>

-(void) authCompletedWithError: (NSError *) error;

@end

@interface FirebaseUIModule : NSObject<FUIAuthDelegate, PModule> 

-(FUIAuthPickerViewController *) viewControllerForProviders: (NSArray *) providers;
-(void) setProviders: (NSArray *) providers;

@property (nonatomic, readwrite, weak) id<FirebaseUIModuleDelegate> delegate;

@end
