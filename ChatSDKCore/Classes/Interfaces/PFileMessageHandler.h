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

/**
 Data in the following format:
 
 NSURL * localURL = file[bFilePath];
 NSData * data = file[bFileData];
 NSString * fileName = file[bFileName];
 NSString * mimeType = file[bFileMimeType];
 
 #define bFilePath @"file-path"
 #define bFileData @"file-data"
 #define bFileName @"file-name"
 #define bFileMimeType @"file-mime-type"

 */
- (RXPromise *)sendMessageWithFile:(NSDictionary *)file andThreadEntityID:(NSString *)threadID;
- (Class) cellClass;
-(NSString *) bundle;

@end

#endif /* PFileMessageHandler_h */
