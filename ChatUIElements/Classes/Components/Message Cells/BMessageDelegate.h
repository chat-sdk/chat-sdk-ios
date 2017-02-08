//
//  BMessageDelegate.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 26/09/2013.
//  Copyright (c) 2013 chatsdk.co All rights reserved. The Chat SDK is issued under the MIT liceense and is available for free at http://github.com/chat-sdk
//

#import "PMessage.h"
#import "PMessageLayout.h"

@protocol BMessageDelegate <NSObject>

-(void) setMessage: (id<PMessage, PMessageLayout>) message;
-(void) setMessage: (id<PMessage, PMessageLayout>) message withColorWeight: (float) colorWeight;

-(void) willDisplayCell;

@end
