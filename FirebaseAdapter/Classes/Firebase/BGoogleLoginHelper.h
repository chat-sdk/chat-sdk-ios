//
//  BGoogleLoginHelper.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 21/12/2016.
//
//

#import <Foundation/Foundation.h>

@class RXPromise;

@interface BGoogleLoginHelper : NSObject /*<GIDSignInDelegate, GIDSignInUIDelegate>*/ {

}

- (RXPromise *)loginWithGoogle;

@property (nonatomic, weak) RXPromise * googlePromise;

@end
