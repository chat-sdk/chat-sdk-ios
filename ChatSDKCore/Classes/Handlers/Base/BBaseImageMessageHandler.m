//
//  BBaseImageMessageHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BBaseImageMessageHandler.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/ChatSDK-Swift.h>

@implementation BBaseImageMessageHandler

-(RXPromise *) sendMessageWithImage:(UIImage *)image withThreadEntityID:(NSString *)threadID {
    
//    [BChatSDK.db beginUndoGroup];
   
    
    
    id<PMessage> message = [[[BMessageBuilder imageMessage:image] thread:threadID] build];
    
    // Resize image
//    UIImage * resizedImage = [self imageWithScaledImage:image];
//    message.placeholder = resizedImage;

    [BHookNotification notificationMessageWillUpload: message];
    
//    [message setPlaceholder:UIImageJPERepresentation(image)];
    
    return [BChatSDK.upload uploadFile:UIImageJPEGRepresentation(image, 0) withName:@"image.jpg" mimeType:@"image/jpeg" message: message].thenOnMain(^id(NSDictionary * info) {
        
        NSURL * url = info[bFilePath] ? info[bFilePath] : Nil;
        NSString * urlString = url ? url.absoluteString : @"";

        [message setMeta:@{bMessageImageURL: urlString,
                           bMessageImageWidth: @(image.size.width),
                           bMessageImageHeight: @(image.size.height),
                           bMessageText: [NSBundle t:bImageMessage],
        }];
        
        if (BChatSDK.config.sendBase64ImagePreview) {

            CGFloat size = BChatSDK.config.imagePreviewMaxSize;
            CGFloat quality = BChatSDK.config.imagePreviewQuality;
            
            NSString * base64 = [image toBase64LegWithWidth: size quality: quality];
            [message setMetaValue:base64 forKey:bMessageImagePreview];
        }
        
        [BHookNotification notificationMessageDidUpload: message];

        return [BChatSDK.thread sendMessage:message];
    }, Nil);

}

- (UIImage*)imageWithScaledImage:(UIImage*)image {
    return [self imageWithScaledImage:image maxDimension:BChatSDK.config.maxImageDimension];
}

- (UIImage*)imageWithScaledImage:(UIImage*)image maxDimension: (float) maxDimension {
    
    CGSize newSize;
    
    // Define the new picture size to reduce both dimensions to 600 or less
    if (image.size.width > image.size.height) {
        newSize = CGSizeMake(maxDimension, maxDimension * image.size.height/image.size.width);
    }
    else {
        newSize = CGSizeMake(maxDimension * image.size.width/image.size.height, maxDimension);
    }
    
    return [image resizedImage:newSize interpolationQuality:kCGInterpolationHigh];
}



@end
