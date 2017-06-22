//
//  KeepAttribute.m
//  Keep Layout
//
//  Created by Martin Kiss on 28.1.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "KeepAttribute.h"
#import "KeepView.h"
#import "KeepLayoutConstraint.h"





@implementation KeepAttribute





- (instancetype)init {
    self = [super init];
    if (self) {
        NSAssert(self.class != KeepAttribute.class, @"%@ is abstract class", self.class);
        if (self.class == KeepAttribute.class) {
            return nil;
        }
    }
    return self;
}





#pragma mark Values


- (void)keepAt:(KeepValue)equal min:(KeepValue)min {
    self.equal = KeepValueSetDefaultPriority(equal, KeepPriorityHigh);
    self.min = min;
}


- (void)keepAt:(KeepValue)equal max:(KeepValue)max {
    self.equal = KeepValueSetDefaultPriority(equal, KeepPriorityHigh);
    self.max = max;
}


- (void)keepAt:(KeepValue)equal min:(KeepValue)min max:(KeepValue)max {
    self.equal = KeepValueSetDefaultPriority(equal, KeepPriorityHigh);
    self.min = min;
    self.max = max;
}


- (void)keepMin:(KeepValue)min max:(KeepValue)max {
    self.min = min;
    self.max = max;
}


- (CGFloat)required {
    KeepValue equal = self.equal;
    return (KeepValueGetPriority(equal) == KeepPriorityRequired? equal : NAN);
}


- (void)setRequired:(CGFloat)value {
    self.equal = KeepRequired(value);
}


#pragma mark Remove


- (void)remove {
    NSAssert(NO, @"-[%@ %@] is abstract", KeepAttribute.class, NSStringFromSelector(_cmd));
}





#pragma mark Grouping


+ (KeepGroupAttribute *)group:(KeepAttribute *)first, ... NS_REQUIRES_NIL_TERMINATION {
    va_list list;
    va_start(list, first);
    
    NSMutableArray *attributes = [[NSMutableArray alloc] init];
    KeepAttribute *attribute = first;
    while (attribute) {
        [attributes addObject:attribute];
        attribute = va_arg(list, KeepAttribute *);
    }
    
    va_end(list);
    
    return [[KeepGroupAttribute alloc] initWithAttributes:attributes];
}


+ (KeepRemovableGroup *)removableChanges:(void(^)(void))block {
    KeepRemovableGroup *removableGroup = [[KeepRemovableGroup alloc] init];
    [KeepRemovableGroup setCurrent:removableGroup];
    block();
    [KeepRemovableGroup setCurrent:nil];
    return removableGroup;
}





#pragma mark Naming & Debugging


- (instancetype)name:(NSString *)format, ... {
#ifdef DEBUG
    va_list arguments;
    va_start(arguments, format);
    
    self.name = [[NSString alloc] initWithFormat:format arguments:arguments];
    
    va_end(arguments);
#endif
    return self;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p; %@ [%@ < %@ < %@]>",
            self.class,
            self,
            self.name ?: @"(no name)",
            KeepValueDescription(self.min),
            KeepValueDescription(self.equal),
            KeepValueDescription(self.max)];
}





@end










#pragma mark -


@interface KeepSimpleAttribute ()

@property (nonatomic, readwrite, weak) KPView *view;
@property (nonatomic, readwrite, assign) NSLayoutAttribute layoutAttribute;
@property (nonatomic, readwrite, weak) KPView *relatedView;
@property (nonatomic, readwrite, assign) NSLayoutAttribute relatedLayoutAttribute;
@property (nonatomic, readwrite, weak) KPView *constraintView;

@property (nonatomic, readwrite, assign) CGFloat coefficient;

@property (nonatomic, readwrite, strong) KeepLayoutConstraint *equalConstraint;
@property (nonatomic, readwrite, strong) KeepLayoutConstraint *maxConstraint;
@property (nonatomic, readwrite, strong) KeepLayoutConstraint *minConstraint;

- (instancetype)initWithView:(KPView *)view
             layoutAttribute:(NSLayoutAttribute)layoutAttribute
                 relatedView:(KPView *)relatedView
      relatedLayoutAttribute:(NSLayoutAttribute)superviewLayoutAttribute
                 coefficient:(CGFloat)coefficient;
- (KeepLayoutConstraint *)createConstraintWithRelation:(NSLayoutRelation)relation value:(KeepValue)value;
- (void)addConstraint:(KeepLayoutConstraint *)constraint;
- (void)applyValue:(KeepValue)value forConstraint:(KeepLayoutConstraint *)constraint relation:(NSLayoutRelation)relation;
- (void)removeConstraint:(KeepLayoutConstraint *)constraint;
- (void)setNameForConstraint:(KeepLayoutConstraint *)constraint relation:(NSLayoutRelation)relation value:(KeepValue)value;

@end





@implementation KeepSimpleAttribute





#pragma mark Initialization


- (instancetype)init {
    return [self initWithView:nil
              layoutAttribute:NSLayoutAttributeNotAnAttribute
                  relatedView:nil
       relatedLayoutAttribute:NSLayoutAttributeNotAnAttribute
            coefficient:0];
}


- (instancetype)initWithView:(KPView *)view
             layoutAttribute:(NSLayoutAttribute)layoutAttribute
                 relatedView:(KPView *)relatedView
      relatedLayoutAttribute:(NSLayoutAttribute)relatedLayoutAttribute
                 coefficient:(CGFloat)coefficient {
    self = [super init];
    if (self) {
            NSParameterAssert(view);
            NSParameterAssert(layoutAttribute != NSLayoutAttributeNotAnAttribute);
            NSParameterAssert(coefficient);
        
        NSAssert(self.class != KeepSimpleAttribute.class, @"%@ is abstract class", self.class);
        if (self.class == KeepSimpleAttribute.class) {
            return nil;
        }
        
        self.view = view;
        self.layoutAttribute = layoutAttribute;
        self.relatedView = relatedView;
        self.relatedLayoutAttribute = relatedLayoutAttribute;
        self.constraintView = (relatedView? [view commonSuperview:relatedView] : view);
        self.coefficient = coefficient;
    }
    return self;
}





#pragma mark Constraints


- (KeepLayoutConstraint *)createConstraintWithRelation:(NSLayoutRelation)relation value:(KeepValue)value {
    NSAssert(NO, @"-[%@ %@] is abstract", KeepSimpleAttribute.class, NSStringFromSelector(_cmd));
    return nil;
}


- (void)addConstraint:(KeepLayoutConstraint *)constraint {
    [self.constraintView addConstraint:constraint];
}


- (void)applyValue:(KeepValue)value forConstraint:(KeepLayoutConstraint *)constraint relation:(NSLayoutRelation)relation {
    NSAssert(NO, @"-[%@ %@] is abstract", KeepSimpleAttribute.class, NSStringFromSelector(_cmd));
}


- (void)removeConstraint:(KeepLayoutConstraint *)constraint {
    [self.constraintView removeConstraint:constraint];
}


- (void)remove {
    [self removeConstraint:self.equalConstraint]; self.equalConstraint = nil;
    [self removeConstraint:self.maxConstraint]; self.maxConstraint = nil;
    [self removeConstraint:self.minConstraint]; self.minConstraint = nil;
}





#pragma mark Values


- (void)setEqual:(KeepValue)equal {
    equal = KeepValueSetDefaultPriority(equal, KeepPriorityRequired);
    [super setEqual:equal];
    
    if (KeepValueIsNone(equal)) {
        [self removeConstraint:self.equalConstraint]; self.equalConstraint = nil;
        return;
    }
    
    NSLayoutRelation relation = NSLayoutRelationEqual;
    
    if ( ! self.equalConstraint) {
        self.equalConstraint = [self createConstraintWithRelation:relation value:equal];
        [self setNameForConstraint:self.equalConstraint relation:relation value:equal];
        [self addConstraint:self.equalConstraint];
    }
    else {
        [self applyValue:equal forConstraint:self.equalConstraint relation:relation];
        [self setNameForConstraint:self.equalConstraint relation:relation value:equal];
    }
    
    [[KeepRemovableGroup current] addAttribute:self forRelation:relation];
}


- (void)setMax:(KeepValue)max {
    max = KeepValueSetDefaultPriority(max, KeepPriorityRequired);
    [super setMax:max];
    
    if (KeepValueIsNone(max)) {
        [self removeConstraint:self.maxConstraint]; self.maxConstraint = nil;
        return;
    }
    
    NSLayoutRelation relation = NSLayoutRelationLessThanOrEqual;
    
    if ( ! self.maxConstraint) {
        self.maxConstraint = [self createConstraintWithRelation:relation value:max];
        [self setNameForConstraint:self.maxConstraint relation:relation value:max];
        [self addConstraint:self.maxConstraint];
    }
    else {
        [self applyValue:max forConstraint:self.maxConstraint relation:relation];
        [self setNameForConstraint:self.maxConstraint relation:relation value:max];
    }
    
    [[KeepRemovableGroup current] addAttribute:self forRelation:relation];
}


- (void)setMin:(KeepValue)min {
    min = KeepValueSetDefaultPriority(min, KeepPriorityRequired);
    [super setMin:min];
    
    if (KeepValueIsNone(min)) {
        [self removeConstraint:self.minConstraint]; self.minConstraint = nil;
        return;
    }
    
    NSLayoutRelation relation = NSLayoutRelationGreaterThanOrEqual;
    
    if ( ! self.minConstraint) {
        self.minConstraint = [self createConstraintWithRelation:relation value:min];
        [self setNameForConstraint:self.minConstraint relation:relation value:min];
        [self addConstraint:self.minConstraint];
    }
    else {
        [self applyValue:min forConstraint:self.minConstraint relation:relation];
        [self setNameForConstraint:self.minConstraint relation:relation value:min];
    }
    
    [[KeepRemovableGroup current] addAttribute:self forRelation:relation];
}



- (void)setNameForConstraint:(KeepLayoutConstraint *)constraint relation:(NSLayoutRelation)relation value:(KeepValue)value {
#ifdef DEBUG
    NSDictionary *relationNames = @{
                                    @(NSLayoutRelationEqual) : @"equal to",
                                    @(NSLayoutRelationGreaterThanOrEqual) : @"at least",
                                    @(NSLayoutRelationLessThanOrEqual) : @"at most",
                                    };
    [constraint name:@"%@ %@ %@ with %@ priority", self.name, [relationNames objectForKey:@(relation)], @((double)value), KeepPriorityDescription(KeepValueGetPriority(value))];
#endif
}





@end










#pragma mark -


@implementation KeepConstantAttribute





#pragma mark Constraint Overrides


- (KeepLayoutConstraint *)createConstraintWithRelation:(NSLayoutRelation)relation value:(KeepValue)value {
    if (self.coefficient < 0) {
        if (relation == NSLayoutRelationGreaterThanOrEqual) relation = NSLayoutRelationLessThanOrEqual;
        else if (relation == NSLayoutRelationLessThanOrEqual) relation = NSLayoutRelationGreaterThanOrEqual;
    }
    KeepLayoutConstraint *constraint = [KeepLayoutConstraint constraintWithItem:self.view attribute:self.layoutAttribute
                                                                    relatedBy:relation
                                                                       toItem:self.relatedView attribute:self.relatedLayoutAttribute
                                                                   multiplier:1 constant:value * self.coefficient];
    constraint.priority = KeepValueGetPriority(value);
    return constraint;
}


- (void)applyValue:(KeepValue)value forConstraint:(KeepLayoutConstraint *)constraint relation:(NSLayoutRelation)relation {
    constraint.constant = value * self.coefficient;
    if (constraint.priority != KeepValueGetPriority(value)) {
        constraint.priority = KeepValueGetPriority(value);
    }
}





@end










#pragma mark -



@implementation KeepMultiplierAttribute





#pragma mark Constraint Overrides


- (KeepLayoutConstraint *)createConstraintWithRelation:(NSLayoutRelation)relation value:(KeepValue)value {
    KeepLayoutConstraint *constraint = [KeepLayoutConstraint constraintWithItem:self.view attribute:self.layoutAttribute
                                                                    relatedBy:relation
                                                                       toItem:self.relatedView attribute:self.relatedLayoutAttribute
                                                                   multiplier:value * self.coefficient constant:0];
    constraint.priority = KeepValueGetPriority(value);
    return constraint;
}


- (void)applyValue:(KeepValue)value forConstraint:(KeepLayoutConstraint *)constraint relation:(NSLayoutRelation)relation {
    // Since multiplier is not read/write proeperty, we need to re-add the whole constraint again.
    [self removeConstraint:constraint];
    constraint = [self createConstraintWithRelation:constraint.relation value:value];
    
    // TODO: Better solution
    switch (relation) {
        case NSLayoutRelationEqual:
            self.equalConstraint = constraint;
            break;
        case NSLayoutRelationGreaterThanOrEqual:
            self.minConstraint = constraint;
            break;
        case NSLayoutRelationLessThanOrEqual:
            self.maxConstraint = constraint;
            break;
    }
    [self setNameForConstraint:constraint relation:relation value:value];
    [self addConstraint:constraint];
}





@end









#pragma mark -


@interface KeepGroupAttribute ()


@property (nonatomic, readwrite, strong) id<NSFastEnumeration> attributes;


@end





@implementation KeepGroupAttribute





#pragma mark Initialization


- (id)init {
    return [self initWithAttributes:nil];
}


- (instancetype)initWithAttributes:(id<NSFastEnumeration>)attributes {
    self = [super init];
    if (self) {
        NSParameterAssert(attributes);
        
        self.attributes = attributes;
    }
    return self;
}





#pragma mark Debugging


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p; %@ %@>", self.class, self, self.name ?: @"(no name)", [self valueForKeyPath:@"attributes.description"]];
}





#pragma mark Accessing Values

- (KeepValue)equal {
    NSLog(@"Warning! Accessing property %@ for grouped attribute, returning KeepNone.", NSStringFromSelector(_cmd));
    return KeepNone;
}

- (KeepValue)min {
    NSLog(@"Warning! Accessing property %@ for grouped attribute, returning KeepNone.", NSStringFromSelector(_cmd));
    return KeepNone;
}

- (KeepValue)max {
    NSLog(@"Warning! Accessing property %@ for grouped attribute, returning KeepNone.", NSStringFromSelector(_cmd));
    return KeepNone;
}





#pragma mark Setting Values


- (void)setEqual:(KeepValue)equal {
    for (KeepAttribute *attribute in self.attributes) attribute.equal = equal;
}


- (void)setMax:(KeepValue)max {
    for (KeepAttribute *attribute in self.attributes) attribute.max = max;
}


- (void)setMin:(KeepValue)min {
    for (KeepAttribute *attribute in self.attributes) attribute.min = min;
}





#pragma mark Remove


- (void)remove {
    for (KeepAttribute *attribute in self.attributes) [attribute remove];
}





@end









#pragma mark -


@interface KeepRemovableGroup ()


@property (nonatomic, readwrite, strong) NSMutableSet *equalAttributes;
@property (nonatomic, readwrite, strong) NSMutableSet *minAttributes;
@property (nonatomic, readwrite, strong) NSMutableSet *maxAttributes;


@end





@implementation KeepRemovableGroup





#pragma mark Initialization


- (instancetype)init {
    self = [super init];
    if (self) {
        self.equalAttributes = [[NSMutableSet alloc] init];
        self.minAttributes = [[NSMutableSet alloc] init];
        self.maxAttributes = [[NSMutableSet alloc] init];
    }
    return self;
}





#pragma mark Building


static KeepRemovableGroup *staticCurrent = nil;


+ (KeepRemovableGroup *)current {
    return staticCurrent;
}


+ (void)setCurrent:(KeepRemovableGroup *)current {
    staticCurrent = current;
}


- (void)addAttribute:(KeepAttribute *)attribute forRelation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationEqual: [self.equalAttributes addObject:attribute]; break;
        case NSLayoutRelationLessThanOrEqual: [self.maxAttributes addObject:attribute]; break;
        case NSLayoutRelationGreaterThanOrEqual: [self.minAttributes addObject:attribute]; break;
    }
}





#pragma mark Setting Values


- (void)remove {
    for (KeepAttribute *attribute in self.equalAttributes) attribute.equal = KeepNone;
    for (KeepAttribute *attribute in self.minAttributes) attribute.min = KeepNone;
    for (KeepAttribute *attribute in self.maxAttributes) attribute.max = KeepNone;
}





@end




