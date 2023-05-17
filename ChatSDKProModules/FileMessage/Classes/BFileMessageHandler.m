//
//  BFileMessageHandler.m
//  ChatSDKModules
//
//  Created by Pepe Becker on 19.04.18.
//

#import "BFileMessageHandler.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>
#import "FileMessage.h"
#import "BFileMessageCell.h"

@implementation BFileMessageHandler

- (RXPromise *)sendMessageWithFile:(NSDictionary *)file andThreadEntityID:(NSString *)threadID {
    
//    [BChatSDK.db beginUndoGroup];
    
    id<PMessage> message = [[[[BMessageBuilder message] type:bMessageTypeFile] thread:threadID] build];
    
    NSURL * localURL = file[bFilePath];
    NSData * data = file[bFileData];
    NSString * fileName = file[bFileName];
    NSString * mimeType = file[bFileMimeType];
    
    [message setText: fileName];

    [BHookNotification notificationMessageWillUpload: message];
    
    UIImage * thumbnail = Nil;
    if ([mimeType isEqualToString:@"application/pdf"]) {
        thumbnail = [self getPdfPreview:data];
    }
    
    return [self uploadFileWithData:data name:fileName mimeType:mimeType thumbnail:thumbnail message:message].thenOnMain(^id(NSDictionary * result) {
        
        NSMutableDictionary * meta = [NSMutableDictionary new];
        [meta setObject:fileName forKey:bMessageText];
        [meta setObject:mimeType forKey:bMessageMimeType];
        [meta setObject:[result[bFilePath] absoluteString] forKey:bMessageFileURL];
        [meta setObject:@(data.length) forKey:bMessageSize];

        NSURL * imagePath = result[bImagePath];
        if (imagePath) {
            [meta setObject:imagePath.absoluteString forKey:bMessageImageURL];
        }
        
        [message setMeta:meta];

        [BHookNotification notificationMessageDidUpload: message withData: data];

        return [BFileCache cacheFileFromURL:localURL withFileName:fileName andCacheName:message.entityID]
        .thenOnMain(^id(id result) {
            return [BChatSDK.thread sendMessage:message];
        }, Nil);
    }, Nil);
}

-(Class) cellClass {
    return [BFileMessageCell class];
}

-(NSString *) bundle {
    return bFileMessageBundle;
}

-(RXPromise *)uploadFileWithData:(NSData *) data name: (NSString *) name mimeType: (NSString *) mimeType thumbnail: (UIImage *)thumbnail message: (id<PMessage>) message {
    NSMutableArray * promises = [NSMutableArray new];
    
    // Always upload the file
    [promises addObject:[BChatSDK.upload uploadFile:data withName:name mimeType:mimeType message:message]];

    if(thumbnail) {
        [promises addObject:[BChatSDK.upload uploadFile:UIImageJPEGRepresentation(thumbnail, 0.6f) withName:@"thumbnail.jpg" mimeType:@"image/jpeg"]];
    }
    
    return [RXPromise all:promises].thenOnMain(^id(NSArray * results) {

        NSMutableDictionary * urls = [NSMutableDictionary new];
        
        for (NSDictionary * result in results) {
            
            if ([result[bFileName] hasSuffix:@"thumbnail.jpg"]) {
                urls[bImagePath] = result[bFilePath];
            }
            if ([result[bFileName] hasSuffix:name]) {
                urls[bFilePath] = result[bFilePath];
            }
        }
        return urls;
    }, Nil);
}

-(UIImage *) getPdfPreview: (NSData *) data {
    CFDataRef myPDFData = (__bridge CFDataRef)data;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(myPDFData);
    CGPDFDocumentRef documentRef = CGPDFDocumentCreateWithProvider(provider);
    
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(documentRef, 1);
    CGRect pageRect = CGPDFPageGetBoxRect(pageRef, kCGPDFCropBox);
    
    UIGraphicsBeginImageContext(pageRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, CGRectGetMinX(pageRect),CGRectGetMaxY(pageRect));
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, -(pageRect.origin.x), -(pageRect.origin.y));
    CGContextDrawPDFPage(context, pageRef);
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}

@end
