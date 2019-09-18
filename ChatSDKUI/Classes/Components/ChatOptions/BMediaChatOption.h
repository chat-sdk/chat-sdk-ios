//
//  BMediaChatOption.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 17/12/2016.
//
//

#import <ChatSDK/BChatOption.h>
#import <ChatSDK/bPictureTypes.h>

#import <TOCropViewController/TOCropViewController.h>

@class RXPromise;
@protocol TOCropViewControllerDelegate;

@interface BMediaChatOption : BChatOption<UIImagePickerControllerDelegate, TOCropViewControllerDelegate> {
    UIImagePickerController * _picker;
    RXPromise * _promise;
    bPictureType _type;
}

-(instancetype) initWithType: (bPictureType) type;

@end
