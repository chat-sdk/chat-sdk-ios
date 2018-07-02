//
//  BBaseLocationMessageHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BBaseLocationMessageHandler.h"

#import <MapKit/MapKit.h>

#import <ChatSDK/Core.h>

@implementation BBaseLocationMessageHandler

-(RXPromise *) sendMessageWithLocation:(CLLocation *)location withThreadEntityID:(NSString *)threadID {
    
    [[BStorageManager sharedManager].a beginUndoGroup];
    
    id<PMessage> message = [[BStorageManager sharedManager].a createEntity:bMessageEntity];
    
    message.type = @(bMessageTypeLocation);
    
    id<PThread> thread = [[BStorageManager sharedManager].a fetchEntityWithID:threadID withType:bThreadEntity];

    message.date = [NSDate date];
    message.userModel = NM.currentUser;
    message.delivered = @NO;
    message.read = @YES;
    message.flagged = @NO;

    [thread addMessage: message];
    
    // TODO: Get rid of this
    NSString * messageText = [NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude];

    [message setTextAsDictionary:@{bMessageTextKey: messageText,
                                   bMessageLongitude: @(location.coordinate.longitude),
                                   bMessageLatitude: @(location.coordinate.latitude)}];
    
    return [NM.core sendMessage:message].thenOnMain(^id(id result) {
        message.delivered = @YES;
        return result;
    }, Nil);;

    
// message.placeholder = UIImageJPEGRepresentation(image, 0.6);
    
    // Set the text initally - we'll update it when we've uploaded the screenshots for Android
    // This allows the map view to show their current location immediately
//    NSString * messageText = [NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude];
//    [message setTextAsDictionary:@{bMessageTextKey: messageText,
//                                   bMessageLongitude: @(location.coordinate.longitude),
//                                   bMessageLatitude: @(location.coordinate.latitude)}];
//
//    MKCoordinateRegion region = [BCoreUtilities regionForLongitude:location.coordinate.longitude
//                                                          latitude:location.coordinate.latitude];
//
//    MKPointAnnotation * annotation = [BCoreUtilities annotationForLongitude:location.coordinate.longitude
//                                                                   latitude:location.coordinate.latitude];
//
//    // Get a screenshot of the location map
//    MKMapSnapshotOptions * options = [[MKMapSnapshotOptions alloc] init];
//    options.region = region;
//    options.scale = [UIScreen mainScreen].scale;
//    options.size = [UIScreen mainScreen].bounds.size;
//
//    MKMapSnapshotter * snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
//
//    RXPromise * promise = [RXPromise new];
//
//    [snapshotter startWithCompletionHandler:^(MKMapSnapshot * snapshot, NSError * error) {
//
//        //
//        // We have to draw the pin manually!
//        //
//
//        UIImage *image = snapshot.image;
//
//        // Get the size of the final image
//
//        CGRect finalImageRect = CGRectMake(0, 0, image.size.width, image.size.height);
//
//        // Get a standard annotation view pin.
//        MKAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:@""];
//        UIImage *pinImage = pin.image;
//
//        // ok, let's start to create our final image
//        UIGraphicsBeginImageContextWithOptions(image.size, YES, image.scale);
//
//        // first, draw the image from the snapshotter
//        [image drawAtPoint:CGPointMake(0, 0)];
//
//        // Draw the annotation
//        CGPoint point = [snapshot pointForCoordinate:annotation.coordinate];
//        if (CGRectContainsPoint(finalImageRect, point)) // this is too conservative, but you get the idea
//        {
//            CGPoint pinCenterOffset = pin.centerOffset;
//            point.x -= pin.bounds.size.width / 2.0;
//            point.y -= pin.bounds.size.height / 2.0;
//            point.x += pinCenterOffset.x;
//            point.y += pinCenterOffset.y;
//
//            [pinImage drawAtPoint:point];
//        }
//
//        // grab the final image
//        UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//
//        // Thumbnail
//        UIImage * thumbnail = [finalImage resizedImage:CGSizeMake(300, 300 * finalImage.size.height / finalImage.size.width) interpolationQuality:kCGInterpolationHigh];
//
//        [promise resolveWithResult:@{bImagePath: finalImage, bThumbnailPath: thumbnail}];
//    }];
//
//    // TODO: Remove the image upload
//    promise.thenOnMain(^id(NSDictionary * images) {
//
//        UIImage * image = images[bImagePath];
//        UIImage * thumbnail = images[bThumbnailPath];
//
//        // Upload the images to Parse
//        return [NM.upload uploadImage:image thumbnail:thumbnail].thenOnMain(^id(NSDictionary * urls) {
//
//            NSString * imageURL = urls[bImagePath];
//            NSString * thumbnailURL = urls[bThumbnailPath];
//
//            NSString * messageText = [NSString stringWithFormat:@"%f,%f,%@,%@,W%.0f&H%.0f",location.coordinate.latitude,location.coordinate.longitude, imageURL, thumbnailURL, image.size.width, image.size.height];
//
//            [message setTextAsDictionary:@{bMessageTextKey: messageText,
//                                           bMessageLongitude: @(location.coordinate.longitude),
//                                           bMessageLatitude: @(location.coordinate.latitude),
//                                           bMessageImageURL: imageURL ? imageURL : @"",
//                                           bMessageThumbnailURL: thumbnailURL ? thumbnailURL : @"",
//                                           bMessageImageWidth: @(image.size.width),
//                                           bMessageImageHeight: @(image.size.height)}];
//
//
//            return [NM.core sendMessage:message].thenOnMain(^id(id result) {
//                message.delivered = @YES;
//                return result;
//            }, Nil);
//
//        }, Nil);
//    }, Nil);
//
//    return promise;
}

@end
