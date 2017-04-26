//
//  BAbstractAuthenticationHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDKCore/ChatCore.h>
#import <ChatSDKCore/PAuthenticationHandler.h>

@interface BAbstractAuthenticationHandler : NSObject<PAuthenticationHandler> {
}

@property (nonatomic, readwrite) UIViewController * challengeViewController;

@end
