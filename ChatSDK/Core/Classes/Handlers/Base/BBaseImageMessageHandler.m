//
//  BBaseImageMessageHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BBaseImageMessageHandler.h"

#import <ChatSDK/ChatCore.h>

@implementation BBaseImageMessageHandler

-(RXPromise *) sendMessageWithImage:(UIImage *)image withThreadEntityID:(NSString *)threadID {
    
    [[BStorageManager sharedManager].a beginUndoGroup];
    
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
    
    id<PMessage> message = [[BStorageManager sharedManager].a createEntity:bMessageEntity];
    
    message.type = @(bMessageTypeImage);
    
    [message setTextAsDictionary:@{bMessageTextKey: bNullString}];
    
    message.thread = [[BStorageManager sharedManager].a fetchEntityWithID:threadID withType:bThreadEntity];
    message.date = [NSDate date];
    message.userModel = [BNetworkManager sharedManager].a.core.currentUserModel;
    message.delivered = @NO;
    message.read = @YES;
    message.flagged = @NO;
    message.placeholder = UIImageJPEGRepresentation([self imageWithScaledImage:image], 0.6);
    
    return [[BNetworkManager sharedManager].a.upload uploadImage:image thumbnail:thumbnail].thenOnMain(^id(NSDictionary * urls) {
        
        NSString * imageURL = urls[bImagePath];
        NSString * thumbnailURL = urls[bThumbnailPath];

        NSString * messageText = [NSString stringWithFormat:@"%@,%@,W%.0f&H%.0f", imageURL, thumbnailURL, image.size.width, image.size.height];

        [message setTextAsDictionary:@{bMessageTextKey: messageText,
                                       bMessageImageURL: imageURL ? imageURL : @"",
                                       bMessageThumbnailURL: thumbnailURL ? thumbnailURL : @"",
                                       bMessageImageWidth: @(image.size.width),
                                       bMessageImageHeight: @(image.size.height)}];
        
        return [[BNetworkManager sharedManager].a.core sendMessage:message];
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
