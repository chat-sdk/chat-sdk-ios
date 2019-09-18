//
//  BMessageBuilder.h
//  AFNetworking
//
//  Created by Ben on 12/11/18.
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PMessage.h>

@interface BMessageBuilder : NSObject {
    id<PMessage> _message;
    NSData * _data;
}

+(instancetype) message;
+(instancetype) textMessage: (NSString *) text;
+(instancetype) imageMessage: (UIImage *) image;
+(instancetype) systemMessage: (NSString *) text type: (bSystemMessageType) systemMessageType;

-(BMessageBuilder *) textMessage: (NSString *) text;
-(BMessageBuilder *) thread: (NSString *) threadID;
-(BMessageBuilder *) meta: (NSDictionary *) meta;
-(BMessageBuilder *) type: (bMessageType) type;
-(BMessageBuilder *) typeAsInt: (int) type;

-(id<PMessage>) build;

@end
