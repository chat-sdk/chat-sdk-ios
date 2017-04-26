//
//  NSBundle+Additions.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 14/04/2017.
//
//

#import "NSBundle+Additions.h"

@implementation NSBundle(Additions)

+(UIImage *) imageNamed: (NSString *) name framework: (NSString *) framework bundle: (NSString *) bundle {
    NSString * path = [NSString stringWithFormat:@"Frameworks/%@.framework/%@.bundle/%@", framework, bundle, name];
    return [UIImage imageNamed:path];
}

+(NSBundle *) bundleWithFramework: (NSString *) framework name: (NSString *) name {
    NSString * path = [NSString stringWithFormat:@"Frameworks/%@.framework/%@", framework, name];
    return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:path ofType:@"bundle"]];
}

@end
