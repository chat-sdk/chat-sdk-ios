//
//  PELMChatViewMessage.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 31/01/2017.
//
//

#ifndef PELMMessage_h
#define PELMMessage_h

#import <ChatSDK/PMessage.h>

@protocol PElmThread;
@protocol PElmUser;

@protocol PElmMessage <NSObject>

-(NSString *) entityID;
-(NSNumber *) type;

// The 'text' property of the message JSON
-(NSString *) text;

// Messages should be encoded as JSON if you want to support location messages
// This method should turn the JSON into a dictionary
-(NSDictionary *) textAsDictionary;
-(NSDictionary *) compatibilityMeta;

-(NSInteger) imageWidth;
-(NSInteger) imageHeight;

-(NSURL *) imageURL;

- (BOOL)showUserNameLabelForPosition: (bMessagePos) position;
-(bMessagePos) messagePosition;
-(id<PElmMessage>) nextMessage;

-(id<PElmThread>) thread;
-(id<PElmUser>) userModel;
-(NSNumber *) flagged;

-(NSDate *) date;

-(NSNumber *) delivered;
-(NSData *) placeholder;

-(BOOL) senderIsMe;
-(id<PElmMessage>) nextMessage;
-(id<PElmMessage>) previousMessage;

-(bMessageReadStatus) messageReadStatus;

-(NSDictionary *) meta;

@end


#endif /* PELMChatViewMessage_h */
