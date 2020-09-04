//
//  BAbstractAuthenticationHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import <Foundation/Foundation.h>

@protocol PAuthenticationHandler;

@interface BAbstractAuthenticationHandler : NSObject<PAuthenticationHandler> {
    BOOL _authenticatedThisSession;
}

@end
