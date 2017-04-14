//
//  NSBundle+Additions.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 14/04/2017.
//
//

#import <Foundation/Foundation.h>

@interface NSBundle(Additions)

+(UIImage *) imageNamed: (NSString *) name framework: (NSString *) framework bundle: (NSString *) bundle;
+(NSBundle *) bundleWithFramework: (NSString *) framework name: (NSString *) name;

@end
