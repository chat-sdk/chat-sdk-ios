//
//  UITextView+Resize.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 04/03/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import "UITextView+Resize.h"

@implementation UITextView (Resize)

-(float) heightToFitText {
    CGFloat fixedWidth = self.frame.size.width;
    CGSize newSize = [self sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    return newSize.height;
}

@end
