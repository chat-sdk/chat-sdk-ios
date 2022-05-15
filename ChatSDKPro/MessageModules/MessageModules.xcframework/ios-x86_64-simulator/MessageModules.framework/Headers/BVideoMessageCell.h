//
//  BVideoMessageCell.h
//  Chat SDK
//
//  Created by Simon Smiley-Andrews on 16/07/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import <ChatSDK/BMessageCell.h>

#define bVideoMessageCell @"VideoMessageCell"

@interface BVideoMessageCell : BMessageCell

@property (nonatomic, readwrite) UIImageView * coverImageView;

@end
