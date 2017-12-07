//
//  KeepAttribute.h
//  Keep Layout
//
//  Created by Martin Kiss on 28.1.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "KeepTypes.h"



@class KeepAtomic;





/// Each instance if KeepAttribute manages up to 3 NSLayoutConstraints: one for each relation.
/// Class cluster.
@interface KeepAttribute : NSObject



#pragma mark Values
/// Value with priority to be applied to underlaying constraints.
@property KeepValue equal KEEP_SWIFT_AWAY NS_SWIFT_NAME(incompatible_equal); ///< Constraint with relation Equal
@property KeepValue max KEEP_SWIFT_AWAY NS_SWIFT_NAME(incompatible_max); ///< Constraint with relation GreaterThanOrEqual
@property KeepValue min KEEP_SWIFT_AWAY NS_SWIFT_NAME(incompatible_min); ///< Constraint with relation LessThanOrEqual

- (void)keepAt:(KeepValue)equal min:(KeepValue)min KEEP_SWIFT_AWAY;
- (void)keepAt:(KeepValue)equal max:(KeepValue)max KEEP_SWIFT_AWAY;
- (void)keepAt:(KeepValue)equal min:(KeepValue)min max:(KeepValue)max KEEP_SWIFT_AWAY;
- (void)keepMin:(KeepValue)min max:(KeepValue)max KEEP_SWIFT_AWAY;

- (BOOL)isRelatedToView:(KPView *)view;

#pragma mark Swift Compatibility
/// Don’t use these directly. They are exposed for Swift extension to avoid KeepValue type.

@property KeepValue_Decomposed decomposed_equal;
@property KeepValue_Decomposed decomposed_max;
@property KeepValue_Decomposed decomposed_min;


#pragma mark Activation
/// Whether at least one constraint is active.
@property (readonly) BOOL isActive;
/// Disables all managed constraints.
- (void)deactivate;


#pragma mark Grouping
/// Allows you to create groups of attributes. Grouped attribute forwards all methods to its children.
+ (KeepAttribute *)group:(KeepAttribute *)first, ... NS_REQUIRES_NIL_TERMINATION;


#pragma mark Debugging
/// Debugging helper. Name of attribute is a part of its `-description`
@property (copy) NSString *name;
- (instancetype)name:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);



@end



@interface KeepAtomic : NSObject

/// Executes block and returns group of all changed attributes.
+ (KeepAtomic *)layout:(void(^)(void))block;
/// Disables all managed constraints.
- (void)deactivate;

@end







/// Private protocol.
/// Used as common type for Views and Layout Guides.
@protocol KeepViewOrGuide <NSObject> @end
@interface KPView (KeepViewOrGuide) <KeepViewOrGuide> @end
@interface KPLayoutGuide (KeepViewOrGuide) <KeepViewOrGuide> @end



/// Private class.
/// Used by Keep Layout implementation to create attributes.
@interface KeepSimpleAttribute : KeepAttribute

/// Properties that don't change in time.
- (instancetype)initWithView:(KPView *)view
             layoutAttribute:(NSLayoutAttribute)layoutAttribute
                 relatedView:(id<KeepViewOrGuide>)relatedViewOrGuide
      relatedLayoutAttribute:(NSLayoutAttribute)relatedLayoutAttribute
                 coefficient:(CGFloat)coefficient;
/// Multiplier of values: equal, min and max
@property (readonly) CGFloat coefficient;

@end



/// Private class.
/// Used for attributes where the values are expressed as constants.
@interface KeepConstantAttribute : KeepSimpleAttribute
@end



/// Private class.
/// Used for attributes where the values are expressed as multipliers.
@interface KeepMultiplierAttribute : KeepSimpleAttribute
@end



/// Private class.
/// The `+group:` method returns instance of this class. Forwards methods from base class cluster interface to its children.
@interface KeepGroupAttribute : KeepAttribute

- (instancetype)initWithAttributes:(id<NSFastEnumeration>)attributes;
@property (readonly) id<NSFastEnumeration> attributes;

@end



