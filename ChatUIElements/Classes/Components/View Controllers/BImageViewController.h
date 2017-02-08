//
//  BImageViewController.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 16/04/2014.
//  Copyright (c) 2014 chatsdk.co All rights reserved. The Chat SDK is issued under the MIT liceense and is available for free at http://github.com/chat-sdk
//

#import <UIKit/UIKit.h>

@interface BImageViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, readwrite) UIImage * image;

@end
