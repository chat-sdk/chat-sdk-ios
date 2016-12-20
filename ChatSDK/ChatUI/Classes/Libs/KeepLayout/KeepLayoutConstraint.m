//
//  KeepLayoutConstraint.m
//  Keep Layout
//
//  Created by Martin Kiss on 18.7.13.
//  Copyright (c) 2013 Martin Kiss. All rights reserved.
//

#import "KeepLayoutConstraint.h"

@implementation KeepLayoutConstraint


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
    if (self.name) {
        return [NSString stringWithFormat: @"<%@:%p %@>", self.class, self, self.name];
    }
    else {
        return [super description];
    }
}


@end
