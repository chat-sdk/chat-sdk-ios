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
    
    // Resize the image to make a thumbnail
    CGSize newSize;
    
    // Define the new picture size to reduce both dimensions to 600 or less
    if (image.size.width > image.size.height) {
        newSize = CGSizeMake(600, 600 * image.size.height/image.size.width);
    }
    else {
        newSize = CGSizeMake(600 * image.size.width/image.size.height, 600);
    }
    UIImage * thumbnail = [image resizedImage:newSize interpolationQuality:kCGInterpolationHigh];
    
    id<PMessage> message = [BChatSDK.db createMessageEntity];
    // Generate a temporary ID
    message.entityID = [BCoreUtilities getUUID];
    
    
    [message setTextString: bNullString];
    message.type = @(bMessageTypeImage);

    id<PThread> thread = [BChatSDK.db fetchEntityWithID:threadID withType:bThreadEntity];

    message.date = [NSDate date];
    message.userModel = BChatSDK.currentUser;
    message.delivered = @NO;
    message.read = @YES;
    message.flagged = @NO;
    message.placeholder = UIImageJPEGRepresentation([self imageWithScaledImage:image], 0.6);

    [thread addMessage: message];

    return [BChatSDK.upload uploadImage:image thumbnail:thumbnail].thenOnMain(^id(NSDictionary * urls) {
        
        NSString * imageURL = urls[bImagePath];
        NSString * thumbnailURL = urls[bThumbnailPath];

        NSString * messageText = [NSString stringWithFormat:@"%@,%@,W%.0f&H%.0f", imageURL, thumbnailURL, image.size.width, image.size.height];

        [message setJson:@{bMessageTextKey: messageText,
                           bMessageImageURL: imageURL ? imageURL : @"",
                           bMessageThumbnailURL: thumbnailURL ? thumbnailURL : @"",
                           bMessageImageWidth: @(image.size.width),
                           bMessageImageHeight: @(image.size.height)}];
        
        return [BChatSDK.core sendMessage:message].thenOnMain(^id(id result) {
            message.delivered = @YES;
            return result;
        }, Nil);
    }, Nil);
}

- (UIImage*)imageWithScaledImage:(UIImage*)image {
    
    CGSize newSize;
    
    // Define the new picture size to reduce both dimensions to 600 or less
    if (image.size.width > image.size.height) {
        newSize = CGSizeMake(600, 600 * image.size.height/image.size.width);
    }
    else {
        newSize = CGSizeMake(600 * image.size.width/image.size.height, 600);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



@end
