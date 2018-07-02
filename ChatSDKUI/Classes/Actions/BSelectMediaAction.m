//
//  BSelectMediaAction.m
//  AFNetworking
//
//  Created by Ben on 12/11/17.
//

#import "BSelectMediaAction.h"
#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

@implementation BSelectMediaAction

-(instancetype) initWithType: (bPictureType) type viewController: (UIViewController *) controller {
    if((self = [self init])) {
        _type = type;
        _controller = controller;
    }
    return self;
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
    _picker.sourceType = _type == bPictureTypeCameraImage || _type == bPictureTypeCameraVideo ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    // This code fixes an issue where the picker isn't loaded in iOS 8 and above sometimes on devices
    // This seems to be due to UIActionSheet delegate being depreciated
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [_controller presentViewController:_picker animated:NO completion:nil];
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
            [_controller presentViewController:cropViewController animated:NO completion:nil];
        }];
        
        //[self sendImage:image];
    }
    else {
        
        // SS-V
        // If we are dealing with a video then we want to return to the chat view and post the video
        NSURL * videoURL = (NSURL *)[info objectForKey:UIImagePickerControllerMediaURL];
        
        _coverImage = [self thumbnailImageForVideo:videoURL atTime:0.1];
        
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString * documentsDirectory = [paths firstObject];
        NSString * name = [BCoreUtilities.getUUID stringByAppendingString:@".mp4"];
        NSString * dataPath = [documentsDirectory stringByAppendingPathComponent:name];
        
        // Convert the video so Android can play it too
        AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
        
        NSURL * videoTransmissionURL = [NSURL fileURLWithPath:dataPath];
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetPassthrough];
        exportSession.outputURL = videoTransmissionURL;
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
    
        CMTime start = CMTimeMakeWithSeconds(0.0, 0);
        CMTimeRange range = CMTimeRangeMake(start, avAsset.duration);
        exportSession.timeRange = range;
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:picker.view animated:YES];
        // TODO: Localize
        hud.label.text = @"Converting";
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:picker.view animated:YES];
                
                switch ([exportSession status]) {
                    case AVAssetExportSessionStatusFailed:
                        NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                        [_promise rejectWithReason:exportSession.error];
                        break;
                    case AVAssetExportSessionStatusCancelled:
                        NSLog(@"Export canceled");
                        [_promise rejectWithReason:exportSession.error];
                        break;
                    default:
                        _videoData = [NSData dataWithContentsOfURL:videoTransmissionURL];
                        [_promise resolveWithResult: Nil];
                        break;
                }
                
                _promise = Nil;
                
                [picker dismissViewControllerAnimated:YES completion:Nil];
                
            });

        }];

    }
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
    
    _photo = image;
    [_promise resolveWithResult: Nil];
    _promise = Nil;
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

@end
