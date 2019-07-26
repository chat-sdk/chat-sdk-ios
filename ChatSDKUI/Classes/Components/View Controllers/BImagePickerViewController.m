//
//  BImagePickerViewController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 28/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import "BImagePickerViewController.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

@interface BImagePickerViewController ()

@end

@implementation BImagePickerViewController

@synthesize imageView;
@synthesize delegate;

-(instancetype) initWithType: (UIImagePickerControllerSourceType) type
{
    self = [super initWithNibName:Nil bundle:Nil];
    if (self) {
        _type = type;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _controller = [[UIImagePickerController alloc] init];
    [_controller setSourceType:_type];
    
    // image picker needs a delegate,
    [_controller setDelegate:self];
    
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];


    imageView.layer.borderWidth = 10;
    imageView.layer.borderColor = [UIColor blackColor].CGColor;
    imageView.layer.cornerRadius = 20;
    imageView.clipsToBounds = YES;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    [self.navigationController presentViewController:_controller animated:NO completion:Nil];

}

-(BOOL) prefersStatusBarHidden {
    return YES;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (imageView.image != Nil) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle t: bSend] style:UIBarButtonItemStylePlain target:self action:@selector(sendImage)];
    }
    else {
        self.navigationItem.rightBarButtonItem = Nil;
    }
}

-(void) sendImage {
    if (delegate && imageView.image) {
        [delegate sendImage:imageView.image];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    
    // Scale the image to fit on the screen
    float imageAR = image.size.width/image.size.height;
    float screenAR = self.view.fw/self.view.fh;
    
    CGSize imageSize = CGSizeMake(self.view.fw, self.view.fh - self.navigationController.navigationBar.fh - [UIApplication sharedApplication].statusBarFrame.size.height);
    // We're going to scale the image to the screen height
    if (imageAR > screenAR) {
        imageSize.width = imageSize.height * imageAR;
    }
    // We're going to scale the image to the screen width
    else {
        imageSize.height = imageSize.width / imageAR;
    }
    
    UIGraphicsBeginImageContext(imageSize);
    [image drawInRect:CGRectMake(0 , 0, imageSize.width, imageSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [imageView setImage:newImage];
    
    [self updateImageSize];
    //imageView.keepHeight.equal = KeepRequired(imageView.fw / newImage.size.width * newImage.size.height);
    
    [picker dismissViewControllerAnimated:YES completion:Nil];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:^{
        [self.navigationController popViewControllerAnimated:NO];
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(void) updateImageSize {
    if (!imageView.image) {
        return;
    }
    
    // Find which is the constraining dimension
    float imageAR = imageView.image.size.width / imageView.image.size.height;
    float screenAR = self.view.fw / self.view.fh;
    
    // Height limiting
    float imageHeight;
    float imageWidth;

    // Width is the limiting dimension
    if (imageAR > screenAR) {
        imageWidth = self.view.fw * 0.8;
        imageHeight = imageWidth / imageAR;
    }
    else {
        imageHeight = self.view.fh * 0.8;
        imageWidth = imageHeight * imageAR;
    }
    
    NSLog(@"View: %@", NSStringFromCGRect(self.view.frame));
    
    imageView.keepWidth.equal = imageWidth;
    imageView.keepHeight.equal = imageHeight;
}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

-(void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateImageSize];
    [self.view layoutSubviews];
}

@end
