//
//  BStickerMessageCell.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 21/10/2016.
//
//

#import <UIKit/UIKit.h>
#import <ChatSDK/BMessageCell.h>

@class FLAnimatedImageView;

#define bStickerMessageCell @"StickerMessageCell"

@interface BStickerMessageCell : BMessageCell

@property (nonatomic, readwrite) FLAnimatedImageView * stickerView;

@end
