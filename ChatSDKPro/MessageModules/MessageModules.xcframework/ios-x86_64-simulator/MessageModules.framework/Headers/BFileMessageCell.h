//
//  BFileMessageCell.h
//  ChatSDKModules
//
//  Created by Pepe Becker on 19.04.18.
//

#import <UIKit/UIKit.h>
#import <ChatSDK/BMessageCell.h>

#define bFileMessageCell @"FileMessageCell"

@class BCoreUtilities;
@class BFileCache;

@interface BFileMessageCell : BMessageCell

@property (nonatomic, readwrite) UIView * cellView;
@property (nonatomic, readwrite) UIImageView * imageView;
@property (nonatomic, readwrite) UILabel * textLabel;

@end
