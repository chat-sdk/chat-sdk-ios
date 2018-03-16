//
//  BImageViewController.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 16/04/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BImageViewController : UIViewController<UIScrollViewDelegate> {
    UISwipeGestureRecognizer * _swipeRecognizer;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, readwrite) UIImage * image;

@end
