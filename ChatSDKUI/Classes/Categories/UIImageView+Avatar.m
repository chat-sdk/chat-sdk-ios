//
//  UIImageView+Avatar.m
//  AFNetworking
//
//  Created by ben3 on 28/06/2019.
//

#import "UIImageView+Avatar.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>
#import <ChatSDK/ChatSDK-Swift.h>

@implementation UIImageView(Avatar)

-(void) loadAvatar: (id<PElmUser>) user {
    if (user.imageURL && user.imageURL.length) {
        [self sd_setImageWithURL:[NSURL URLWithString:user.imageURL]
                placeholderImage:self.userDefaultImage
                         options: SDWebImageLowPriority & SDWebImageScaleDownLargeImages];
    } else {
        UIImage * image = user.imageAsImage;
        if (image) {
            [self setImage:image];
        } else {
            [self setDefaultUserImage];
        }
    }
}

-(UIImage *) userDefaultImage {
    return Icons.defaultUserImage;
}

-(void) setDefaultUserImage {
    self.image = self.userDefaultImage;
}

-(void) loadThreadImage: (id<PThread>) thread {
    if (thread.imageURL && thread.imageURL.length) {
        [self sd_setImageWithURL:[NSURL URLWithString:thread.imageURL]
                placeholderImage:[self defaultImage:thread]
                         options: SDWebImageLowPriority & SDWebImageScaleDownLargeImages];

    } else {
        if ([thread typeIs:bThreadType1to1]) {
            UIImage * otherImage = thread.otherUser.imageAsImage;
            if (otherImage) {
                self.image = otherImage;
                return;
            }
        }
        
        // See if all the users have images
        NSMutableArray * users = [NSMutableArray new];
        for (id<PUser> user in thread.members) {
            if (user.image) {
                [users addObject:user];
            }
        }
        
        if (users.count > 0) {
            self.image = [self buildImageForUsers:users];
            return;
        }
        
        [self setDefaultImage:thread];
    }
}

-(UIImage *) defaultImage: (id<PThread>) forThread {
    if (forThread.type.intValue & bThreadFilterGroup) {
        return [Icons getWithName:Icons.defaultGroup];
    }
    else {
        return [Icons getWithName:Icons.defaultProfile];
    }
}

-(void) setDefaultImage: (id<PThread>) forThread {
    self.image = [self defaultImage:forThread];
}

//-(RXPromise *) imageForThread: (id<PThread>) thread {
//    [self checkOnMain];
//
//    NSMutableArray * userPromises = [NSMutableArray new];
//    NSMutableArray * users = [NSMutableArray arrayWithArray:thread.users.allObjects];
//    for (id<PUser> user in users) {
//        if (!user.image && !user.isMe) {
//            [userPromises addObject:user.updateAvatarFromURL];
//        }
//    }
//
//    return [RXPromise all:userPromises].thenOnMain(^id(id result) {
//        return thread.buildImageForThread;
//    }, Nil);
//}

//- (UIImage *) buildImageForThread: (id<PThread>) thread {
//    [self checkOnMain];
//
//    NSMutableArray * users = [NSMutableArray arrayWithArray:thread.users.allObjects];
//
//    // Remove the current user from the array
//    [users removeObject:BChatSDK.currentUser];
//
//    // Create a temporary array as we cannot loop through an array and remove users
//    NSMutableArray * tempUsers = [NSMutableArray arrayWithArray:users];
//
//    // We want to remove any users who have the automatic profile picture
//    for (id<PUser> user in tempUsers) {
//
//        // Check if the user picture has been uploaded
//        if (!user.image) {
//            [users removeObject:user];
//        }
//    }
//
//    // If users array empty then just return the defaut picture
//    if (!users.count) {
//
//        // Check how many users are in the conversation
//        if (thread.type.intValue & bThreadFilterPublic) {
//            return [Icons getWithName:Icons.defaultGroup];
//        }
//        else {
//            return [Icons getWithName:Icons.defaultProfile];
//        }
//    }
//
//    return [self buildImageForUsers:users];
//}

- (UIImage *) buildImageForUsers: (NSMutableArray *) users {
    [self checkOnMain];
    
    // Remove the current user from the array
//    [users removeObject:BChatSDK.currentUser];
    
    // Create a temporary array as we cannot loop through an array and remove users
//    NSMutableArray * tempUsers = [NSMutableArray arrayWithArray:users];
    
    // We want to remove any users who have the automatic profile picture
//    for (id<PUser> user in tempUsers) {
//
//        // Check if the user picture has been uploaded
//        if (!user.image) {
//            [users removeObject:user];
//        }
//    }
    
    if (users.count == 1) {
        // Only one user left so use their picture
        id<PUser> user = users.firstObject;
        return [UIImage imageWithData:user.image];
    }
    else {
        
        // When we get the user thumbnail image we make sure it is the size we want so resize it to be 100 x 100
        UIImage * image1 = [[UIImage imageWithData:((id<PUser>)users.firstObject).image] resizeImageToSize:CGSizeMake(100, 100)];
        
        // Then crop the image
        image1 = [image1 croppedImage:CGRectMake(25, 0, 49, 100)];
        
        // If there are two users then we need to split the picture in half
        if (users.count == 2) {
            
            // When we get the user thumbnail image we make sure it is the size we want so resize it to be 100 x 100
            UIImage * image2 = [[UIImage imageWithData:((id<PUser>)users.lastObject).image] resizeImageToSize:CGSizeMake(100, 100)];
            
            // Then crop the image
            image2 = [image2 croppedImage:CGRectMake(25, 0, 49, 100)];
            
            // Combine the images
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), NO, 0.0);
            
            [image1 drawInRect:CGRectMake(0, 0, 49, 100)];
            [image2 drawInRect:CGRectMake(51, 0, 49, 100)];
        }
        else {
            
            // Thumbnails done by using parse change
            UIImage * image2 = [UIImage imageWithData:((id<PUser>)users[1]).image];
            UIImage * image3 = [UIImage imageWithData:((id<PUser>)users[2]).image];
            
            // Combine the images
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), NO, 0.0);
            
            [image1 drawInRect:CGRectMake(0, 0, 49, 100)];
            [image2 drawInRect:CGRectMake(51, 0, 49, 49)];
            [image3 drawInRect:CGRectMake(51, 51, 49, 49)];
        }
        
        UIImage * finalImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return finalImage;
    }}

@end
