//
//  BMessageLayout.h
//  ChatUI
//
//  Created by Benjamin Smiley-andrews on 02/04/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ChatSDK/PMessageLayout.h>

#define bTimeLabelPadding 10
#define bTimeLabelHeight 12
#define bTimeLabelWidth 30
#define bMaxMessageWidth 200
#define bMaxMessageHeight 300
#define bMinMessageHeight 50
#define bUserNameHeight 25

@protocol PElmMessage;

@interface BMessageLayout : NSObject<PMessageLayout> {
    __weak id<PElmMessage> _message;
}

+(BMessageLayout *) layoutWithMessage: (id<PElmMessage>) message;

@end
