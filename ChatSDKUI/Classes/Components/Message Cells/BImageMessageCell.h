//
//  BImageMessageCell.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 26/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMessageCell.h"

@interface BImageMessageCell : BMessageCell<BMessageDelegate>

@property (nonatomic, readwrite) UIImageView * imageView;

@end
