//
//  KeepView.m
//  Keep Layout
//
//  Created by Martin Kiss on 21.10.12.
//  Copyright (c) 2012 iMartin Kiss. All rights reserved.
//

#import "KeepView.h"
#import "KeepAttribute.h"
#import "KeepLayoutConstraint.h"
#import <objc/runtime.h>





@implementation KPView (KeepLayout)





#pragma mark Associations


- (KeepAttribute *)keep_selfAttributeForSelector:(SEL)selector creationBlock:(KeepAttribute *(^)(void))creationBlock {
    KeepParameterAssert(selector);
    KeepParameterAssert(creationBlock);
    
    KeepAttribute *attribute = objc_getAssociatedObject(self, selector);
    
    if ( ! attribute) {
        attribute = creationBlock();
        objc_setAssociatedObject(self, selector, attribute, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return attribute;
}


- (KeepAttribute *)keep_superviewAttributeForSelector:(SEL)selector creationBlock:(KeepAttribute *(^)(void))creationBlock {
    KeepParameterAssert(selector);
    KeepParameterAssert(creationBlock);
    
    KeepAttribute *attribute = objc_getAssociatedObject(self, selector);
    
    if (attribute && ! [attribute isRelatedToView:self.superview]) {
        [attribute deactivate];
        attribute = nil;
    }
    if ( ! attribute) {
        attribute = creationBlock();
        objc_setAssociatedObject(self, selector, attribute, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return attribute;
}


- (KeepAttribute *)keep_relatedAttributeForSelector:(SEL)selector toView:(KPView *)relatedView creationBlock:(KeepAttribute *(^)(void))creationBlock {
    KeepParameterAssert(selector);
    KeepParameterAssert(relatedView);
    
    NSMapTable *attributesByRelatedView = objc_getAssociatedObject(self, selector);
    if ( ! attributesByRelatedView) {
        attributesByRelatedView = [NSMapTable weakToStrongObjectsMapTable];
        objc_setAssociatedObject(self, selector, attributesByRelatedView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    KeepAttribute *attribute = [attributesByRelatedView objectForKey:relatedView];
    if ( ! attribute && creationBlock) {
        attribute = creationBlock();
        [attributesByRelatedView setObject:attribute forKey:relatedView];
    }
    return attribute;
}


- (void)keep_clearAttribute:(SEL)selector {
    KeepParameterAssert(selector);
    
    KeepAttribute *attribute = objc_getAssociatedObject(self, selector);
    [attribute deactivate];
    
    objc_setAssociatedObject(self, selector, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}





#pragma mark Dimensions


- (KeepAttribute *)keep_dimensionForSelector:(SEL)selector dimensionAttribute:(NSLayoutAttribute)dimensionAttribute name:(NSString *)name {
    KeepParameterAssert(selector);
    KeepParameterAssert(dimensionAttribute == NSLayoutAttributeWidth
                        || dimensionAttribute == NSLayoutAttributeHeight);
    KeepParameterAssert(name);
    
    return [self keep_selfAttributeForSelector:selector creationBlock:^KeepAttribute *{
        KeepAttribute *attribute = [[[KeepConstantAttribute alloc] initWithView:self
                                                                layoutAttribute:dimensionAttribute
                                                                    relatedView:nil
                                                         relatedLayoutAttribute:NSLayoutAttributeNotAnAttribute
                                                                    coefficient:1]
                                    name:@"%@ of <%@ %p>", name, self.class, self];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        return attribute;
    }];
}


- (KeepAttribute *)keep_dimensionForSelector:(SEL)selector dimensionAttribute:(NSLayoutAttribute)dimensionAttribute relatedView:(KPView *)relatedView name:(NSString *)name {
    KeepParameterAssert(selector);
    KeepParameterAssert(dimensionAttribute == NSLayoutAttributeWidth
                        || dimensionAttribute == NSLayoutAttributeHeight);
    KeepParameterAssert(relatedView);
    KeepParameterAssert(name);
    
    return [self keep_relatedAttributeForSelector:selector toView:relatedView creationBlock:^KeepAttribute *{
        KeepAttribute *attribute = [[KeepMultiplierAttribute alloc] initWithView:self
                                                                 layoutAttribute:dimensionAttribute
                                                                     relatedView:relatedView
                                                          relatedLayoutAttribute:dimensionAttribute
                                                                     coefficient:1];
        [attribute name:@"%@ of <%@ %p> to <%@ %p>", name, self.class, self, relatedView.class, relatedView];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        relatedView.translatesAutoresizingMaskIntoConstraints = NO;
        // Establish inverse relation
        [relatedView keep_relatedAttributeForSelector:_cmd toView:self creationBlock:^KeepAttribute *{
            return attribute;
        }];
        return attribute;
    }];
}


- (KeepAttribute *)keepWidth {
    return [self keep_dimensionForSelector:_cmd dimensionAttribute:NSLayoutAttributeWidth name:@"width"];
}


- (KeepAttribute *)keepHeight {
    return [self keep_dimensionForSelector:_cmd dimensionAttribute:NSLayoutAttributeHeight name:@"height"];
}


- (KeepAttribute *)keepSize {
    return [[KeepAttribute group:
            self.keepWidth,
            self.keepHeight,
            nil] name:@"size of <%@ %p>", self.class, self];
}


- (void)keepSize:(CGSize)size {
    [self keepSize:size priority:KeepPriorityRequired];
}


- (void)keepSize:(CGSize)size priority:(KeepPriority)priority {
    self.keepWidth.equal = KeepValueMake(size.width, priority);
    self.keepHeight.equal = KeepValueMake(size.height, priority);
}


- (KeepAttribute *)keepAspectRatio {
    return [self keep_selfAttributeForSelector:_cmd creationBlock:^KeepAttribute *{
        KeepAttribute *attribute = [[KeepMultiplierAttribute alloc] initWithView:self
                                                                 layoutAttribute:NSLayoutAttributeWidth
                                                                     relatedView:self
                                                          relatedLayoutAttribute:NSLayoutAttributeHeight
                                                                     coefficient:1];
        [attribute name:@"aspect ratio of <%@ %p>", self.class, self];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        return attribute;
    }];
}


- (KeepRelatedAttributeBlock)keepWidthTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_dimensionForSelector:_cmd dimensionAttribute:NSLayoutAttributeWidth relatedView:view name:@"width"];
    };
}


- (KeepRelatedAttributeBlock)keepHeightTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_dimensionForSelector:_cmd dimensionAttribute:NSLayoutAttributeHeight relatedView:view name:@"height"];
    };
}


- (KeepRelatedAttributeBlock)keepSizeTo {
    return ^KeepAttribute *(KPView *view) {
        return [[KeepAttribute group:
                 self.keepWidthTo(view),
                 self.keepHeightTo(view),
                 nil] name:@"size of <%@ %p> to <%@ %p>", self.class, self, view.class, view];
    };
}





#pragma mark Supreview Insets


- (KeepAttribute *)keep_insetForSelector:(SEL)selector useSafe:(BOOL)useSafeInsets edgeAttribute:(NSLayoutAttribute)edgeAttribute coefficient:(CGFloat)coefficient name:(NSString *)name {
    KeepParameterAssert(selector);
    KeepParameterAssert(   edgeAttribute == NSLayoutAttributeLeft
                        || edgeAttribute == NSLayoutAttributeRight
                        || edgeAttribute == NSLayoutAttributeTop
                        || edgeAttribute == NSLayoutAttributeBottom
                        || edgeAttribute == NSLayoutAttributeLeading
                        || edgeAttribute == NSLayoutAttributeTrailing
                        || edgeAttribute == NSLayoutAttributeLeftMargin
                        || edgeAttribute == NSLayoutAttributeRightMargin
                        || edgeAttribute == NSLayoutAttributeTopMargin
                        || edgeAttribute == NSLayoutAttributeBottomMargin
                        || edgeAttribute == NSLayoutAttributeLeadingMargin
                        || edgeAttribute == NSLayoutAttributeTrailingMargin
                        || edgeAttribute == NSLayoutAttributeFirstBaseline
                        || edgeAttribute == NSLayoutAttributeLastBaseline
                        );
    KeepParameterAssert(name);
    KeepAssert(self.superview, @"Calling %@ allowed only when superview exists", NSStringFromSelector(selector));
    
    return [self keep_superviewAttributeForSelector:selector creationBlock:^KeepAttribute *{
        NSDictionary<NSNumber *, NSNumber *> *nonMarginAttributes = @{
            @(NSLayoutAttributeLeftMargin): @(NSLayoutAttributeLeft),
            @(NSLayoutAttributeRightMargin): @(NSLayoutAttributeRight),
            @(NSLayoutAttributeTopMargin): @(NSLayoutAttributeTop),
            @(NSLayoutAttributeBottomMargin): @(NSLayoutAttributeBottom),
            @(NSLayoutAttributeLeadingMargin): @(NSLayoutAttributeLeading),
            @(NSLayoutAttributeTrailingMargin): @(NSLayoutAttributeTrailing),
        };
        NSDictionary<NSNumber *, NSNumber *> *nonBaselineAttributes = @{
            @(NSLayoutAttributeFirstBaseline): @(NSLayoutAttributeTop),
            @(NSLayoutAttributeLastBaseline): @(NSLayoutAttributeBottom),
        };
        NSLayoutAttribute superviewEdgeAttribute = [[nonBaselineAttributes objectForKey:@(edgeAttribute)] integerValue] ?: edgeAttribute;
        NSLayoutAttribute selfEdgeAttribute = [[nonMarginAttributes objectForKey:@(edgeAttribute)] integerValue] ?: edgeAttribute;
        
        id<KeepViewOrGuide> related = self.superview;
        if (useSafeInsets) {
            if (@available(iOS 11, *)) {
                related = self.superview.safeAreaLayoutGuide;
            }
        }
        
        KeepAttribute *attribute = [[[KeepConstantAttribute alloc] initWithView:self
                                                                layoutAttribute:selfEdgeAttribute
                                                                    relatedView:related
                                                         relatedLayoutAttribute:superviewEdgeAttribute
                                                                    coefficient:coefficient]
                                    name:@"%@ of <%@ %p> to superview <%@ %p>", name, self.class, self, self.superview.class, self.superview];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        return attribute;
    }];
}


- (KeepAttribute *)keepLeftInset {
    return [self keep_insetForSelector:_cmd useSafe:NO edgeAttribute:NSLayoutAttributeLeft coefficient:1 name:@"left inset"];
}


- (KeepAttribute *)keepRightInset {
    return [self keep_insetForSelector:_cmd useSafe:NO edgeAttribute:NSLayoutAttributeRight coefficient:-1 name:@"right inset"];
}


- (KeepAttribute *)keepLeadingInset {
    return [self keep_insetForSelector:_cmd useSafe:NO edgeAttribute:NSLayoutAttributeLeading coefficient:1 name:@"leading inset"];
}


- (KeepAttribute *)keepTrailingInset {
    return [self keep_insetForSelector:_cmd useSafe:NO edgeAttribute:NSLayoutAttributeTrailing coefficient:-1 name:@"trailing inset"];
}


- (KeepAttribute *)keepTopInset {
    return [self keep_insetForSelector:_cmd useSafe:NO edgeAttribute:NSLayoutAttributeTop coefficient:1 name:@"top inset"];
}


- (KeepAttribute *)keepBottomInset {
    return [self keep_insetForSelector:_cmd useSafe:NO edgeAttribute:NSLayoutAttributeBottom coefficient:-1 name:@"bottom inset"];
}


- (KeepAttribute *)keepFirstBaselineInset {
    return [self keep_insetForSelector:_cmd useSafe:NO edgeAttribute:NSLayoutAttributeFirstBaseline coefficient:1 name:@"first baseline inset"];
}


- (KeepAttribute *)keepLastBaselineInset {
    return [self keep_insetForSelector:_cmd useSafe:NO edgeAttribute:NSLayoutAttributeLastBaseline coefficient:-1 name:@"last baseline inset"];
}


- (KeepAttribute *)keepInsets {
    return [[[KeepGroupAttribute alloc] initWithAttributes:@[
             self.keepTopInset,
             self.keepBottomInset,
             self.keepLeftInset,
             self.keepRightInset ]]
            name:@"all insets of <%@ %p> to superview <%@ %p>", self.class, self, self.superview.class, self.superview];
}


- (KeepAttribute *)keepHorizontalInsets {
    return [[[KeepGroupAttribute alloc] initWithAttributes:@[
             self.keepLeftInset,
             self.keepRightInset ]]
            name:@"horizontal insets of <%@ %p> to superview <%@ %p>", self.class, self, self.superview.class, self.superview];
}


- (KeepAttribute *)keepVerticalInsets {
    return [[[KeepGroupAttribute alloc] initWithAttributes:@[
             self.keepTopInset,
             self.keepBottomInset ]]
            name:@"vertical insets of <%@ %p> to superview <%@ %p>", self.class, self, self.superview.class, self.superview];
}


- (void)keepInsets:(KPEdgeInsets)insets {
    [self keepInsets:insets priority:KeepPriorityRequired];
}


- (void)keepInsets:(KPEdgeInsets)insets priority:(KeepPriority)priority {
    self.keepLeftInset.equal = KeepValueMake(insets.left, priority);
    self.keepRightInset.equal = KeepValueMake(insets.right, priority);
    self.keepTopInset.equal = KeepValueMake(insets.top, priority);
    self.keepBottomInset.equal = KeepValueMake(insets.bottom, priority);
}





#pragma mark Superview Safe Insets


- (KeepAttribute *)keepLeftSafeInset {
    return [self keep_insetForSelector:_cmd useSafe:YES edgeAttribute:NSLayoutAttributeLeft coefficient:1 name:@"left safe inset"];
}


- (KeepAttribute *)keepRightSafeInset {
    return [self keep_insetForSelector:_cmd useSafe:YES edgeAttribute:NSLayoutAttributeRight coefficient:-1 name:@"right safe inset"];
}


- (KeepAttribute *)keepLeadingSafeInset {
    return [self keep_insetForSelector:_cmd useSafe:YES edgeAttribute:NSLayoutAttributeLeading coefficient:1 name:@"leading safe inset"];
}


- (KeepAttribute *)keepTrailingSafeInset {
    return [self keep_insetForSelector:_cmd useSafe:YES edgeAttribute:NSLayoutAttributeTrailing coefficient:-1 name:@"trailing safe inset"];
}


- (KeepAttribute *)keepTopSafeInset {
    return [self keep_insetForSelector:_cmd useSafe:YES edgeAttribute:NSLayoutAttributeTop coefficient:1 name:@"top safe inset"];
}


- (KeepAttribute *)keepBottomSafeInset {
    return [self keep_insetForSelector:_cmd useSafe:YES edgeAttribute:NSLayoutAttributeBottom coefficient:-1 name:@"bottom safe inset"];
}


- (KeepAttribute *)keepSafeInsets {
    return [[[KeepGroupAttribute alloc] initWithAttributes:@[
                                                             self.keepTopSafeInset,
                                                             self.keepBottomSafeInset,
                                                             self.keepLeftSafeInset,
                                                             self.keepRightSafeInset ]]
            name:@"all safe insets of <%@ %p> to superview <%@ %p>", self.class, self, self.superview.class, self.superview];
}


- (KeepAttribute *)keepHorizontalSafeInsets {
    return [[[KeepGroupAttribute alloc] initWithAttributes:@[
                                                             self.keepLeftSafeInset,
                                                             self.keepRightSafeInset ]]
            name:@"horizontal safe insets of <%@ %p> to superview <%@ %p>", self.class, self, self.superview.class, self.superview];
}


- (KeepAttribute *)keepVerticalSafeInsets {
    return [[[KeepGroupAttribute alloc] initWithAttributes:@[
                                                             self.keepTopSafeInset,
                                                             self.keepBottomSafeInset ]]
            name:@"vertical safe insets of <%@ %p> to superview <%@ %p>", self.class, self, self.superview.class, self.superview];
}


- (void)keepSafeInsets:(KPEdgeInsets)insets {
    [self keepSafeInsets:insets priority:KeepPriorityRequired];
}


- (void)keepSafeInsets:(KPEdgeInsets)insets priority:(KeepPriority)priority {
    self.keepLeftSafeInset.equal = KeepValueMake(insets.left, priority);
    self.keepRightSafeInset.equal = KeepValueMake(insets.right, priority);
    self.keepTopSafeInset.equal = KeepValueMake(insets.top, priority);
    self.keepBottomSafeInset.equal = KeepValueMake(insets.bottom, priority);
}





#pragma mark Superview Margin Insets


- (KeepAttribute *)keepLeftMarginInset {
    return [self keep_insetForSelector:_cmd useSafe:NO edgeAttribute:NSLayoutAttributeLeftMargin coefficient:1 name:@"left margin inset"];
}


- (KeepAttribute *)keepRightMarginInset {
    return [self keep_insetForSelector:_cmd useSafe:NO edgeAttribute:NSLayoutAttributeRightMargin coefficient:-1 name:@"right margin inset"];
}


- (KeepAttribute *)keepLeadingMarginInset {
    return [self keep_insetForSelector:_cmd useSafe:NO edgeAttribute:NSLayoutAttributeLeadingMargin coefficient:1 name:@"leading margin inset"];
}


- (KeepAttribute *)keepTrailingMarginInset {
    return [self keep_insetForSelector:_cmd useSafe:NO edgeAttribute:NSLayoutAttributeTrailingMargin coefficient:-1 name:@"trailing margin inset"];
}


- (KeepAttribute *)keepTopMarginInset {
    return [self keep_insetForSelector:_cmd useSafe:NO edgeAttribute:NSLayoutAttributeTopMargin coefficient:1 name:@"top margin inset"];
}


- (KeepAttribute *)keepBottomMarginInset {
    return [self keep_insetForSelector:_cmd useSafe:NO edgeAttribute:NSLayoutAttributeBottomMargin coefficient:-1 name:@"bottom margin inset"];
}


- (KeepAttribute *)keepMarginInsets {
    return [[[KeepGroupAttribute alloc] initWithAttributes:@[
                                                             self.keepTopMarginInset,
                                                             self.keepBottomMarginInset,
                                                             self.keepLeftMarginInset,
                                                             self.keepRightMarginInset ]]
            name:@"all margin insets of <%@ %p> to superview <%@ %p>", self.class, self, self.superview.class, self.superview];
}


- (KeepAttribute *)keepHorizontalMarginInsets {
    return [[[KeepGroupAttribute alloc] initWithAttributes:@[
                                                             self.keepLeftMarginInset,
                                                             self.keepRightMarginInset ]]
            name:@"horizontal margin insets of <%@ %p> to superview <%@ %p>", self.class, self, self.superview.class, self.superview];
}


- (KeepAttribute *)keepVerticalMarginInsets {
    return [[[KeepGroupAttribute alloc] initWithAttributes:@[
                                                             self.keepTopMarginInset,
                                                             self.keepBottomMarginInset ]]
            name:@"vertical margin insets of <%@ %p> to superview <%@ %p>", self.class, self, self.superview.class, self.superview];
}


- (void)keepMarginInsets:(KPEdgeInsets)insets {
    [self keepMarginInsets:insets priority:KeepPriorityRequired];
}


- (void)keepMarginInsets:(KPEdgeInsets)insets priority:(KeepPriority)priority {
    self.keepLeftMarginInset.equal = KeepValueMake(insets.left, priority);
    self.keepRightMarginInset.equal = KeepValueMake(insets.right, priority);
    self.keepTopMarginInset.equal = KeepValueMake(insets.top, priority);
    self.keepBottomMarginInset.equal = KeepValueMake(insets.bottom, priority);
}





#pragma mark Center


- (KeepAttribute *)keep_centerForSelector:(SEL)selector centerAttribute:(NSLayoutAttribute)centerAttribute name:(NSString *)name {
    KeepParameterAssert(selector);
    KeepParameterAssert(centerAttribute == NSLayoutAttributeCenterX
                        || centerAttribute == NSLayoutAttributeCenterY);
    KeepParameterAssert(name);
    KeepAssert(self.superview, @"Calling %@ allowed only when superview exists", NSStringFromSelector(selector));
    
    return [self keep_superviewAttributeForSelector:selector creationBlock:^KeepAttribute *{
        KeepAttribute *attribute = [[[KeepMultiplierAttribute alloc] initWithView:self
                                                                  layoutAttribute:centerAttribute
                                                                      relatedView:self.superview
                                                           relatedLayoutAttribute:centerAttribute
                                                                      coefficient:2]
                                    name:@"%@ of <%@ %p> in superview <%@ %p>", name, self.class, self, self.superview.class, self.superview];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        return attribute;
    }];
}


- (KeepAttribute *)keepHorizontalCenter {
    return [self keep_centerForSelector:_cmd centerAttribute:NSLayoutAttributeCenterX name:@"horizontal center"];
}


- (KeepAttribute *)keepVerticalCenter {
    return [self keep_centerForSelector:_cmd centerAttribute:NSLayoutAttributeCenterY name:@"vertical center"];
}


- (KeepAttribute *)keepCenter {
    return [[[KeepGroupAttribute alloc] initWithAttributes:@[
             self.keepHorizontalCenter,
             self.keepVerticalCenter ]]
            name:@"center of <%@ %p> in superview <%@ %p>", self.class, self, self.superview.class, self.superview];
}


- (void)keepCentered {
    [self keepCenteredWithPriority:KeepPriorityRequired];
}


- (void)keepCenteredWithPriority:(KeepPriority)priority {
    [self keepCenter:CGPointMake(0.5, 0.5) priority:priority];
}


- (void)keepHorizontallyCentered {
    [self keepHorizontallyCenteredWithPriority:KeepPriorityRequired];
}


- (void)keepHorizontallyCenteredWithPriority:(KeepPriority)priority {
    self.keepHorizontalCenter.equal = KeepValueMake(0.5, priority);
}


- (void)keepVerticallyCentered {
    [self keepVerticallyCenteredWithPriority:KeepPriorityRequired];
}


- (void)keepVerticallyCenteredWithPriority:(KeepPriority)priority {
    self.keepVerticalCenter.equal = KeepValueMake(0.5, priority);
}


- (void)keepCenter:(CGPoint)center {
    [self keepCenter:center priority:KeepPriorityRequired];
}


- (void)keepCenter:(CGPoint)center priority:(KeepPriority)priority {
    self.keepHorizontalCenter.equal = KeepValueMake(center.x, priority);
    self.keepVerticalCenter.equal = KeepValueMake(center.y, priority);
}





#pragma mark Offsets


- (KeepAttribute *)keep_offsetForSelector:(SEL)selector edgeAttribute:(NSLayoutAttribute)edgeAttribute relatedView:(KPView *)relatedView name:(NSString *)name {
    KeepParameterAssert(selector);
    KeepParameterAssert(   edgeAttribute == NSLayoutAttributeLeft
                        || edgeAttribute == NSLayoutAttributeRight
                        || edgeAttribute == NSLayoutAttributeTop
                        || edgeAttribute == NSLayoutAttributeBottom
                        || edgeAttribute == NSLayoutAttributeLeading
                        || edgeAttribute == NSLayoutAttributeTrailing
                        || edgeAttribute == NSLayoutAttributeFirstBaseline
                        || edgeAttribute == NSLayoutAttributeLastBaseline);
    KeepParameterAssert(relatedView);
    KeepParameterAssert(name);
    
    return [self keep_relatedAttributeForSelector:selector toView:relatedView creationBlock:^KeepAttribute *{
        NSDictionary<NSNumber *, NSNumber *> *oppositeEdges = @{
            @(NSLayoutAttributeLeft): @(NSLayoutAttributeRight),
            @(NSLayoutAttributeRight): @(NSLayoutAttributeLeft),
            @(NSLayoutAttributeTop): @(NSLayoutAttributeBottom),
            @(NSLayoutAttributeBottom): @(NSLayoutAttributeTop),
            @(NSLayoutAttributeLeading): @(NSLayoutAttributeTrailing),
            @(NSLayoutAttributeTrailing): @(NSLayoutAttributeLeading),
            @(NSLayoutAttributeFirstBaseline): @(NSLayoutAttributeLastBaseline),
            @(NSLayoutAttributeLastBaseline): @(NSLayoutAttributeFirstBaseline),
        };
        KeepAttribute *attribute =  [[[KeepConstantAttribute alloc] initWithView:self
                                                                 layoutAttribute:edgeAttribute
                                                                     relatedView:relatedView
                                                          relatedLayoutAttribute:[[oppositeEdges objectForKey:@(edgeAttribute)] integerValue]
                                                                     coefficient:1]
                                     name:@"%@ of <%@ %p> to <%@ %p>", name, self.class, self, relatedView.class, relatedView];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        relatedView.translatesAutoresizingMaskIntoConstraints = NO;
        return attribute;
    }];
}


- (KeepRelatedAttributeBlock)keepLeftOffsetTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_offsetForSelector:_cmd edgeAttribute:NSLayoutAttributeLeft relatedView:view name:@"left offset"];
    };
}


- (KeepRelatedAttributeBlock)keepRightOffsetTo {
    return ^KeepAttribute *(KPView *view) {
        return view.keepLeftOffsetTo(self);
    };
}


- (KeepRelatedAttributeBlock)keepLeadingOffsetTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_offsetForSelector:_cmd edgeAttribute:NSLayoutAttributeLeading relatedView:view name:@"leading offset"];
    };
}


- (KeepRelatedAttributeBlock)keepTrailingOffsetTo {
    return ^KeepAttribute *(KPView *view) {
        return view.keepLeadingOffsetTo(self);
    };
}


- (KeepRelatedAttributeBlock)keepTopOffsetTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_offsetForSelector:_cmd edgeAttribute:NSLayoutAttributeTop relatedView:view name:@"top offset"];
    };
}


- (KeepRelatedAttributeBlock)keepBottomOffsetTo {
    return ^KeepAttribute *(KPView *view) {
        return view.keepTopOffsetTo(self);
    };
}


- (KeepRelatedAttributeBlock)keepFirstBaselineOffsetTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_offsetForSelector:_cmd edgeAttribute:NSLayoutAttributeFirstBaseline relatedView:view name:@"first baseline offset"];
    };
}


- (KeepRelatedAttributeBlock)keepLastBaselineOffsetTo {
    return ^KeepAttribute *(KPView *view) {
        return view.keepFirstBaselineOffsetTo(self);
    };
}





#pragma mark Alignments


- (KeepAttribute *)keep_alignForSelector:(SEL)selector alignAttribute:(NSLayoutAttribute)alignAttribute relatedView:(KPView *)relatedView coefficient:(CGFloat)coefficient name:(NSString *)name {
    KeepParameterAssert(selector);
    KeepParameterAssert(alignAttribute == NSLayoutAttributeLeft
                        || alignAttribute == NSLayoutAttributeRight
                        || alignAttribute == NSLayoutAttributeTop
                        || alignAttribute == NSLayoutAttributeBottom
                        || alignAttribute == NSLayoutAttributeLeading
                        || alignAttribute == NSLayoutAttributeTrailing
                        || alignAttribute == NSLayoutAttributeCenterX
                        || alignAttribute == NSLayoutAttributeBaseline
                        || alignAttribute == NSLayoutAttributeFirstBaseline
                        || alignAttribute == NSLayoutAttributeLastBaseline
                        || alignAttribute == NSLayoutAttributeCenterY);
    KeepParameterAssert(relatedView);
    KeepParameterAssert(name);
    
    return [self keep_relatedAttributeForSelector:selector toView:relatedView creationBlock:^KeepAttribute *{
        KeepAttribute *attribute =  [[[KeepConstantAttribute alloc] initWithView:self
                                                                 layoutAttribute:alignAttribute
                                                                     relatedView:relatedView
                                                          relatedLayoutAttribute:alignAttribute
                                                                     coefficient:coefficient]
                                     name:@"%@ of <%@ %p> to <%@ %p>", name, self.class, self, relatedView.class, relatedView];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        relatedView.translatesAutoresizingMaskIntoConstraints = NO;
        // Establish inverse attribute
        [relatedView keep_relatedAttributeForSelector:selector toView:self creationBlock:^KeepAttribute *{
            return attribute;
        }];
        return attribute;
    }];
}


- (KeepRelatedAttributeBlock)keepLeftAlignTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeLeft relatedView:view coefficient:1 name:@"left alignment"];
    };
}


- (KeepRelatedAttributeBlock)keepRightAlignTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeRight relatedView:view coefficient:-1 name:@"right alignment"];
    };
}


- (KeepRelatedAttributeBlock)keepLeadingAlignTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeLeading relatedView:view coefficient:1 name:@"leading alignment"];
    };
}


- (KeepRelatedAttributeBlock)keepTrailingAlignTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeTrailing relatedView:view coefficient:-1 name:@"trailing alignment"];
    };
}


- (KeepRelatedAttributeBlock)keepTopAlignTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeTop relatedView:view coefficient:1 name:@"top alignment"];
    };
}


- (KeepRelatedAttributeBlock)keepBottomAlignTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeBottom relatedView:view coefficient:-1 name:@"bottom alignment"];
    };
}


- (KeepRelatedAttributeBlock)keepEdgeAlignTo {
    return ^KeepAttribute *(KPView *view) {
        return [KeepAttribute group:
                self.keepTopAlignTo(view),
                self.keepLeftAlignTo(view),
                self.keepRightAlignTo(view),
                self.keepBottomAlignTo(view),
                nil];
    };
}


- (KeepRelatedAttributeBlock)keepCenterAlignTo {
    return ^KeepAttribute *(KPView *view) {
        return [KeepAttribute group:
                self.keepVerticalAlignTo(view),
                self.keepHorizontalAlignTo(view),
                nil];
    };
}


- (KeepRelatedAttributeBlock)keepVerticalAlignTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeCenterX relatedView:view coefficient:1 name:@"vertical center alignment"];
    };
}


- (KeepRelatedAttributeBlock)keepHorizontalAlignTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeCenterY relatedView:view coefficient:1 name:@"horizontal center alignment"];
    };
}


- (KeepRelatedAttributeBlock)keepFirstBaselineAlignTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeFirstBaseline relatedView:view coefficient:-1 name:@"first baseline alignment"];
    };
}


- (KeepRelatedAttributeBlock)keepLastBaselineAlignTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeLastBaseline relatedView:view coefficient:-1 name:@"last baseline alignment"];
    };
}





#pragma mark Compression & Hugging Convenience


- (KeepPriority)keepCompressionResistance {
    return MIN(self.keepHorizontalCompressionResistance, self.keepVerticalCompressionResistance);
}


- (void)setKeepCompressionResistance:(KeepPriority)priority {
    self.keepHorizontalCompressionResistance = priority;
    self.keepVerticalCompressionResistance = priority;
}


- (KeepPriority)keepHorizontalCompressionResistance {
#if TARGET_OS_IOS
    return [self contentCompressionResistancePriorityForAxis:UILayoutConstraintAxisHorizontal];
#else
    return [self contentCompressionResistancePriorityForOrientation:NSLayoutConstraintOrientationHorizontal];
#endif
}


- (void)setKeepHorizontalCompressionResistance:(KeepPriority)priority {
#if TARGET_OS_IOS
    [self setContentCompressionResistancePriority:priority forAxis:UILayoutConstraintAxisHorizontal];
#else
    [self setContentCompressionResistancePriority:priority forOrientation:NSLayoutConstraintOrientationHorizontal];
#endif
}


- (KeepPriority)keepVerticalCompressionResistance {
#if TARGET_OS_IOS
    return [self contentCompressionResistancePriorityForAxis:UILayoutConstraintAxisVertical];
#else
    return [self contentCompressionResistancePriorityForOrientation:NSLayoutConstraintOrientationVertical];
#endif
}


- (void)setKeepVerticalCompressionResistance:(KeepPriority)priority {
#if TARGET_OS_IOS
    [self setContentCompressionResistancePriority:priority forAxis:UILayoutConstraintAxisVertical];
#else
    [self setContentCompressionResistancePriority:priority forOrientation:NSLayoutConstraintOrientationVertical];
#endif
}


- (KeepPriority)keepHuggingPriority {
    return MIN(self.keepHorizontalHuggingPriority, self.keepVerticalHuggingPriority);
}


- (void)setKeepHuggingPriority:(KeepPriority)priority {
    self.keepHorizontalHuggingPriority = priority;
    self.keepVerticalHuggingPriority = priority;
}


- (KeepPriority)keepHorizontalHuggingPriority {
#if TARGET_OS_IOS
    return [self contentHuggingPriorityForAxis:UILayoutConstraintAxisHorizontal];
#else
    return [self contentHuggingPriorityForOrientation:NSLayoutConstraintOrientationHorizontal];
#endif
}


- (void)setKeepHorizontalHuggingPriority:(KeepPriority)priority {
#if TARGET_OS_IOS
    [self setContentHuggingPriority:priority forAxis:UILayoutConstraintAxisHorizontal];
#else
    [self setContentHuggingPriority:priority forOrientation:NSLayoutConstraintOrientationHorizontal];
#endif
}


- (KeepPriority)keepVerticalHuggingPriority {
#if TARGET_OS_IOS
    return [self contentHuggingPriorityForAxis:UILayoutConstraintAxisVertical];
#else
    return [self contentHuggingPriorityForOrientation:NSLayoutConstraintOrientationVertical];
#endif
}


- (void)setKeepVerticalHuggingPriority:(KeepPriority)priority {
#if TARGET_OS_IOS
    [self setContentHuggingPriority:priority forAxis:UILayoutConstraintAxisVertical];
#else
    [self setContentHuggingPriority:priority forOrientation:NSLayoutConstraintOrientationVertical];
#endif
}





#pragma mark Animating Constraints
#if TARGET_OS_IOS


- (void)keepAnimatedWithDuration:(NSTimeInterval)duration layout:(void(^)(void))animations {
    KeepParameterAssert(duration >= 0);
    KeepParameterAssert(animations);
    
    [self keep_animationPerformWithDuration:duration delay:0 block:^{
        [UIView animateWithDuration:duration
                         animations:^{
                             animations();
                             [self layoutIfNeeded];
                         }];
    }];
}


- (void)keepAnimatedWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay layout:(void(^)(void))animations {
    KeepParameterAssert(duration >= 0);
    KeepParameterAssert(delay >= 0);
    KeepParameterAssert(animations);
    
    [self keep_animationPerformWithDuration:duration delay:delay block:^{
        [UIView animateWithDuration:duration
                         animations:^{
                             animations();
                             [self layoutIfNeeded];
                         }];
    }];
}


- (void)keepAnimatedWithDuration:(NSTimeInterval)duration layout:(void (^)(void))animations completion:(void (^)(BOOL))completion {
    KeepParameterAssert(duration >= 0);
    KeepParameterAssert(animations);
    
    [self keep_animationPerformWithDuration:duration delay:0 block:^{
        [UIView animateWithDuration:duration
                         animations:^{
                             animations();
                             [self layoutIfNeeded];
                         }
                         completion:completion];
    }];
}


- (void)keepAnimatedWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options layout:(void(^)(void))animations completion:(void(^)(BOOL finished))completion {
    KeepParameterAssert(duration >= 0);
    KeepParameterAssert(delay >= 0);
    KeepParameterAssert(animations);
    
    [self keep_animationPerformWithDuration:duration delay:delay block:^{
        [UIView animateWithDuration:duration
                              delay:0
                            options:options
                         animations:^{
                             animations();
                             [self layoutIfNeeded];
                         }
                         completion:completion];
    }];
}


- (void)keepAnimatedWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options layout:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
    KeepParameterAssert(duration >= 0);
    KeepParameterAssert(delay >= 0);
    KeepParameterAssert(animations);
    
    [self keep_animationPerformWithDuration:duration delay:delay block:^{
        [UIView animateWithDuration:duration
                              delay:0
             usingSpringWithDamping:dampingRatio
              initialSpringVelocity:velocity
                            options:options
                         animations:^{
                             animations();
                             [self layoutIfNeeded];
                         }
                         completion:completion];
    }];
}


- (void)keep_animationPerformWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay block:(void(^)(void))block {
    if (duration > 0 || delay > 0) {
        [[NSOperationQueue mainQueue] performSelector:@selector(addOperationWithBlock:)
                                           withObject:block
                                           afterDelay:delay
                                              inModes:@[NSRunLoopCommonModes]];
    }
    else {
        block();
    }
}


- (void)keepNotAnimated:(void (^)(void))layout {
    [UIView performWithoutAnimation:^{
        layout();
        [self layoutIfNeeded];
    }];
}

#endif // TARGET_OS_IOS





@end
