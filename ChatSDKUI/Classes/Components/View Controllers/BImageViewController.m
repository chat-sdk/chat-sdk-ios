//
//  BImageViewController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 16/04/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "BImageViewController.h"
#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

@interface BImageViewController ()

@end

@implementation BImageViewController

@synthesize imageView;
@synthesize image;

-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"BImageViewController" bundle:[NSBundle uiBundle]];
    if (self) {
        self.title = [NSBundle t:bImageMessage];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle t: bBack] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle t: bSave] style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    _swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownDetected)];
    _swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:_swipeRecognizer];
}

-(void) swipeDownDetected {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [imageView setImage:image];
    
    // We want to make sure the image always fits in the screen
    // Check the ratio of the height and width against the screens ratio, use this to determine the height and width set
    double screenRatio = [[UIScreen mainScreen] bounds].size.height / [[UIScreen mainScreen] bounds].size.width;
    double imageRatio = image.size.height / image.size.width;
    
    CGRect screenSize = [UIScreen mainScreen].applicationFrame;
    
    // Make sure the status bar and navigation bar don't overlap our view
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (screenRatio >= imageRatio) {
        
        // We want the image to be the size of the screen - the user can then zoom in more from there
        imageView.keepWidth.equal = screenSize.size.width;
        imageView.keepHeight.equal = screenSize.size.width * imageRatio;
        
        // Make sure the image is in the middle of the screen
        imageView.keepVerticalCenter.equal = 0.5;
    }
    else {
        
        // We want the image to be the size of the screen - the user can then zoom in more from there
        // We need to find the visible screen heigh otherwise the status bar changes the calculations
        CGFloat visibleScreenHeight = screenSize.size.height - screenSize.origin.y;
        
        imageView.keepHeight.equal = visibleScreenHeight;
        imageView.keepWidth.equal = visibleScreenHeight / imageRatio;
        
        // Make sure the image is in the middle of the screen
        imageView.keepHorizontalCenter.equal = 0.5;
    }
    
    // Make sure the image fits into the image view exactly
    imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;
}

-(void) backButtonPressed {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

-(void) save {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), Nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo  {
    if (error) {
        [self.view makeToast:error.localizedDescription];
    }
    else {
        [self.view makeToast:[NSBundle t:bSuccess]];
    }
}

@end
