//
//  BImageViewController.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 16/04/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChatSDK/PImageViewController.h>

@interface BImageViewController : UIViewController<UIScrollViewDelegate, PImageViewController> {
    UISwipeGestureRecognizer * _swipeRecognizer;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, readwrite) UIImage * image;
@property (nonatomic, readwrite) NSURL * imageURL;
@property (nonatomic, readwrite) BOOL hideSaveButton;
@property (nonatomic, readwrite) UIActivityIndicatorView * activityIndicator;

-(void) downloadImage;
-(void) downloadComplete: (UIImage *) image;

@end
