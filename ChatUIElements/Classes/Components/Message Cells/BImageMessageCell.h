//
//  BImageMessageCell.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 26/09/2013.
//  Copyright (c) 2013 chatsdk.co All rights reserved. The Chat SDK is issued under the MIT liceense and is available for free at http://github.com/chat-sdk
//

#import <UIKit/UIKit.h>
#import "BMessageCell.h"

#define bImageMessageCell @"ImageMessageCell"

@interface BImageMessageCell : BMessageCell<BMessageDelegate>

@property (nonatomic, readwrite) UIImageView * imageView;

@end
