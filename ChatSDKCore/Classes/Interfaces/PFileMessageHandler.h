//
//  PFileMessageHandler.h
//  ChatSDK
//
//  Created by Pepe Becker on 19.04.18.
//

#ifndef PFileMessageHandler_h
#define PFileMessageHandler_h

@class RXPromise;

@protocol PFileMessageHandler <NSObject>

- (RXPromise *)sendMessageWithFile:(NSDictionary *)file andThreadEntityID:(NSString *)threadID;
- (Class) cellClass;
-(NSString *) bundle;

@end

#endif /* PFileMessageHandler_h */
