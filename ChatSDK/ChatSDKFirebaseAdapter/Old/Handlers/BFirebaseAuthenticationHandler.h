//
//  BFirebaseAuthenticationHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDKCore/BAbstractAuthenticationHandler.h>

@interface BFirebaseAuthenticationHandler : BAbstractAuthenticationHandler {
    BOOL _userListenersAdded;
}

@end
