//
//  BSelectMediaAction.h
//  AFNetworking
//
//  Created by Ben on 12/11/17.
//

#import <Foundation/Foundation.h>
#import <ChatSDK/bPictureTypes.h>
#import <CropViewController/TOCropViewController.h>
#import <ChatSDK/PAction.h>

@class RXPromise;

@interface BSelectMediaAction: NSObject<PAction, UIImagePickerControllerDelegate, TOCropViewControllerDelegate, UINavigationControllerDelegate> {
    UIImagePickerController * _picker;
    RXPromise * _promise;
    bPictureType _type;
    __weak UIViewController * _controller;
}

@property (nonatomic, readwrite) UIImage * coverImage;
@property (nonatomic, readwrite) UIImage * photo;
@property (nonatomic, readwrite) NSData * videoData;
@property (nonatomic, readwrite) BOOL cropperEnabled;
@property (nonatomic, readwrite) BOOL squareCrop;

-(instancetype) initWithType: (bPictureType) type viewController: (UIViewController *) controller;
-(instancetype) initWithType: (bPictureType) type viewController: (UIViewController *) controller squareCrop: (BOOL) enabled;
-(instancetype) initWithType: (bPictureType) type viewController: (UIViewController *) controller cropEnabled: (BOOL) enabled;

@end
