//
//  BFirebaseVideoMessageHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/12/2016.
//
//

#import "BVideoMessageHandler.h"
#import <ChatSDK/Core.h>
#import "BVideoMessageCell.h"
#import <ChatSDK/ChatSDK-Swift.h>

@implementation BVideoMessageHandler

-(RXPromise *) sendMessageWithVideo: (AVURLAsset *) urlAsset withThreadEntityID:(NSString *)threadID {
    UIImage * image = [self thumbnailImageForVideo:urlAsset.URL atTime:0.1];
    NSData * data = [[NSData alloc] initWithContentsOfURL:urlAsset.URL];
    return [self sendMessageWithVideo:data coverImage:image withThreadEntityID:threadID];
}

// We want to send the video with an image of the first scene - this probably wants to go somewhere else
- (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset * asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    return [self thumbnailImageForAsset:asset atTime:time];
}

// We want to send the video with an image of the first scene - this probably wants to go somewhere else
- (UIImage *)thumbnailImageForAsset:(AVAsset *) asset atTime:(NSTimeInterval)time {
    if (!asset) {
        return nil;
    }
    
    AVAssetImageGenerator *assetIG = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetIG.appliesPreferredTrackTransform = YES;
    assetIG.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *igError = nil;
    thumbnailImageRef = [assetIG copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&igError];
    
    if (!thumbnailImageRef) NSLog(@"thumbnailImageGenerationError %@", igError);
    UIImage * thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef]: nil;
        
    return thumbnailImage;
}

-(RXPromise *) sendMessageWithVideo: (NSData *) data coverImage:(UIImage *)image withThreadEntityID:(NSString *)threadID {
//    [BChatSDK.db beginUndoGroup];
    
    id<PMessage> message = [[[[BMessageBuilder message] type:bMessageTypeVideo] thread:threadID] build];
    
    message.placeholder = UIImageJPEGRepresentation([self imageWithScaledImage:image], 0.6);
    
    // Convert the video to a format Android can play
    
    [BHookNotification notificationMessageWillUpload:message];

    return [self uploadVideoWithData:data thumbnail:image message: message].thenOnMain(^id(NSDictionary * urls) {

        NSURL * videoURL = urls[bVideoPath];
        NSURL * videoImageURL = urls[bImagePath];
        
        [message setMeta:@{bMessageText: [NSBundle t:bVideoMessage],
                           bMessageImageURL: videoImageURL.absoluteString,
                           bMessageImageWidth: @(image.size.width),
                           bMessageImageHeight: @(image.size.height),
                           bMessageVideoURL: videoURL.absoluteString,
                           bMessageSize: @(data.length),
        }];
        
        if (BChatSDK.config.sendBase64ImagePreview) {
            CGFloat size = BChatSDK.config.imagePreviewMaxSize;
            CGFloat quality = BChatSDK.config.imagePreviewQuality;
            
            NSString * base64 = [image toBase64LegWithWidth: size quality: quality];
            [message setMetaValue:base64 forKey:bMessageImagePreview];
        }

        
        [BHookNotification notificationMessageDidUpload: message withData: data];

        return [BChatSDK.thread sendMessage:message];
    }, Nil);
}

-(RXPromise *)uploadVideoWithData:(NSData *) data thumbnail: (UIImage *)thumbnail message: (id<PMessage>) message {
    return [RXPromise all:@[[BChatSDK.upload uploadFile:UIImageJPEGRepresentation(thumbnail, 0.6f) withName:@"thumbnail.jpg" mimeType:@"image/jpeg"],
                            [BChatSDK.upload uploadFile:data withName:@"video.mp4" mimeType:@"video/mp4" message: message]]].thenOnMain(^id(NSArray * results) {
        NSMutableDictionary * urls = [NSMutableDictionary new];
        
        for (NSDictionary * result in results) {
            
            if ([result[bFileName] hasSuffix:@"thumbnail.jpg"]) {
                urls[bImagePath] = result[bFilePath];
            }
            if ([result[bFileName] hasSuffix:@"video.mp4"]) {
                urls[bVideoPath] = result[bFilePath];
            }
        }
        return urls;
    }, Nil);
}

-(Class) cellClass {
    return [BVideoMessageCell class];
}

@end
