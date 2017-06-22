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

@interface BSystemMessageCell : BMessageCell {
}

@property (nonatomic, readwrite) UITextView * textView;

@end
