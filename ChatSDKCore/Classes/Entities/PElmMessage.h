//
//  PELMChatViewMessage.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 31/01/2017.
//
//

#ifndef PELMMessage_h
#define PELMMessage_h

#import <ChatSDKCore/PMessage.h>

@protocol PElmThread;
@protocol PElmUser;

@protocol PElmMessage <NSObject>

-(NSString *) entityID;
-(NSNumber *) type;

// The 'text' property of the message JSON
-(NSString *) textString;

// Messages should be encoded as JSON if you want to support location messages
// This method should turn the JSON into a dictionary
-(NSDictionary *) textAsDictionary;

-(NSInteger) imageWidth;
-(NSInteger) imageHeight;

- (BOOL)showUserNameLabelForPosition: (bMessagePosition) position;
-(bMessagePosition) messagePosition;
-(id<PElmMessage>) nextMessage;

-(id<PElmThread>) thread;
-(id<PElmUser>) userModel;
-(NSNumber *) flagged;

-(NSDate *) date;

-(NSNumber *) delivered;
-(NSData *) placeholder;

-(NSURL *) thumbnailURL;
-(bMessageReadStatus) readStatus;

@end


#endif /* PELMChatViewMessage_h */
