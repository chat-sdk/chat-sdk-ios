//
//  BAbstractAuthenticationHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import <Foundation/Foundation.h>

@protocol PAuthenticationHandler;
@protocol PUser;

@interface BAbstractAuthenticationHandler : NSObject<PAuthenticationHandler> {
    BOOL _isAuthenticatedThisSession;
    NSString * _currentUserID;
    id<PUser> _currentUser;
}

@end
