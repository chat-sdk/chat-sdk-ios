//
//  NSObject+AssociatedObject.m
//  Pods
//
//  Created by Simon Smiley-Andrews on 24/03/2016.
//
//

#import "NSObject+AssociatedObject.h"
#import <objc/runtime.h>

@implementation NSObject (AssociatedObject)

- (void)setAssociatedObject:(id)object key: (NSString *) key {
    objc_setAssociatedObject(self, (__bridge const void *)(key), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)associatedObjectWithKey: (NSString *) key {
    return objc_getAssociatedObject(self, (__bridge const void *)(key));
}

@end