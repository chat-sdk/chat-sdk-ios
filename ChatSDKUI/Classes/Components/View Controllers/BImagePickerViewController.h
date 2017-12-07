//
//  BImagePickerViewController.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 28/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BImagePickerDelegate <NSObject>

-(void) sendImage: (UIImage *) image;

@end

@interface BImagePickerViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIImagePickerControllerSourceType _type;
    UIImagePickerController * _controller;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) id<BImagePickerDelegate> delegate;

-(instancetype) initWithType: (UIImagePickerControllerSourceType) type;

@end
