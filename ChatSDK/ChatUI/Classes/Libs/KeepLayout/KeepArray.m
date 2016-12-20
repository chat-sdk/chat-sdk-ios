//
//  KeepArray.m
//  Keep Layout
//
//  Created by Martin Kiss on 23.6.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "KeepArray.h"
#import "KeepAttribute.h"
#import "KeepView.h"





@implementation NSArray (KeepLayout)





#pragma mark General


- (BOOL)keep_onlyContainsViews {
    for (KPView *view in self) {
        if ( ! [view isKindOfClass:[KPView class]]) {
            return NO;
        }
    }
    return YES;
}


- (KeepGroupAttribute *)keep_groupAttributeForSelector:(SEL)selector {
    KeepAssert([self keep_onlyContainsViews], @"%@ can only be called on array of View objects", NSStringFromSelector(selector));
    
    return [[KeepGroupAttribute alloc] initWithAttributes:[self valueForKeyPath:NSStringFromSelector(selector)]];
}


- (KeepGroupAttribute *)keep_groupAttributeForSelector:(SEL)selector relatedView:(KPView *)relatedView {
    KeepAssert([self keep_onlyContainsViews], @"%@ can only be called on array of View objects", NSStringFromSelector(selector));
    
    NSMutableArray *builder = [[NSMutableArray alloc] initWithCapacity:self.count];
    for (KPView *view in self) {
        KeepAttribute *(^block)(KPView *) = [view valueForKeyPath:NSStringFromSelector(selector)];
        [builder addObject:block(relatedView)];
    }
    return [[KeepGroupAttribute alloc] initWithAttributes:builder];
}


- (void)keep_invoke:(SEL)selector each:(void(^)(KPView *view))block {
    KeepAssert([self keep_onlyContainsViews], @"%@ can only be called on array of View objects", NSStringFromSelector(selector));
    
    for (KPView *view in self) {
        block(view);
    }
}


- (void)keep_invoke:(SEL)selector eachTwo:(void(^)(KPView *this, KPView *next))block {
    KeepAssert([self keep_onlyContainsViews], @"%@ can only be called on array of View objects", NSStringFromSelector(selector));
    
    if (self.count < 2) return;
    
    for (NSUInteger index = 0; index < self.count - 1; index++) {
        KPView *this = [self objectAtIndex:index];
        KPView *next = [self objectAtIndex:index + 1];
        block(this, next);
    }
}





#pragma mark Dimensions


- (KeepAttribute *)keepWidth {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepHeight {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepSize {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (void)keepSize:(CGSize)size {
    [self keep_invoke:_cmd each:^(KPView *view) {
        [view keepSize:size];
    }];
}


- (void)keepSize:(CGSize)size priority:(KeepPriority)priority {
    [self keep_invoke:_cmd each:^(KPView *view) {
        [view keepSize:size priority:priority];
    }];
}


- (KeepAttribute *)keepAspectRatio {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepRelatedAttributeBlock)keepWidthTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepHeightTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepSizeTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (void)keepWidthsEqualWithPriority:(KeepPriority)priority {
    [self keep_invoke:_cmd eachTwo:^(KPView *this, KPView *next) {
        this.keepWidthTo(next).equal = KeepValueMake(1, priority);
    }];
}


- (void)keepHeightsEqualWithPriority:(KeepPriority)priority {
    [self keep_invoke:_cmd eachTwo:^(KPView *this, KPView *next) {
        this.keepHeightTo(next).equal = KeepValueMake(1, priority);
    }];
}


- (void)keepSizesEqualWithPriority:(KeepPriority)priority {
    [self keep_invoke:_cmd eachTwo:^(KPView *this, KPView *next) {
        this.keepSizeTo(next).equal = KeepValueMake(1, priority);
    }];
}


- (void)keepWidthsEqual {
    [self keepWidthsEqualWithPriority:KeepPriorityRequired];
}


- (void)keepHeightsEqual {
    [self keepHeightsEqualWithPriority:KeepPriorityRequired];
}


- (void)keepSizesEqual {
    [self keepSizesEqualWithPriority:KeepPriorityRequired];
}





#pragma mark Superview Insets


- (KeepAttribute *)keepLeftInset {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepRightInset {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepLeadingInset {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepTrailingInset {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepTopInset {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepBottomInset {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepInsets {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepHorizontalInsets {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepVerticalInsets {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (void)keepInsets:(KPEdgeInsets)insets priority:(KeepPriority)priority {
    [self keep_invoke:_cmd each:^(KPView *view) {
        [view keepInsets:insets priority:priority];
    }];
}


- (void)keepInsets:(KPEdgeInsets)insets {
    [self keepInsets:insets priority:KeepPriorityRequired];
}





#pragma mark Superview Margin Insets


- (KeepAttribute *)keepLeftMarginInset {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepRightMarginInset {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepLeadingMarginInset {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepTrailingMarginInset {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepTopMarginInset {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepBottomMarginInset {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepMarginInsets {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepHorizontalMarginInsets {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepVerticalMarginInsets {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (void)keepMarginInsets:(KPEdgeInsets)insets priority:(KeepPriority)priority {
    [self keep_invoke:_cmd each:^(KPView *view) {
        [view keepMarginInsets:insets priority:priority];
    }];
}


- (void)keepMarginInsets:(KPEdgeInsets)insets {
    [self keepMarginInsets:insets priority:KeepPriorityRequired];
}





#pragma mark Center

- (KeepAttribute *)keepHorizontalCenter {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepVerticalCenter {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepCenter {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (void)keepCenteredWithPriority:(KeepPriority)priority {
    [self keep_invoke:_cmd each:^(KPView *view) {
        [view keepCenteredWithPriority:priority];
    }];
}


- (void)keepHorizontallyCenteredWithPriority:(KeepPriority)priority {
    [self keep_invoke:_cmd each:^(KPView *view) {
        [view keepHorizontallyCenteredWithPriority:priority];
    }];
}


- (void)keepVerticallyCenteredWithPriority:(KeepPriority)priority {
    [self keep_invoke:_cmd each:^(KPView *view) {
        [view keepVerticallyCenteredWithPriority:priority];
    }];
}


- (void)keepCenter:(CGPoint)center priority:(KeepPriority)priority {
    [self keep_invoke:_cmd each:^(KPView *view) {
        [view keepCenter:center priority:priority];
    }];
}


- (void)keepCentered {
    [self keepCenteredWithPriority:KeepPriorityRequired];
}


- (void)keepHorizontallyCentered {
    [self keepHorizontallyCenteredWithPriority:KeepPriorityRequired];
}


- (void)keepVerticallyCentered {
    [self keepVerticallyCenteredWithPriority:KeepPriorityRequired];
}


- (void)keepCenter:(CGPoint)center {
    [self keepCenter:center priority:KeepPriorityRequired];
}





#pragma mark Offsets


- (KeepRelatedAttributeBlock)keepLeftOffsetTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepRightOffsetTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepLeadingOffsetTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepTrailingOffsetTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepTopOffsetTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepBottomOffsetTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (void)keepHorizontalOffsets:(KeepValue)value {
    [self keep_invoke:_cmd eachTwo:^(KPView *this, KPView *next) {
        this.keepRightOffsetTo(next).equal = value;
    }];
}


- (void)keepLeadingOffsets:(KeepValue)value {
    [self keep_invoke:_cmd eachTwo:^(KPView *this, KPView *next) {
        this.keepTrailingOffsetTo(next).equal = value;
    }];
}


- (void)keepVerticalOffsets:(KeepValue)value {
    [self keep_invoke:_cmd eachTwo:^(KPView *this, KPView *next) {
        this.keepBottomOffsetTo(next).equal = value;
    }];
}





#pragma mark Alignments


- (KeepRelatedAttributeBlock)keepLeftAlignTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepRightAlignTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepLeadingAlignTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepTrailingAlignTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepTopAlignTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepBottomAlignTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepEdgeAlignTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepVerticalAlignTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepHorizontalAlignTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepCenterAlignTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepBaselineAlignTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepFirstBaselineAlignTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepLastBaselineAlignTo {
    return ^KeepAttribute *(KPView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (void)keep_alignedSelector:(SEL)selector invokeSelector:(SEL)invokeSelector value:(KeepValue)value {
    [self keep_invoke:selector eachTwo:^(KPView *this, KPView *next) {
        KeepAttribute *(^block)(KPView *) = [this valueForKey:NSStringFromSelector(invokeSelector)];
        KeepAttribute *attribute = block(next);
        attribute.equal = value;
    }];
}


- (void)keepLeftAlignments:(KeepValue)value {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepLeftAlignTo) value:value];
}


- (void)keepRightAlignments:(KeepValue)value {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepRightAlignTo) value:value];
}


- (void)keepLeadingAlignments:(KeepValue)value {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepLeadingAlignTo) value:value];
}


- (void)keepTrailingAlignments:(KeepValue)value {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepTrailingAlignTo) value:value];
}


- (void)keepTopAlignments:(KeepValue)value {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepTopAlignTo) value:value];
}


- (void)keepBottomAlignments:(KeepValue)value {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepBottomAlignTo) value:value];
}


- (void)keepVerticalAlignments:(KeepValue)value {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepVerticalAlignTo) value:value];
}


- (void)keepHorizontalAlignments:(KeepValue)value {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepHorizontalAlignTo) value:value];
}


- (void)keepBaselineAlignments:(KeepValue)value {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepBaselineAlignTo) value:value];
}


- (void)keepFirstBaselineAlignments:(KeepValue)value {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepFirstBaselineAlignTo) value:value];
}


- (void)keepLastBaselineAlignments:(KeepValue)value {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepLastBaselineAlignTo) value:value];
}


- (void)keepLeftAligned {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepLeftAlignTo) value:0];
}


- (void)keepRightAligned {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepRightAlignTo) value:0];
}


- (void)keepLeadingAligned {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepLeadingAlignTo) value:0];
}


- (void)keepTrailingAligned {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepTrailingAlignTo) value:0];
}


- (void)keepTopAligned {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepTopAlignTo) value:0];
}


- (void)keepBottomAligned {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepBottomAlignTo) value:0];
}


- (void)keepVerticallyAligned {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepVerticalAlignTo) value:0];
}


- (void)keepHorizontallyAligned {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepHorizontalAlignTo) value:0];
}


- (void)keepBaselineAligned {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepBaselineAlignTo) value:0];
}


- (void)keepFirstBaselineAligned {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepFirstBaselineAlignTo) value:0];
}


- (void)keepLastBaselineAligned {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepLastBaselineAlignTo) value:0];
}





@end
