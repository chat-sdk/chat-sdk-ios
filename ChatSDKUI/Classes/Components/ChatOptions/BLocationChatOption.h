//
//  BLocationOption.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 17/12/2016.
//
//

#import <ChatSDK/BChatOption.h>

@class RXPromise;
@class BSelectLocationAction;

@interface BLocationChatOption : BChatOption {
    BSelectLocationAction * _action;
}

@end
