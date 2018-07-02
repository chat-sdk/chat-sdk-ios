//
//  NSBundle+Additions.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 14/04/2017.
//
//

#import "NSBundle+Additions.h"

@implementation NSBundle(Additions)

+(UIImage *) imageNamed: (NSString *) name bundle: (NSString *) bundle {
    // Try to find it in the main budle first
    UIImage * image = [UIImage imageNamed:name];
    if(image) {
        return image;
    }
    NSString * path = [NSString stringWithFormat:@"%@.bundle/%@", bundle, name];
//    NSString * path = [NSString stringWithFormat:@"Frameworks/%@.framework/%@.bundle/%@", framework, bundle, name];
    return [UIImage imageNamed:path];
}

+(NSBundle *) bundleWithName: (NSString *) name {
    return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:name ofType:@"bundle"]];
}

+(NSBundle *) bundleWithFramework: (NSString *) framework name: (NSString *) name {
    NSString * path = [self filePathWithFramework:framework name:name];
    return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:path ofType:@"bundle"]];
}

+(NSString *) filePathWithFramework: (NSString *) framework name: (NSString *) name {
    return [NSString stringWithFormat:@"Frameworks/%@.framework/%@", framework, name];
}

+(UIImage *) imageNamed: (NSString *) name framework: (NSString *) framework bundle: (NSString *) bundle {
    // Try to find it in the main budle first
    UIImage * image = [UIImage imageNamed:name];
    if(image) {
        return image;
    }
    
    NSString * path = [NSString stringWithFormat:@"Frameworks/%@.framework/%@.bundle/%@", framework, bundle, name];
    return [UIImage imageNamed:path];
}

@end
