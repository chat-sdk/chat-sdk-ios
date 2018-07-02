//
//  BAbstractUploadHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BAbstractUploadHandler.h"
#import <ChatSDK/Core.h>

@implementation BAbstractUploadHandler

-(RXPromise *) uploadImage:(UIImage *)image thumbnail: (UIImage *) thumbnail {
    
    // Upload the images:
    return [RXPromise all:@[[self uploadFile:UIImageJPEGRepresentation(image, 0.6f) withName:@"image.jpg" mimeType:@"image/jpeg"],
                            [self uploadFile:UIImageJPEGRepresentation(image, 0.6f) withName:@"thumbnail.jpg" mimeType:@"image/jpeg"]]].thenOnMain(^id(NSArray * results) {
        NSMutableDictionary * urls = [NSMutableDictionary new];
        for (NSDictionary * result in results) {
            if ([result[bFileName] hasSuffix:@"image.jpg"]) {
                urls[bImagePath] = result[bFilePath];
            }
            if ([result[bFileName] hasSuffix:@"thumbnail.jpg"]) {
                urls[bThumbnailPath] = result[bFilePath];
            }
        }
        return urls;
    }, Nil);
}

-(RXPromise *) uploadFile:(NSData *)file withName: (NSString *) name mimeType: (NSString *) mimeType {
    assert(NO);
}

@end
