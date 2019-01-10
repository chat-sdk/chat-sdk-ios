//
//  BBaseImageMessageHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BBaseImageMessageHandler.h"

#import <ChatSDK/Core.h>

@implementation BBaseImageMessageHandler

-(RXPromise *) sendMessageWithImage:(UIImage *)image withThreadEntityID:(NSString *)threadID {
    
    [BChatSDK.db beginUndoGroup];
    
    id<PMessage> message = [[[BMessageBuilder imageMessage:image] thread:threadID] build];
    
//    // Resize the image to make a thumbnail
//    CGSize newSize;
//
//    // Define the new picture size to reduce both dimensions to 600 or less
//    if (image.size.width > image.size.height) {
//        newSize = CGSizeMake(600, 600 * image.size.height/image.size.width);
//    }
//    else {
//        newSize = CGSizeMake(600 * image.size.width/image.size.height, 600);
//    }
//    UIImage * thumbnail = [image resizedImage:newSize interpolationQuality:kCGInterpolationHigh];
//
//    id<PMessage> message = [BChatSDK.db createMessageEntity];
//    // Generate a temporary ID
//    message.entityID = [BCoreUtilities getUUID];
//
//
//    [message setTextString: bNullString];
//    message.type = @(bMessageTypeImage);
//
//    id<PThread> thread = [BChatSDK.db fetchEntityWithID:threadID withType:bThreadEntity];
//
//    message.date = [NSDate date];
//    message.userModel = BChatSDK.currentUser;
//    message.delivered = @NO;
//    message.read = @YES;
//    message.flagged = @NO;
//    message.placeholder = UIImageJPEGRepresentation([self imageWithScaledImage:image], 0.6);
//
//    [thread addMessage: message];
    
    // Resize image
    UIImage * resizedImage = [self imageWithScaledImage:image];

    [BHookNotification notificationMessageWillUpload: message];
    
    return [BChatSDK.upload uploadFile:UIImageJPEGRepresentation(resizedImage, 0.3) withName:@"image.jpg" mimeType:@"image/jpeg"].thenOnMain(^id(NSDictionary * info) {
        
        NSURL * url = info[bFilePath] ? info[bFilePath] : Nil;
        NSString * urlString = url ? url.absoluteString : @"";

        [message setJson:@{bMessageImageURL: urlString,
                           bMessageThumbnailURL: urlString,
                           bMessageImageWidth: @(image.size.width),
                           bMessageImageHeight: @(image.size.height)}];
        
        [BHookNotification notificationMessageDidUpload: message];

        return [BChatSDK.core sendMessage:message];
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
