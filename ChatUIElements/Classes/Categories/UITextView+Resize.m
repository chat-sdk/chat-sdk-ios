//
//  UITextView+Resize.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 04/03/2015.
//  Copyright (c) 2015 chatsdk.co All rights reserved. The Chat SDK is issued under the MIT liceense and is available for free at http://github.com/chat-sdk
//

#import "UITextView+Resize.h"

@implementation UITextView (Resize)

-(float) heightToFitText {
    CGFloat fixedWidth = self.frame.size.width;
    CGSize newSize = [self sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    return newSize.height;
}

@end
