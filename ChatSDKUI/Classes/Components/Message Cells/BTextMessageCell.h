//
//  BTextMessageCell.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 26/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMessageDelegate.h"
#import "BMessageCell.h"

@class BMessage;

@interface BTextMessageCell : BMessageCell {
}

@property (nonatomic, readwrite) UITextView * textView;

+(float) getText: (NSString *) text heightWithWidth: (float) width;
+(float) getText: (NSString *) text heightWithFont: (UIFont *) font withWidth: (float) width;
+(float) maxTextWidth: (id<PElmMessage>) message;
+(float) textWidth: (NSString *) text maxWidth: (float) maxWidth;

@end
