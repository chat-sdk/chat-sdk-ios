//
//  BGoogleHelper.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 29/03/2017.
//
//

#import <Foundation/Foundation.h>
#import "PGoogleLoginDelegate.h"

@class RXPromise;

@interface BGoogleHelper : NSObject<PGoogleLoginDelegate> {
    RXPromise * _promise;
}

- (RXPromise *)loginWithGoogle;

@end
