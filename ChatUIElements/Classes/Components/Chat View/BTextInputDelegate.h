//
//  BTextInputDelegate.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 26/09/2013.
//  Copyright (c) 2013 chatsdk.co All rights reserved. The Chat SDK is issued under the MIT liceense and is available for free at http://github.com/chat-sdk
//

@protocol BTextInputDelegate <NSObject>

-(void) sendText: (NSString *) message;

// Return whether we should mark the button as selected
-(BOOL) showOptions;
// Return whether we should mark the button as deselected
-(BOOL) hideOptions;
-(void) sendAudio: (NSData *) data duration:(double) seconds;
-(void) typing;


@end

