//
//  BUploadHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 07/03/2016.
//
//

#ifndef PUploadHandler_h
#define PUploadHandler_h

#define bFilePath @"file-path"
#define bFileName @"file-name"

@class RXPromise;
@protocol PMessage;

@protocol PUploadHandler <NSObject>

-(RXPromise *) uploadFile:(NSData *)file withName: (NSString *) name mimeType: (NSString *) mimeType;
-(RXPromise *) uploadFile:(NSData *)file withName: (NSString *) name mimeType: (NSString *) mimeType message: (id<PMessage>) message;

-(RXPromise *) uploadImage:(UIImage *)image;

@end

#endif /* PUploadHandler_h */
