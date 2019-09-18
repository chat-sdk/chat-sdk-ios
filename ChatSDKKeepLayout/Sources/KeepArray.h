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
@property (readonly) KeepAttribute *keepWidth;

/// Grouped attribute for Height of contained views.
@property (readonly) KeepAttribute *keepHeight;

/// Grouped attribute for Size (Width + Height) of contained views.
@property (readonly) KeepAttribute *keepSize;

/// Grouped attribute for Aspect Ratio of contained views.
@property (readonly) KeepAttribute *keepAspectRatio;

/// Grouped attribute for Relative Width of contained views.
@property (readonly) KeepRelatedAttributeBlock keepWidthTo;

/// Grouped attribute for Relative Height of contained views.
@property (readonly) KeepRelatedAttributeBlock keepHeightTo;

/// Grouped attribute for Relative Size of contained views.
@property (readonly) KeepRelatedAttributeBlock keepSizeTo;



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
@property (readonly) KeepAttribute *keepLeftInset;

/// Grouped attribute for Right Inset of contained views.
@property (readonly) KeepAttribute *keepRightInset;

/// Grouped attribute for Leading Inset of contained views.
@property (readonly) KeepAttribute *keepLeadingInset;

/// Grouped attribute for Trailing Inset of contained views.
@property (readonly) KeepAttribute *keepTrailingInset;

/// Grouped attribute for Top Inset of contained views.
@property (readonly) KeepAttribute *keepTopInset;

/// Grouped attribute for Bottom Inset of contained views.
@property (readonly) KeepAttribute *keepBottomInset;

/// Grouped attribute for First Baseline Inset of contained views.
@property (nonatomic, readonly) KeepAttribute *keepFirstBaselineInset;

/// Grouped attribute for Last Baseline Inset of contained views.
@property (nonatomic, readonly) KeepAttribute *keepLastBaselineInset;

/// Grouped attribute for All Insets of contained views.
@property (readonly) KeepAttribute *keepInsets;

/// Grouped attribute for Horizontal Insets of contained views.
@property (readonly) KeepAttribute *keepHorizontalInsets;

/// Grouped attribute for Vertical Insets of contained views.
@property (readonly) KeepAttribute *keepVerticalInsets;



#pragma mark Superview Insets: Forwarded

/// Forwards to contained views.
- (void)keepInsets:(KPEdgeInsets)insets priority:(KeepPriority)priority;

/// Forwards to contained views. Use is discouraged.
- (void)keepInsets:(KPEdgeInsets)insets;





#pragma mark -
#pragma mark Superview Safe Insets: Grouped

/// Grouped attribute for Left Safe Inset of contained views.
@property (readonly) KeepAttribute *keepLeftSafeInset API_AVAILABLE(ios(11));

/// Grouped attribute for Right Safe Inset of contained views.
@property (readonly) KeepAttribute *keepRightSafeInset API_AVAILABLE(ios(11));

/// Grouped attribute for Leading Safe Inset of contained views.
@property (readonly) KeepAttribute *keepLeadingSafeInset API_AVAILABLE(ios(11));

/// Grouped attribute for Trailing Safe Inset of contained views.
@property (readonly) KeepAttribute *keepTrailingSafeInset API_AVAILABLE(ios(11));

/// Grouped attribute for Top Safe Inset of contained views.
@property (readonly) KeepAttribute *keepTopSafeInset API_AVAILABLE(ios(11));

/// Grouped attribute for Bottom Safe Inset of contained views.
@property (readonly) KeepAttribute *keepBottomSafeInset API_AVAILABLE(ios(11));

/// Grouped attribute for All Safe Insets of contained views.
@property (readonly) KeepAttribute *keepSafeInsets API_AVAILABLE(ios(11));

/// Grouped attribute for Horizontal Safe Insets of contained views.
@property (readonly) KeepAttribute *keepHorizontalSafeInsets API_AVAILABLE(ios(11));

/// Grouped attribute for Vertical Safe Insets of contained views.
@property (readonly) KeepAttribute *keepVerticalSafeInsets API_AVAILABLE(ios(11));



#pragma mark Superview Safe Insets: Forwarded

/// Forwards to contained views.
- (void)keepSafeInsets:(KPEdgeInsets)insets priority:(KeepPriority)priority API_AVAILABLE(ios(11));

/// Forwards to contained views. Use is discouraged.
- (void)keepSafeInsets:(KPEdgeInsets)insets API_AVAILABLE(ios(11));





#pragma mark -
#pragma mark Superview Margin Insets: Grouped

/// Grouped attribute for Left Margin Inset of contained views.
@property (readonly) KeepAttribute *keepLeftMarginInset;

/// Grouped attribute for Right Margin Inset of contained views.
@property (readonly) KeepAttribute *keepRightMarginInset;

/// Grouped attribute for Leading Margin Inset of contained views.
@property (readonly) KeepAttribute *keepLeadingMarginInset;

/// Grouped attribute for Trailing Margin Inset of contained views.
@property (readonly) KeepAttribute *keepTrailingMarginInset;

/// Grouped attribute for Top Margin Inset of contained views.
@property (readonly) KeepAttribute *keepTopMarginInset;

/// Grouped attribute for Bottom Margin Inset of contained views.
@property (readonly) KeepAttribute *keepBottomMarginInset;

/// Grouped attribute for All Margin Insets of contained views.
@property (readonly) KeepAttribute *keepMarginInsets;

/// Grouped attribute for Horizontal Margin Insets of contained views.
@property (readonly) KeepAttribute *keepHorizontalMarginInsets;

/// Grouped attribute for Vertical Margin Insets of contained views.
@property (readonly) KeepAttribute *keepVerticalMarginInsets;



#pragma mark Superview Margin Insets: Forwarded

/// Forwards to contained views.
- (void)keepMarginInsets:(KPEdgeInsets)insets priority:(KeepPriority)priority;

/// Forwards to contained views. Use is discouraged.
- (void)keepMarginInsets:(KPEdgeInsets)insets;





#pragma mark -
#pragma mark Center: Grouped

/// Grouped attribute for Horizontal Center of contained views.
@property (readonly) KeepAttribute *keepHorizontalCenter;

/// Grouped attribute for Vertical Center of contained views.
@property (readonly) KeepAttribute *keepVerticalCenter;

/// Grouped attribute for Both Center Axis of contained views.
@property (readonly) KeepAttribute *keepCenter;



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
@property (readonly) KeepRelatedAttributeBlock keepLeftOffsetTo;

/// Grouped attribute for Right Offset of contained views.
@property (readonly) KeepRelatedAttributeBlock keepRightOffsetTo;

/// Grouped attribute for Leading Offset of contained views.
@property (readonly) KeepRelatedAttributeBlock keepLeadingOffsetTo;

/// Grouped attribute for Trailing Offset of contained views.
@property (readonly) KeepRelatedAttributeBlock keepTrailingOffsetTo;

/// Grouped attribute for Top Offset of contained views.
@property (readonly) KeepRelatedAttributeBlock keepTopOffsetTo;

/// Grouped attribute for Bottom Offset of contained views.
@property (readonly) KeepRelatedAttributeBlock keepBottomOffsetTo;

/// Grouped attribute for First Baseline Offset of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepFirstBaselineOffsetTo;

/// Grouped attribute for Last Baseline Offset of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepLastBaselineOffsetTo;



#pragma mark Offsets: Batch Convenience
/// Convenience methods applied to whole array, in the order they are in array.

/// All contained views will share the same Horizontal Offset (left to right) using given priority. First view will keep Right Offset to second view and so on.
- (void)keepHorizontalOffsets:(KeepValue)value KEEP_SWIFT_AWAY;

/// All contained views will share the same Leading Offset (depends on writing direction) using given priority. First view will keep Leading Offset to second view and so on.
- (void)keepLeadingOffsets:(KeepValue)value KEEP_SWIFT_AWAY;

/// All contained views will share the same Vertical Offset (top to bottom) using given priority. First view will keep Bottom Offset to second view and so on.
- (void)keepVerticalOffsets:(KeepValue)value KEEP_SWIFT_AWAY;

/// All contained views will share the same Baseline Offset (top to bottom) using given priority. First view will keep Last Baseline Offset to second view’ First Baseline and so on.
- (void)keepBaselineOffsets:(KeepValue)value KEEP_SWIFT_AWAY;





#pragma mark -
#pragma mark Alignments: Grouped

/// Grouped attribute for Left Alignment of contained views.
@property (readonly) KeepRelatedAttributeBlock keepLeftAlignTo;

/// Grouped attribute for Right Alignment of contained views.
@property (readonly) KeepRelatedAttributeBlock keepRightAlignTo;

/// Grouped attribute for Leading Alignment of contained views.
@property (readonly) KeepRelatedAttributeBlock keepLeadingAlignTo;

/// Grouped attribute for Trailing Alignment of contained views.
@property (readonly) KeepRelatedAttributeBlock keepTrailingAlignTo;

/// Grouped attribute for Top Alignment of contained views.
@property (readonly) KeepRelatedAttributeBlock keepTopAlignTo;

/// Grouped attribute for Bottom Alignment of contained views.
@property (readonly) KeepRelatedAttributeBlock keepBottomAlignTo;

/// Grouped attribute for All 4 Edge Alignments of contained views.
@property (readonly) KeepRelatedAttributeBlock keepEdgeAlignTo;

/// Grouped attribute for Vertical Center Alignment of contained views.
@property (readonly) KeepRelatedAttributeBlock keepVerticalAlignTo;

/// Grouped attribute for Horizontal Center Alignment of contained views.
@property (readonly) KeepRelatedAttributeBlock keepHorizontalAlignTo;

/// Grouped attribute for Both Center Axis Alignment of contained views.
@property (readonly) KeepRelatedAttributeBlock keepCenterAlignTo;

/// Grouped attribute for First Baseline Alignment of contained views.
@property (readonly) KeepRelatedAttributeBlock keepFirstBaselineAlignTo;

/// Grouped attribute for Last Baseline Alignment of contained views.
@property (readonly) KeepRelatedAttributeBlock keepLastBaselineAlignTo;


#pragma mark Alignments: Batch Convenience
/// Convenience methods applied to whole array, in the order they are in array.

/// All contained views will share the same Left Alignment. First view will keep Left Alignment (with offset) with second view and so on.
- (void)keepLeftAlignments:(KeepValue)value KEEP_SWIFT_AWAY;

/// All contained views will be aligned to the left. First view will keep Left Alignment with second view and so on.
- (void)keepLeftAligned;

/// All contained views will share the same Right Alignment. First view will keep Right Alignment (with offset) with second view and so on.
- (void)keepRightAlignments:(KeepValue)value KEEP_SWIFT_AWAY;

/// All contained views will be aligned to the right. First view will keep Right Alignment with second view and so on.
- (void)keepRightAligned;

/// All contained views will share the same Leading Alignment. First view will keep Leading Alignment (with offset) with second view and so on.
- (void)keepLeadingAlignments:(KeepValue)value KEEP_SWIFT_AWAY;

/// All contained views will be aligned to the leading side. First view will keep Leading Alignment with second view and so on.
- (void)keepLeadingAligned;

/// All contained views will share the same Trailing Alignment. First view will keep Trailing Alignment (with offset) with second view and so on.
- (void)keepTrailingAlignments:(KeepValue)value KEEP_SWIFT_AWAY;

/// All contained views will be aligned to the trailing side. First view will keep Trailing Alignment with second view and so on.
- (void)keepTrailingAligned;

/// All contained views will share the same Top Alignment. First view will keep Top Alignment (with offset) with second view and so on.
- (void)keepTopAlignments:(KeepValue)value KEEP_SWIFT_AWAY;

/// All contained views will be aligned to the top. First view will keep Top Alignment with second view and so on.
- (void)keepTopAligned;

/// All contained views will share the same Bottom Alignment. First view will keep Bottom Alignment (with offset) with second view and so on.
- (void)keepBottomAlignments:(KeepValue)value KEEP_SWIFT_AWAY;

/// All contained views will be aligned to the bottom. First view will keep Bottom Alignment with second view and so on.
- (void)keepBottomAligned;

/// All contained views will share the same Vertical Center Alignment. First view will keep Vertical Center Alignment (with offset) with second view and so on.
- (void)keepVerticalAlignments:(KeepValue)value KEEP_SWIFT_AWAY;

/// All contained views will vertically aligned. First view will keep Vertical Center Alignment with second view and so on.
- (void)keepVerticallyAligned;

/// All contained views will share the same Horizontal Center Alignment. First view will keep Horizontal Center Alignment (with offset) with second view and so on.
- (void)keepHorizontalAlignments:(KeepValue)value KEEP_SWIFT_AWAY;

/// All contained views will horizontally aligned. First view will keep Horizontal Center Alignment with second view and so on.
- (void)keepHorizontallyAligned;

/// All contained views will share the same First Baseline Alignment. First view will keep First Baseline Alignment (with offset) with second view and so on.
- (void)keepFirstBaselineAlignments:(KeepValue)value KEEP_SWIFT_AWAY;

/// All contained views will be aligned to their first baseline. First view will keep First Baseline Alignment with second view and so on.
- (void)keepFirstBaselineAligned;

/// All contained views will share the same Last Baseline Alignment. First view will keep Last Baseline Alignment (with offset) with second view and so on.
- (void)keepLastBaselineAlignments:(KeepValue)value KEEP_SWIFT_AWAY;

/// All contained views will aligned to their last baseline. First view will keep Last Baseline Alignment with second view and so on.
- (void)keepLastBaselineAligned;





@end
