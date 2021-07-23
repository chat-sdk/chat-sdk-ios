//
//  BSelectMediaAction.m
//  AFNetworking
//
//  Created by Ben on 12/11/17.
//

#import "BSelectMediaAction.h"
#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>
#import <AssetsLibrary/AssetsLibrary.h>

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
        _picker.allowsEditing = NO;
        //_picker.allowsEditing = YES; // We comment this out as we are now editing with TOCropViewController
    }
    
    // Choose whether we want to show video, images or the camera with images and video
    if (_type == bPictureTypeAlbumVideo) {
        _picker.mediaTypes = @[(NSString *)kUTTypeMovie];
    }
    else if (_type == bPictureTypeAlbumImage) {
        _picker.mediaTypes = @[(NSString *)kUTTypeImage];
    }
    else if (_type == bPictureTypeCameraVideo) {
        _picker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie];
    }
    else {
        _picker.mediaTypes = @[(NSString *)kUTTypeImage];
    }
    
    // Make sure our picker is set to album as elsewhere we are using it for the camera
    _picker.sourceType = (_type == bPictureTypeCameraImage || _type == bPictureTypeCameraVideo) ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    // This code fixes an issue where the picker isn't loaded in iOS 8 and above sometimes on devices
    // This seems to be due to UIActionSheet delegate being depreciated
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [_controller presentViewController:_picker animated:YES completion:nil];
    }];
    
    return _promise;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // This causes a warning but it seems to be harmless
    // http://stackoverflow.com/questions/40086636/creating-an-image-format-with-an-unknown-type-is-an-error-objective-c-xcode-8
    
    
    // This checks whether we are adding image or video (public.movie for video)
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {

        [_picker dismissViewControllerAnimated:NO completion:^{
            UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
            if (image) {
                [self processSelectedImage:image error:nil];
            } else {
                [self processSelectedImage:nil error:[NSBundle t:bImageUnavailable]];
            }
        }];
        
//        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
//
//        if (!image) {
//            NSURL * url = info[UIImagePickerControllerReferenceURL];
//
//            __weak __typeof(self) weakSelf = self;
//            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
//                ALAssetRepresentation *rep = [myasset defaultRepresentation];
//                CGImageRef iref = [rep fullResolutionImage];
//                if (iref) {
//                    UIImage * image = [UIImage imageWithCGImage:iref];
//                    [weakSelf processSelectedImage:image error:nil];
//                }
//            };
//
//            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror) {
//                [weakSelf processSelectedImage:nil error:myerror.localizedDescription];
//                [_controller.view makeToast:[myerror localizedDescription]];
//            };
//
//            ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
//
//            [assetslibrary assetForURL:url
//                               resultBlock:resultblock
//                              failureBlock:failureblock];
//
//        } else {
//            [self processSelectedImage:image error: [NSBundle t:bImageUnavailable]];
//        }
        
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
                        [BChatSDK.shared.logger log: @"Export failed: %@", [[exportSession error] localizedDescription]];
                        [_promise rejectWithReason:exportSession.error];
                        break;
                    case AVAssetExportSessionStatusCancelled:
                        [BChatSDK.shared.logger log: @"Export canceled"];
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

-(void) processSelectedImage: (UIImage *) image error: (NSString *) error {
    if (image) {
        TOCropViewController * cropViewController = [[TOCropViewController alloc] initWithImage:image];
        cropViewController.delegate = self;
        
//        [_picker dismissViewControllerAnimated:NO completion:^{
            [_controller presentViewController:cropViewController animated:NO completion:nil];
//        }];
    } else {
//        [_picker dismissViewControllerAnimated:NO completion:^{
            [_controller.view makeToast:error];
//        }];
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
