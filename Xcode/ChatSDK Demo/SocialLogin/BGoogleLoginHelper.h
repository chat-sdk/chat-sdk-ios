//
//  BGoogleLoginHelper.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 21/12/2016.
//
//

#import <Foundation/Foundation.h>
#import <GoogleSignIn/GIDSignIn.h>

@class RXPromise;

@interface BGoogleLoginHelper : NSObject<GIDSignInDelegate, GIDSignInUIDelegate> {
    RXPromise * _promise;
}

-(RXPromise *) login;

@end
