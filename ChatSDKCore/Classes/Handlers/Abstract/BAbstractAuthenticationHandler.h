//
//  BAbstractAuthenticationHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDK/Core.h>
#import <ChatSDK/PAuthenticationHandler.h>

@interface BAbstractAuthenticationHandler : NSObject<PAuthenticationHandler> {
    BOOL _authenticatedThisSession;
}

@end
