//
//  BGoogleHelper.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 29/03/2017.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDK/ChatUI.h>

@interface BGoogleHelper : NSObject

- (RXPromise *)loginWithGoogle;

@end
