//
//  KeepTypes.m
//  Keep Layout
//
//  Created by Martin Kiss on 19.6.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "KeepTypes.h"
#import <complex.h>



#if TARGET_OS_IPHONE


#else

const KPEdgeInsets KPEdgeInsetsZero = (KPEdgeInsets){.top = 0, .left = 0, .bottom = 0, .right = 0};
const KPOffset KPOffsetZero = (KPOffset){.horizontal = 0, .vertical = 0};

#endif



extern NSString *KeepPriorityDescription(KeepPriority priority) {
    NSString *name = @"";
    
    if (priority >= (KeepPriorityRequired + KeepPriorityHigh) / 2) {
        priority -= KeepPriorityRequired;
        name = @"required";
    }
    else if (priority >= (KeepPriorityHigh + KeepPriorityLow) / 2) {
        priority -= KeepPriorityHigh;
        name = @"high";
    }
    else if (priority >= (KeepPriorityLow + KeepPriorityFitting) / 2) {
        priority -= KeepPriorityLow;
        name = @"low";
    }
    else {
        priority -= KeepPriorityFitting;
        name = @"fitting";
    }
    
    if (priority) {
        name = [name stringByAppendingFormat:@"(%@%i)", (priority > 0? @"+" : @""), (uint32_t)priority];
    }
    
    return name;
}





double KeepValueGetPriority(KeepValue value) {
    return cimag(value);
}


KeepValue KeepValueSetDefaultPriority(KeepValue value, KeepPriority priority) {
    if (KeepValueGetPriority(value) <= 0) {
        return KeepValueMake(value, priority);
    }
    else {
        return value;
    }
}





const KeepValue KeepNone = { NAN, 0 };


BOOL KeepValueIsNone(KeepValue keepValue) {
    double value = keepValue;
    return isnan(value);
}





KeepValue KeepValueMake(CGFloat value, KeepPriority priority) {
    return (KeepValue) { value, priority };
}


KeepValue KeepRequired(CGFloat value) {
    return KeepValueMake(value, KeepPriorityRequired);
}


KeepValue KeepHigh(CGFloat value) {
    return KeepValueMake(value, KeepPriorityHigh);
}


KeepValue KeepLow(CGFloat value) {
    return KeepValueMake(value, KeepPriorityLow);
}


KeepValue KeepFitting(CGFloat value) {
    return KeepValueMake(value, KeepPriorityFitting);
}





NSString *KeepValueDescription(KeepValue value) {
    if (KeepValueIsNone(value)) return @"none";
    
    NSString *description = @((double)value).stringValue;
    KeepPriority priority = KeepValueGetPriority(value);
    if (priority != KeepPriorityRequired) {
        description = [description stringByAppendingFormat:@"@%@", @(priority).stringValue];
    }
    return description;
}


