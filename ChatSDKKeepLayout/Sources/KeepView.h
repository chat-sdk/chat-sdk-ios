//
//  KeepView.h
//  Keep Layout
//
//  Created by Martin Kiss on 21.10.12.
//  Copyright (c) 2012 iMartin Kiss. All rights reserved.
//

#import "KeepTypes.h"

@class KeepAttribute;


typedef KeepAttribute *(^KeepRelatedAttributeBlock)(KPView *otherView);



/**
 Category that provides very easy access to all Auto Layout features through abstraction on top of NSLayoutConstraints.
 
 Usage of methods returning KeepAttribute:
 \code
 view.keepWidth.equal = 320;
 \endcode
 
 Usage of methods returning KeepRelatedAttributeBlock:
 \code
 view.keepWidthTo(anotherView).equal = 2; // 2x wider
 \endcode
 
 **/
@interface KPView (KeepLayout)





#pragma mark -
#pragma mark Dimensions: Core
/// Attributes representing internal size of the receiver.

/// Width of the receiver.
@property (readonly) KeepAttribute *keepWidth;

/// Height of the receiver.
@property (readonly) KeepAttribute *keepHeight;

/// Aspect Ratio of receiver's dimensions in the order Width/Height. For example 16/9 or 4/3.
@property (readonly) KeepAttribute *keepAspectRatio;

/// Relative Width to other view. Value is multiplier of the other view's dimension. Both views must be in the same hierarchy.
@property (readonly) KeepRelatedAttributeBlock keepWidthTo;

/// Relative Height to other view. Value is multiplier of the other view's dimension. Both views must be in the same hierarchy.
@property (readonly) KeepRelatedAttributeBlock keepHeightTo;



#pragma mark Dimensions: Convenience
/// Convenience methods for setting both dimensions at once.

/// Grouped proxy attribute for Width and Height.
@property (readonly) KeepAttribute *keepSize;

/// Grouped proxy attribute for Relative Width and Height. Values are multipliers of the other view's dimensions. Both views must be in the same hierarchy.
@property (readonly) KeepRelatedAttributeBlock keepSizeTo;

/// Sets custom Width and Height at once with given priority.
- (void)keepSize:(CGSize)size priority:(KeepPriority)priority;

/// Sets custom Width and Height at once with Required priority. Use is discouraged.
- (void)keepSize:(CGSize)size;





#pragma mark -
#pragma mark Superview Insets: Core
/// Attributes representing internal inset of the receiver to its current superview.

/// Left Inset of the receiver in its current superview.
@property (readonly) KeepAttribute *keepLeftInset;

/// Right Inset of the receiver in its current superview. Values are inverted to Right-to-Left direction.
@property (readonly) KeepAttribute *keepRightInset;

/// Leading Inset of the receiver in its current superview. Depends on writing direction.
@property (readonly) KeepAttribute *keepLeadingInset;

/// Trailing Inset of the receiver in its current superview. Values are inverted to Right-to-Left direction. Depends on writing direction.
@property (readonly) KeepAttribute *keepTrailingInset;

/// Top Inset of the receiver in its current superview.
@property (readonly) KeepAttribute *keepTopInset;

/// Bottom Inset of the receiver in its current superview. Values are inverted to Bottom-to-Top direction.
@property (readonly) KeepAttribute *keepBottomInset;

/// First Baseline Inset of the receiver in its current superview from Top Edge. Not all views have baselines.
@property (nonatomic, readonly) KeepAttribute *keepFirstBaselineInset;

/// Last Baseline Inset of the receiver in its current superview from Bottom Edge. Not all views have baselines. Values are inverted to Bottom-to-Top direction.
@property (nonatomic, readonly) KeepAttribute *keepLastBaselineInset;



#pragma mark Superview Insets: Convenience
/// Convenience methods for setting all insets at once.

/// Grouped proxy attribute for Top, Bottom, Left and Right Inset.
@property (readonly) KeepAttribute *keepInsets;

/// Grouped proxy attribute for Left and Right Inset.
@property (readonly) KeepAttribute *keepHorizontalInsets;

/// Grouped proxy attribute for Top and Bottom Inset.
@property (readonly) KeepAttribute *keepVerticalInsets;

/// Sets custom Insets using given priority.
- (void)keepInsets:(KPEdgeInsets)insets priority:(KeepPriority)priority;

/// Sets custom Insets using Required priority. Use is discouraged.
- (void)keepInsets:(KPEdgeInsets)insets;





#pragma mark -
#pragma mark Superview Safe Insets: Core
/// Attributes representing internal inset of the receive to its current superview, taking into account its safe insets.

/// Left Safe Inset of the receiver in its current superview.
@property (readonly) KeepAttribute *keepLeftSafeInset API_AVAILABLE(ios(11));

/// Right Safe Inset of the receiver in its current superview. Values are inverted to Right-to-Left direction.
@property (readonly) KeepAttribute *keepRightSafeInset API_AVAILABLE(ios(11));

/// Leading Safe Inset of the receiver in its current superview. Depends on writing direction.
@property (readonly) KeepAttribute *keepLeadingSafeInset API_AVAILABLE(ios(11));

/// Trailing Safe Inset of the receiver in its current superview. Values are inverted to Right-to-Left direction. Depends on writing direction.
@property (readonly) KeepAttribute *keepTrailingSafeInset API_AVAILABLE(ios(11));

/// Top Safe Inset of the receiver in its current superview.
@property (readonly) KeepAttribute *keepTopSafeInset API_AVAILABLE(ios(11));

/// Bottom Safe Inset of the receiver in its current superview. Values are inverted to Bottom-to-Top direction.
@property (readonly) KeepAttribute *keepBottomSafeInset API_AVAILABLE(ios(11));



#pragma mark Superview Safe Insets: Convenience
/// Convenience methods for setting all safe insets at once.

/// Grouped proxy attribute for Top, Bottom, Left and Right Safe Inset.
@property (readonly) KeepAttribute *keepSafeInsets API_AVAILABLE(ios(11));

/// Grouped proxy attribute for Left and Right Safe Inset.
@property (readonly) KeepAttribute *keepHorizontalSafeInsets API_AVAILABLE(ios(11));

/// Grouped proxy attribute for Top and Bottom Safe Inset.
@property (readonly) KeepAttribute *keepVerticalSafeInsets API_AVAILABLE(ios(11));

/// Sets custom Safe Insets using given priority.
- (void)keepSafeInsets:(KPEdgeInsets)insets priority:(KeepPriority)priority API_AVAILABLE(ios(11));

/// Sets custom Safe Insets using Required priority. Use is discouraged.
- (void)keepSafeInsets:(KPEdgeInsets)insets API_AVAILABLE(ios(11));





#pragma mark -
#pragma mark Superview Margin Insets: Core
/// Attributes representing internal inset of the receive to its current superview, taking into account its margin insets.

/// Left Margin Inset of the receiver in its current superview.
@property (readonly) KeepAttribute *keepLeftMarginInset;

/// Right Margin Inset of the receiver in its current superview. Values are inverted to Right-to-Left direction.
@property (readonly) KeepAttribute *keepRightMarginInset;

/// Leading Margin Inset of the receiver in its current superview. Depends on writing direction.
@property (readonly) KeepAttribute *keepLeadingMarginInset;

/// Trailing Margin Inset of the receiver in its current superview. Values are inverted to Right-to-Left direction. Depends on writing direction.
@property (readonly) KeepAttribute *keepTrailingMarginInset;

/// Top Margin Inset of the receiver in its current superview.
@property (readonly) KeepAttribute *keepTopMarginInset;

/// Bottom Margin Inset of the receiver in its current superview. Values are inverted to Bottom-to-Top direction.
@property (readonly) KeepAttribute *keepBottomMarginInset;



#pragma mark Superview Margin Insets: Convenience
/// Convenience methods for setting all margin insets at once.

/// Grouped proxy attribute for Top, Bottom, Left and Right Margin Inset.
@property (readonly) KeepAttribute *keepMarginInsets;

/// Grouped proxy attribute for Left and Right Margin Inset.
@property (readonly) KeepAttribute *keepHorizontalMarginInsets;

/// Grouped proxy attribute for Top and Bottom Margin Inset.
@property (readonly) KeepAttribute *keepVerticalMarginInsets;

/// Sets custom Margin Insets using given priority.
- (void)keepMarginInsets:(KPEdgeInsets)insets priority:(KeepPriority)priority;

/// Sets custom Margin Insets using Required priority. Use is discouraged.
- (void)keepMarginInsets:(KPEdgeInsets)insets;





#pragma mark -
#pragma mark Center: Core
/// Attributes representing relative position of the receiver in its current superview.

/// Horizontal Center of the receiver in its current superview (X axis). Value is multiplier of superview's width, so 0.5 is middle.
@property (readonly) KeepAttribute *keepHorizontalCenter;

/// Vertical Center of the receiver in its current superview (Y axis). Value is multiplier of superview's height, so 0.5 is middle.
@property (readonly) KeepAttribute *keepVerticalCenter;



#pragma mark Center: Convenience
/// Convenience methods for both center axis at once or with default values.

/// Grouped proxy attribute for Horizontal and Vertical Center. Value is multiplier of superview's dimensions, so 0.5 is middle.
@property (readonly) KeepAttribute *keepCenter;

/// Sets both Center axis to 0.5 with given priority.
- (void)keepCenteredWithPriority:(KeepPriority)priority;

/// Sets both Center axis to 0.5 with Required priority. Use is discouraged.
- (void)keepCentered;

/// Sets Horizontal Center axis to 0.5 with given priority.
- (void)keepHorizontallyCenteredWithPriority:(KeepPriority)priority;

/// Sets Horizontal Center axis to 0.5 with Required priority. Use is discouraged.
- (void)keepHorizontallyCentered;

/// Sets Vertical Center axis to 0.5 with given priority.
- (void)keepVerticallyCenteredWithPriority:(KeepPriority)priority;

/// Sets Vertical Center axis to 0.5 with Required priority. Use is discouraged.
- (void)keepVerticallyCentered;

/// Sets both center axis using given priority. Point values are multiplier of superview's dimensions, so 0.5 is middle.
- (void)keepCenter:(CGPoint)center priority:(KeepPriority)priority;

/// Sets both center axis using Required priority. Use is discouraged. Point values are multiplier of superview's dimensions, so 0.5 is middle.
- (void)keepCenter:(CGPoint)center;





#pragma mark -
#pragma mark Offsets: Core
/// Attributes representing offset (padding or distance) of two views. There attributes use opposite edges to create constraints.

/// Left Offset to other view. Views must be in the same view hierarchy.
@property (readonly) KeepRelatedAttributeBlock keepLeftOffsetTo;

/// Right Offset to other view. Views must be in the same view hierarchy. Identical to Left Offset in reversed direction.
@property (readonly) KeepRelatedAttributeBlock keepRightOffsetTo;

/// Leading Offset to other view. Views must be in the same view hierarchy. Depends on writing direction.
@property (readonly) KeepRelatedAttributeBlock keepLeadingOffsetTo;

/// Trailing Offset to other view. Views must be in the same view hierarchy. Identical to Leading Offset in reversed direction. Depends on writing direction.
@property (readonly) KeepRelatedAttributeBlock keepTrailingOffsetTo;

/// Top Offset to other view. Views must be in the same view hierarchy.
@property (readonly) KeepRelatedAttributeBlock keepTopOffsetTo;

/// Bottom Offset to other view. Views must be in the same view hierarchy. Identical to Top Offset in reversed direction.
@property (readonly) KeepRelatedAttributeBlock keepBottomOffsetTo;

/// First Baseline Offset to other view’s Last Baseline. Not all views have baselines.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepFirstBaselineOffsetTo;

/// Last Baseline Offset to other view’s First Baseline. Not all views have baselines. Identical to First Baseline Offset in reversed direction.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepLastBaselineOffsetTo;





#pragma mark -
#pragma mark Alignments: Core
/// Attributes representing alignment of two views. You align view usually to 0 offset, but this can be changed.

/// Left Alignment with other view. Views must be in the same view hierarchy. Value is offset of the receiver from the other view.
@property (readonly) KeepRelatedAttributeBlock keepLeftAlignTo;

/// Right Alignment with other view. Views must be in the same view hierarchy. Value is offset of the receiver from the other view. Values are inverted to Right-to-Left direction.
@property (readonly) KeepRelatedAttributeBlock keepRightAlignTo;

/// Leading Alignment with other view. Views must be in the same view hierarchy. Value is offset of the receiver from the other view. Depends on writing direction.
@property (readonly) KeepRelatedAttributeBlock keepLeadingAlignTo;

/// Trailing Alignment with other view. Views must be in the same view hierarchy. Value is offset of the receiver from the other view. Values are inverted to Right-to-Left direction. Depends on writing direction.
@property (readonly) KeepRelatedAttributeBlock keepTrailingAlignTo;

/// Top Alignment with other view. Views must be in the same view hierarchy. Value is offset of the receiver from the other view.
@property (readonly) KeepRelatedAttributeBlock keepTopAlignTo;

/// Bottom Alignment with other view. Views must be in the same view hierarchy. Value is offset of the receiver from the other view. Values are inverted to Bottom-to-Top direction.
@property (readonly) KeepRelatedAttributeBlock keepBottomAlignTo;

/// Vertical Center Alignment with other view, modifies the X position. Views must be in the same view hierarchy. Value is offset of the receiver from the other view.
@property (readonly) KeepRelatedAttributeBlock keepVerticalAlignTo;

/// Horizontal Center Alignment with other view, modifies the Y position. Views must be in the same view hierarchy. Value is offset of the receiver from the other view.
@property (readonly) KeepRelatedAttributeBlock keepHorizontalAlignTo;

/// First Baseline Alignments of two views. Not all views have baselines. Values are inverted to Bottom-to-Top direction, so positive offset moves the receiver up.
@property (readonly) KeepRelatedAttributeBlock keepFirstBaselineAlignTo;

/// Last Baseline Alignments of two views. Not all views have baselines. Values are inverted to Bottom-to-Top direction, so positive offset moves the receiver up.
@property (readonly) KeepRelatedAttributeBlock keepLastBaselineAlignTo;



#pragma mark Alignments: Convenience
/// Convenience methods for setting multiple alignments at once.

/// Grouped proxy attribute for Top, Left, Bottom and Right Alignment with other view.
@property (readonly) KeepRelatedAttributeBlock keepEdgeAlignTo;

/// Grouped proxy attribute for Center X and Center Y Alignment with other view.
@property (readonly) KeepRelatedAttributeBlock keepCenterAlignTo;





#pragma mark -
#pragma mark Compression & Hugging Convenience

/// Convenience accessor for compression resistance priority in both axes. Primarily for setting. If they are different, lower is returned from getter.
@property KeepPriority keepCompressionResistance;

/// Convenience accessor for compression resistance priority in X axis.
@property KeepPriority keepHorizontalCompressionResistance;

/// Convenience accessor for compression resistance priority in Y axis.
@property KeepPriority keepVerticalCompressionResistance;

/// Convenience accessor for hugging priority in both axes. Primarily for setting. If they are different, lower is returned from getter.
@property KeepPriority keepHuggingPriority;

/// Convenience accessor for hugging priority in X axis.
@property KeepPriority keepHorizontalHuggingPriority;

/// Convenience accessor for hugging priority in Y axis.
@property KeepPriority keepVerticalHuggingPriority;





#pragma mark -
#pragma mark Animations
#if TARGET_OS_IOS
/// Animation methods allowing you to modify all above attributes (or even constraints directly) animatedly. All animations are scheduled on main queue with given or zero delay. The layout code itself is executed after the delay, which is different than in UIView animation methods. This behavior is needed, because of different nature of constraint-based layouting and allows you to schedule animations in the same update cycle as your main layout.

/// Animate layout changes. Receiver automatically calls `-layoutIfNeeded` after the animation block. Animation is scheduled on Main Queue with zero delay, so the block not executed immediatelly.
- (void)keepAnimatedWithDuration:(NSTimeInterval)duration layout:(void(^)(void))animations;

/// Animate layout changes with delay. Receiver automatically calls `-layoutIfNeeded` after the animation block. Animation is scheduled on Main Queue with given delay.
- (void)keepAnimatedWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay layout:(void(^)(void))animations;

/// Animate layout changes with completion. Receiver automatically calls `-layoutIfNeeded` after the animation block. Animation is scheduled on Main Queue with zero delay, so the block not executed immediatelly.
- (void)keepAnimatedWithDuration:(NSTimeInterval)duration layout:(void(^)(void))animations completion:(void(^)(BOOL finished))completion;

/// Animate layout changes with delay, options and completion. Receiver automatically calls `-layoutIfNeeded` after the animation block. Animation is scheduled on Main Queue with given delay.
- (void)keepAnimatedWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options layout:(void(^)(void))animations completion:(void(^)(BOOL finished))completion;

/// Animate layout changes with spring behavior, delay, options and completion. Receiver automatically calls `-layoutIfNeeded` after the animation block. Animation is scheduled on Main Queue with given delay.
- (void)keepAnimatedWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options layout:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

/// Prevent animating layout changes in the block. Due to different nature of constraint-based layouting, this may not work as you may expect.
- (void)keepNotAnimated:(void (^)(void))layout;

#endif // TARGET_OS_IOS





@end
