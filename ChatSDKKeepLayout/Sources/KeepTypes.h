//
//  KeepTypes.h
//  Keep Layout
//
//  Created by Martin Kiss on 28.1.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>



#define KeepAssert(CONDITION, DESCRIPTION...)   NSCAssert((CONDITION), @"Keep Layout: " DESCRIPTION)
#define KeepParameterAssert(CONDITION)          NSCAssert((CONDITION), @"Keep Layout: " @"Invalid parameter not satisfying: %s", #CONDITION)

#define KEEP_SWIFT_AWAY \
    NS_SWIFT_UNAVAILABLE("Not available in Swift.")



#if TARGET_OS_IOS

#import <UIKit/UIKit.h>
#define KPView                  UIView
#define KPLayoutGuide           UILayoutGuide
#define KPEdgeInsets            UIEdgeInsets
#define KPEdgeInsetsZero        UIEdgeInsetsZero

#define KPOffset                UIOffset
#define KPOffsetZero            UIOffsetZero

/// Use custom names.
typedef float KeepPriority;
static const KeepPriority KeepPriorityRequired = UILayoutPriorityRequired;
static const KeepPriority KeepPriorityHigh = UILayoutPriorityDefaultHigh;
static const KeepPriority KeepPriorityLow = UILayoutPriorityDefaultLow;
static const KeepPriority KeepPriorityFitting = UILayoutPriorityFittingSizeLevel;

#else

#import <AppKit/AppKit.h>
#define KPView                  NSView
#define KPLayoutGuide           NSLayoutGuide
#define KPEdgeInsets            NSEdgeInsets

extern const KPEdgeInsets KPEdgeInsetsZero;

typedef struct KPOffset {
    CGFloat horizontal, vertical;
} KPOffset;

static inline KPOffset KPOffsetMake(CGFloat horizontal, CGFloat vertical) {
    KPOffset offset = {horizontal, vertical};
    return offset;
}

extern const KPOffset KPOffsetZero;

/// Use custom names.
typedef float KeepPriority;
static const KeepPriority KeepPriorityRequired = NSLayoutPriorityRequired;
static const KeepPriority KeepPriorityHigh = NSLayoutPriorityDefaultHigh;
static const KeepPriority KeepPriorityLow = NSLayoutPriorityDefaultLow;
static const KeepPriority KeepPriorityFitting = NSLayoutPriorityFittingSizeCompression;

/// OS X doesn’t have margins.
#define NSLayoutAttributeTopMargin      NSLayoutAttributeTop
#define NSLayoutAttributeLeftMargin     NSLayoutAttributeLeft
#define NSLayoutAttributeRightMargin    NSLayoutAttributeRight
#define NSLayoutAttributeBottomMargin   NSLayoutAttributeBottom
#define NSLayoutAttributeLeadingMargin  NSLayoutAttributeLeading
#define NSLayoutAttributeTrailingMargin NSLayoutAttributeTrailing

#endif


extern NSString *KeepPriorityDescription(KeepPriority);



#pragma mark Value
/// Represents a value with associated priority (imaginary part). Used as values for attributes and underlaying constraints. Complex type is used to provide compatibility with scalars.
typedef _Complex double KeepValue KEEP_SWIFT_AWAY;

/// Extracts priority (imaginary part). The value itself can be obtained by casting to double.
extern double KeepValueGetPriority(KeepValue) KEEP_SWIFT_AWAY;
/// If the priority is 0, sets the priority provided.
extern KeepValue KeepValueSetDefaultPriority(KeepValue, KeepPriority) KEEP_SWIFT_AWAY;

/// Use these macros to build KeepValues easily: x = 10 keepHigh;
#define keepAt(Priority)    +((Priority) * 1i)
#define keepRequired        keepAt(KeepPriorityRequired)
#define keepHigh            keepAt(KeepPriorityHigh)
#define keepLow             keepAt(KeepPriorityLow)
#define keepFitting         keepAt(KeepPriorityFitting)

/// Value, that represents no value. KeepValueIsNone will return YES.
extern const KeepValue KeepNone KEEP_SWIFT_AWAY;
/// Returns YES for any value that has real value of NAN.
extern BOOL KeepValueIsNone(KeepValue) KEEP_SWIFT_AWAY;

/// Constructor with arbitrary priority
extern KeepValue KeepValueMake(CGFloat, KeepPriority) KEEP_SWIFT_AWAY;
/// Constructors for 4 basic priorities
extern KeepValue KeepRequired(CGFloat) KEEP_SWIFT_AWAY;
extern KeepValue KeepHigh(CGFloat) KEEP_SWIFT_AWAY;
extern KeepValue KeepLow(CGFloat) KEEP_SWIFT_AWAY;
extern KeepValue KeepFitting(CGFloat) KEEP_SWIFT_AWAY;

/// Debug description (example “42@750”, or just “42” if priority is Required)
extern NSString *KeepValueDescription(KeepValue) KEEP_SWIFT_AWAY;



#pragma mark Swift Compatibility

typedef struct {
    CGFloat value;
    KeepPriority priority;
} KeepValue_Decomposed;


