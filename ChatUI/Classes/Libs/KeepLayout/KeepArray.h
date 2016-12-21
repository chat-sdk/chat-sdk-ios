//
//  KeepArray.h
//  Keep Layout
//
//  Created by Martin Kiss on 23.6.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "KeepTypes.h"
#import "KeepView.h"

@class KeepAttribute;





/**
 Provides similar methods than KPView. Works only on arrays of UIViews/NSViews. For method descriptions see method in KeepView.h with the same name.
 
 Most of the methods invokes the same selector on contained views and returns group proxy attribute. Setting values of this group will set attributes to all attributes in the group.
 
 In addition, for every relative attribute there is convenience method, that applies on views in the array in the order.
 **/
@interface NSArray (KeepLayout)





#pragma mark -
#pragma mark Dimensions: Grouped

/// Grouped attribute for Width of contained views.
@property (nonatomic, readonly) KeepAttribute *keepWidth;

/// Grouped attribute for Height of contained views.
@property (nonatomic, readonly) KeepAttribute *keepHeight;

/// Grouped attribute for Size (Width + Height) of contained views.
@property (nonatomic, readonly) KeepAttribute *keepSize;

/// Grouped attribute for Aspect Ratio of contained views.
@property (nonatomic, readonly) KeepAttribute *keepAspectRatio;

/// Grouped attribute for Relative Width of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepWidthTo;

/// Grouped attribute for Relative Height of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepHeightTo;

/// Grouped attribute for Relative Size of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepSizeTo;



#pragma mark Dimensions: Forwarded

/// Forwards to contained views.
- (void)keepSize:(CGSize)size priority:(KeepPriority)priority;

/// Forwards to contained views. Use is discouraged.
- (void)keepSize:(CGSize)size;



#pragma mark Dimensions: Batch Convenience
/// Convenience methods applied to whole array, in the order they are in array.

/// All contained views will share the same Width using given priority. Width of the first is tied to Width of the second and so on.
- (void)keepWidthsEqualWithPriority:(KeepPriority)priority;

/// All contained views will share the same Width using Required priority. Use is discouraged. Width of the first is tied to Width of the second and so on.
- (void)keepWidthsEqual;

/// All contained views will share the same Width using given priority. Height of the first is tied to Height of the second and so on.
- (void)keepHeightsEqualWithPriority:(KeepPriority)priority;

/// All contained views will share the same Height using Required priority. Use is discouraged. Height of the first is tied to Height of the second and so on.
- (void)keepHeightsEqual;

/// All contained views will share the same Size (Width + Height) using given priority. Width of the first is tied to Width of the second and so on.
- (void)keepSizesEqualWithPriority:(KeepPriority)priority;

/// All contained views will share the same Size using Required priority. Use is discouraged. Size of the first is tied to Size of the second and so on.
- (void)keepSizesEqual;





#pragma mark -
#pragma mark Superview Insets: Grouped

/// Grouped attribute for Left Inset of contained views.
@property (nonatomic, readonly) KeepAttribute *keepLeftInset;

/// Grouped attribute for Right Inset of contained views.
@property (nonatomic, readonly) KeepAttribute *keepRightInset;

/// Grouped attribute for Leading Inset of contained views.
@property (nonatomic, readonly) KeepAttribute *keepLeadingInset;

/// Grouped attribute for Trailing Inset of contained views.
@property (nonatomic, readonly) KeepAttribute *keepTrailingInset;

/// Grouped attribute for Top Inset of contained views.
@property (nonatomic, readonly) KeepAttribute *keepTopInset;

/// Grouped attribute for Bottom Inset of contained views.
@property (nonatomic, readonly) KeepAttribute *keepBottomInset;

/// Grouped attribute for All Insets of contained views.
@property (nonatomic, readonly) KeepAttribute *keepInsets;

/// Grouped attribute for Horizontal Insets of contained views.
@property (nonatomic, readonly) KeepAttribute *keepHorizontalInsets;

/// Grouped attribute for Vertical Insets of contained views.
@property (nonatomic, readonly) KeepAttribute *keepVerticalInsets;



#pragma mark Superview Insets: Forwarded

/// Forwards to contained views.
- (void)keepInsets:(KPEdgeInsets)insets priority:(KeepPriority)priority;

/// Forwards to contained views. Use is discouraged.
- (void)keepInsets:(KPEdgeInsets)insets;





#pragma mark -
#pragma mark Superview Margin Insets: Grouped

/// Grouped attribute for Left Margin Inset of contained views.
@property (nonatomic, readonly) KeepAttribute *keepLeftMarginInset;

/// Grouped attribute for Right Margin Inset of contained views.
@property (nonatomic, readonly) KeepAttribute *keepRightMarginInset;

/// Grouped attribute for Leading Margin Inset of contained views.
@property (nonatomic, readonly) KeepAttribute *keepLeadingMarginInset;

/// Grouped attribute for Trailing Margin Inset of contained views.
@property (nonatomic, readonly) KeepAttribute *keepTrailingMarginInset;

/// Grouped attribute for Top Margin Inset of contained views.
@property (nonatomic, readonly) KeepAttribute *keepTopMarginInset;

/// Grouped attribute for Bottom Margin Inset of contained views.
@property (nonatomic, readonly) KeepAttribute *keepBottomMarginInset;

/// Grouped attribute for All Margin Insets of contained views.
@property (nonatomic, readonly) KeepAttribute *keepMarginInsets;

/// Grouped attribute for Horizontal Margin Insets of contained views.
@property (nonatomic, readonly) KeepAttribute *keepHorizontalMarginInsets;

/// Grouped attribute for Vertical Margin Insets of contained views.
@property (nonatomic, readonly) KeepAttribute *keepVerticalMarginInsets;



#pragma mark Superview Margin Insets: Forwarded

/// Forwards to contained views.
- (void)keepMarginInsets:(KPEdgeInsets)insets priority:(KeepPriority)priority;

/// Forwards to contained views. Use is discouraged.
- (void)keepMarginInsets:(KPEdgeInsets)insets;





#pragma mark -
#pragma mark Center: Grouped

/// Grouped attribute for Horizontal Center of contained views.
@property (nonatomic, readonly) KeepAttribute *keepHorizontalCenter;

/// Grouped attribute for Vertical Center of contained views.
@property (nonatomic, readonly) KeepAttribute *keepVerticalCenter;

/// Grouped attribute for Both Center Axis of contained views.
@property (nonatomic, readonly) KeepAttribute *keepCenter;



#pragma mark Center: Forwarded

/// Forwards to contained views.
- (void)keepCenteredWithPriority:(KeepPriority)priority;

/// Forwards to contained views. Use is discouraged.
- (void)keepCentered;

/// Forwards to contained views.
- (void)keepHorizontallyCenteredWithPriority:(KeepPriority)priority;

/// Forwards to contained views. Use is discouraged.
- (void)keepHorizontallyCentered;

/// Forwards to contained views.
- (void)keepVerticallyCenteredWithPriority:(KeepPriority)priority;

/// Forwards to contained views. Use is discouraged.
- (void)keepVerticallyCentered;

/// Forwards to contained views.
- (void)keepCenter:(CGPoint)center priority:(KeepPriority)priority;

/// Forwards to contained views. Use is discouraged.
- (void)keepCenter:(CGPoint)center;





#pragma mark -
#pragma mark Offsets: Grouped

/// Grouped attribute for Left Offset of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepLeftOffsetTo;

/// Grouped attribute for Right Offset of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepRightOffsetTo;

/// Grouped attribute for Leading Offset of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepLeadingOffsetTo;

/// Grouped attribute for Trailing Offset of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepTrailingOffsetTo;

/// Grouped attribute for Top Offset of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepTopOffsetTo;

/// Grouped attribute for Bottom Offset of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepBottomOffsetTo;



#pragma mark Offsets: Batch Convenience
/// Convenience methods applied to whole array, in the order they are in array.

/// All contained views will share the same Horizontal Offset (left to right) using given priority. First view will keep Right Offset to second view and so on.
- (void)keepHorizontalOffsets:(KeepValue)value;

/// All contained views will share the same Leading Offset (depends on writing direction) using given priority. First view will keep Leading Offset to second view and so on.
- (void)keepLeadingOffsets:(KeepValue)value;

/// All contained views will share the same Vertical Offset (top to bottom) using given priority. First view will keep Bottom Offset to second view and so on.
- (void)keepVerticalOffsets:(KeepValue)value;





#pragma mark -
#pragma mark Alignments: Grouped

/// Grouped attribute for Left Alignment of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepLeftAlignTo;

/// Grouped attribute for Right Alignment of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepRightAlignTo;

/// Grouped attribute for Leading Alignment of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepLeadingAlignTo;

/// Grouped attribute for Trailing Alignment of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepTrailingAlignTo;

/// Grouped attribute for Top Alignment of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepTopAlignTo;

/// Grouped attribute for Bottom Alignment of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepBottomAlignTo;

/// Grouped attribute for All 4 Edge Alignments of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepEdgeAlignTo;

/// Grouped attribute for Vertical Center Alignment of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepVerticalAlignTo;

/// Grouped attribute for Horizontal Center Alignment of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepHorizontalAlignTo;

/// Grouped attribute for Both Center Axis Alignment of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepCenterAlignTo;

/// Grouped attribute for Baseline Alignment of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepBaselineAlignTo __deprecated_msg("You should use .keepFirstBaselineAlignTo or .keepLastBaselineAlignTo");

/// Grouped attribute for First Baseline Alignment of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepFirstBaselineAlignTo;

/// Grouped attribute for Last Baseline Alignment of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepLastBaselineAlignTo;


#pragma mark Alignments: Batch Convenience
/// Convenience methods applied to whole array, in the order they are in array.

/// All contained views will share the same Left Alignment. First view will keep Left Alignment (with offset) with second view and so on.
- (void)keepLeftAlignments:(KeepValue)value;

/// All contained views will be aligned to the left. First view will keep Left Alignment with second view and so on.
- (void)keepLeftAligned;

/// All contained views will share the same Right Alignment. First view will keep Right Alignment (with offset) with second view and so on.
- (void)keepRightAlignments:(KeepValue)value;

/// All contained views will be aligned to the right. First view will keep Right Alignment with second view and so on.
- (void)keepRightAligned;

/// All contained views will share the same Leading Alignment. First view will keep Leading Alignment (with offset) with second view and so on.
- (void)keepLeadingAlignments:(KeepValue)value;

/// All contained views will be aligned to the leading side. First view will keep Leading Alignment with second view and so on.
- (void)keepLeadingAligned;

/// All contained views will share the same Trailing Alignment. First view will keep Trailing Alignment (with offset) with second view and so on.
- (void)keepTrailingAlignments:(KeepValue)value;

/// All contained views will be aligned to the trailing side. First view will keep Trailing Alignment with second view and so on.
- (void)keepTrailingAligned;

/// All contained views will share the same Top Alignment. First view will keep Top Alignment (with offset) with second view and so on.
- (void)keepTopAlignments:(KeepValue)value;

/// All contained views will be aligned to the top. First view will keep Top Alignment with second view and so on.
- (void)keepTopAligned;

/// All contained views will share the same Bottom Alignment. First view will keep Bottom Alignment (with offset) with second view and so on.
- (void)keepBottomAlignments:(KeepValue)value;

/// All contained views will be aligned to the bottom. First view will keep Bottom Alignment with second view and so on.
- (void)keepBottomAligned;

/// All contained views will share the same Vertical Center Alignment. First view will keep Vertical Center Alignment (with offset) with second view and so on.
- (void)keepVerticalAlignments:(KeepValue)value;

/// All contained views will vertically aligned. First view will keep Vertical Center Alignment with second view and so on.
- (void)keepVerticallyAligned;

/// All contained views will share the same Horizontal Center Alignment. First view will keep Horizontal Center Alignment (with offset) with second view and so on.
- (void)keepHorizontalAlignments:(KeepValue)value;

/// All contained views will horizontally aligned. First view will keep Horizontal Center Alignment with second view and so on.
- (void)keepHorizontallyAligned;

/// All contained views will share the same Baseline Alignment. First view will keep Baseline Alignment (with offset) with second view and so on.
- (void)keepBaselineAlignments:(KeepValue)value __deprecated_msg("You should use -keepFirstBaselineAlignments: or -keepLastBaselineAlignments:");

/// All contained views will be baseline aligned. First view will keep Baseline Alignment with second view and so on.
- (void)keepBaselineAligned __deprecated_msg("You should use -keepFirstBaselineAligned or -keepLastBaselineAligned");

/// All contained views will share the same First Baseline Alignment. First view will keep First Baseline Alignment (with offset) with second view and so on.
- (void)keepFirstBaselineAlignments:(KeepValue)value;

/// All contained views will be aligned to their first baseline. First view will keep First Baseline Alignment with second view and so on.
- (void)keepFirstBaselineAligned;

/// All contained views will share the same Last Baseline Alignment. First view will keep Last Baseline Alignment (with offset) with second view and so on.
- (void)keepLastBaselineAlignments:(KeepValue)value;

/// All contained views will aligned to their last baseline. First view will keep Last Baseline Alignment with second view and so on.
- (void)keepLastBaselineAligned;





@end
