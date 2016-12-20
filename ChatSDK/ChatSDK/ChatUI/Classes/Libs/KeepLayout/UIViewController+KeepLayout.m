//
//  UIViewController+KeepLayout.m
//  Keep Layout
//
//  Created by Martin Kiss on 4.6.14.
//  Copyright (c) 2014 Martin Kiss. All rights reserved.
//

#import <objc/runtime.h>
#import "UIViewController+KeepLayout.h"
#import "KeepLayoutConstraint.h"
#import "KeepView.h"
#import "KeepAttribute.h"





@interface KeepLayoutGuidesView : UIView @end





@implementation UIViewController (KeepLayout)



- (UIView *)keepLayoutView {
    UIView *layoutView = objc_getAssociatedObject(self, _cmd);
    if (layoutView) return layoutView;
    
    layoutView = [KeepLayoutGuidesView new];
    layoutView.hidden = YES;
    layoutView.userInteractionEnabled = NO;
    layoutView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:layoutView atIndex:0];
    
    layoutView.keepHorizontalMarginInsets.equal = 0;
    
    KeepLayoutConstraint *topAlign = [KeepLayoutConstraint constraintWithItem:layoutView
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.topLayoutGuide
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1
                                                                     constant:0];
    [topAlign name:@"align top of <%@ %p> to top layout guide of <%@ %p>", layoutView.class, layoutView, self.class, self];
    KeepLayoutConstraint *bottomAlign = [KeepLayoutConstraint constraintWithItem:layoutView
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.bottomLayoutGuide
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1
                                                                        constant:0];
    [bottomAlign name:@"align bottom of <%@ %p> to bottom layout guide of <%@ %p>", layoutView.class, layoutView, self.class, self];
    
    [self.view addConstraints:@[ topAlign, bottomAlign ]];
    
    objc_setAssociatedObject(self, _cmd, layoutView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return layoutView;
}



@end





@implementation KeepLayoutGuidesView


- (void)addSubview:(UIView *)view {
    KeepAssert(NO, @"This is special view that doesn't support adding subviews. Get over it.");
    [super addSubview:view];
}


- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index {
    KeepAssert(NO, @"This is special view that doesn't support adding subviews. Get over it.");
    [super addSubview:view];
}


@end


