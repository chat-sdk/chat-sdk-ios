//
//  UIScrollView+KeepLayout.m
//  Keep Layout
//
//  Created by Martin Kiss on 13.11.14.
//  Copyright (c) 2014 Martin Kiss. All rights reserved.
//

#import <objc/runtime.h>
#import "UIScrollView+KeepLayout.h"
#import "KeepView.h"
#import "KeepAttribute.h"





@interface KeepScrollDisablingView : UIView

@end





@implementation UIScrollView (KeepLayout)



- (UIView *)keepScrollDisablingView {
    UIView *disablingView = objc_getAssociatedObject(self, _cmd);
    if ( ! disablingView) {
        disablingView = [KeepScrollDisablingView new];
        disablingView.hidden = YES;
        disablingView.userInteractionEnabled = NO;
        disablingView.backgroundColor = [UIColor clearColor];
        [self insertSubview:disablingView atIndex:0];
        
        disablingView.keepInsets.equal = 0;
    }
    return disablingView;
}


- (BOOL)keepHorizontalScrollDisabled {
    UIView *disablingView = [self keepScrollDisablingView];
    KeepValue value = disablingView.keepWidthTo(self).equal;
    return ! KeepValueIsNone(value);
}


- (void)keepHorizontalScrollDisabled:(BOOL)disabled {
    UIView *disablingView = [self keepScrollDisablingView];
    disablingView.keepWidthTo(self).equal = (disabled? 1 : KeepNone);
}


- (BOOL)keepVerticalScrollDisabled {
    UIView *disablingView = [self keepScrollDisablingView];
    KeepValue value = disablingView.keepHeightTo(self).equal;
    return ! KeepValueIsNone(value);
}


- (void)keepVerticalScrollDisabled:(BOOL)disabled {
    UIView *disablingView = [self keepScrollDisablingView];
    disablingView.keepHeightTo(self).equal = (disabled? 1 : KeepNone);
}



@end





@implementation KeepScrollDisablingView


- (void)addSubview:(UIView *)view {
    KeepAssert(NO, @"This is special view that doesn't support adding subviews. Get over it.");
    [super addSubview:view];
}


- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index {
    KeepAssert(NO, @"This is special view that doesn't support adding subviews. Get over it.");
    [super addSubview:view];
}


@end


