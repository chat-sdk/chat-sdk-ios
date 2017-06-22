//
//  BMediaChatOption.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 17/12/2016.
//
//

#import "BMediaChatOption.h"
#import <ChatSDK/ChatCore.h>
#import <ChatSDK/ChatUI.h>

#import <MobileCoreServices/MobileCoreServices.h>

@implementation BMediaChatOption

-(id) initWithType: (bPictureType) type {
    if((self = [self init])) {
        _type = type;
    }
    return self;
}

-(UIImage *) icon {
    NSString * image;
    switch (_type) {
        case bPictureTypeAlbumImage:
            image = @"icn_60_gallery.png";
            break;
        case bPictureTypeAlbumVideo:
            image = @"icn_60_video_clip.png";
            break;
        case bPictureTypeCameraImage:
            image = @"icn_60_camera.png";
            break;
        case bPictureTypeCameraVideo:
            image = @"icn_60_camera.png";
            break;
    }

    return [NSBundle chatUIImageNamed:image];
}

-(NSString *) title {
    NSString * title;
    switch (_type) {
        case bPictureTypeAlbumImage:
            title = [NSBundle t:bChoosePhoto];
            break;
        case bPictureTypeAlbumVideo:
            title = [NSBundle t:bChooseVideo];
            break;
        case bPictureTypeCameraImage:
            title = [NSBundle t:bCamera];
            break;
        case bPictureTypeCameraVideo:
            title = [NSBundle t:bCamera];
            break;
    }
    
    return title;
}


- (RXPromise * ) execute {

    if (!_promise) {
        _promise = [RXPromise new];
    }
    
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        //_picker.allowsEditing = YES; // We comment this out as we are now editing with TOCropViewController
    }
    
    // Choose whether we want to show video, images or the camera with images and video
    if (_type == bPictureTypeAlbumVideo) {
        _picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    }
    else if (_type == bPictureTypeAlbumImage) {
        _picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, nil];
    }
    else if (_type == bPictureTypeCameraVideo) {
        _picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, (NSString *) kUTTypeMovie, nil];
    }
    else {
        _picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, nil];
    }
    
    // Make sure our picker is set to album as elsewhere we are using it for the camera
    _picker.sourceType = _type == bPictureTypeCameraImage || _type == bPictureTypeCameraVideo ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    
    // This code fixes an issue where the picker isn't loaded in iOS 8 and above sometimes on devices
    // This seems to be due to UIActionSheet delegate being depreciated
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.parent.delegate.currentViewController presentViewController:_picker animated:NO completion:nil];
    }];
    
    return _promise;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // This causes a warning but it seems to be harmless
    // http://stackoverflow.com/questions/40086636/creating-an-image-format-with-an-unknown-type-is-an-error-objective-c-xcode-8
    
    // This checks whether we are adding image or video (public.movie for video)
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
        
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        TOCropViewController * cropViewController = [[TOCropViewController alloc] initWithImage:image];
        cropViewController.delegate = self;
        
        [picker dismissViewControllerAnimated:NO completion:^{
            [self.parent.delegate.currentViewController presentViewController:cropViewController animated:NO completion:nil];
        }];
        
        //[self sendImage:image];
    }
    else {
        
        // SS-V
        // If we are dealing with a video then we want to return to the chat view and post the video
        NSURL * videoURL = (NSURL *)[info objectForKey:UIImagePickerControllerMediaURL];
        
        NSData * videoData = [NSData dataWithContentsOfURL:videoURL];
        
        UIImage * cover = [self thumbnailImageForVideo:videoURL atTime:0.1];
        cover = [self drawImage:cover withBadge:[NSBundle chatUIImageNamed:@"play-button.png"]];
        
        // Send video to the chat view
        if(NM.videoMessage) {
            [_promise resolveWithResult:[self.parent.delegate sendVideoMessage:videoData withCoverImage:cover]];
            
            [self.parent.delegate reloadData];
            _promise = Nil;
        }
        
        [picker dismissViewControllerAnimated:YES completion:Nil];
    }
    
    if(!_promise) {
        [_promise resolveWithResult:Nil];
        _promise = Nil;
    }
    
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
    
    // 'image' is the newly cropped version of the original image
    [_promise resolveWithResult:[self.parent.delegate sendImageMessage:image]];
    
    _promise = Nil;
    [self.parent.delegate reloadData];
    [cropViewController dismissViewControllerAnimated:YES completion:nil];

}

// We want to send the video with an image of the first scene - this probably wants to go somewhere else
- (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset * asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
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

// SS-V
-(UIImage *)drawImage:(UIImage*)profileImage withBadge:(UIImage *)badge {
    
    UIGraphicsBeginImageContextWithOptions(profileImage.size, NO, 0.0f);
    
    // Add the extra image in the centre and make its size a third of the width of the picture
    [profileImage drawInRect:CGRectMake(0, 0, profileImage.size.width, profileImage.size.height)];
    [badge drawInRect:CGRectMake(profileImage.size.width/2 - profileImage.size.width/6, profileImage.size.height/2 - profileImage.size.width/6, profileImage.size.width/3, profileImage.size.width/3)];
    
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}


@end
