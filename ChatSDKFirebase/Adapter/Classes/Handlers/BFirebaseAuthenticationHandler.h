//
//  BFirebaseAuthenticationHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import <Foundation/Foundation.h>

#import <ChatSDK/BAbstractAuthenticationHandler.h>

@class RXPromise;
@class FIRUser;

@interface BFirebaseAuthenticationHandler : BAbstractAuthenticationHandler {
}

-(RXPromise *) loginWithFirebaseUser: (FIRUser *) firebaseUser;

@end
