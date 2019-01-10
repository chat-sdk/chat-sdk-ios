//
//  BFirebaseUIModule.h
//  ChatSDKSwift
//
//  Created by Ben on 8/30/17.
//  Copyright © 2017 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>

@import FirebaseUI;

@protocol FUIAuthDelegate;

@protocol BFirebaseUIModuleDelegate <NSObject>

-(void) authCompletedWithError: (NSError *) error;

@end

@interface BFirebaseUIModule : NSObject<FUIAuthDelegate>

-(void) activateWithProviders: (NSArray *) providers;

@property (nonatomic, readwrite, weak) id<BFirebaseUIModuleDelegate> delegate;

@end
