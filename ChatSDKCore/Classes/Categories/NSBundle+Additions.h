//
//  NSBundle+Additions.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 14/04/2017.
//
//

#import <Foundation/Foundation.h>

@interface NSBundle(Additions)

+(UIImage *) imageNamed: (NSString *) name bundle: (NSString *) bundle;
+(NSBundle *) bundleWithName: (NSString *) name;

+(NSBundle *) bundleWithFramework: (NSString *) framework name: (NSString *) name;
+(NSString *) filePathWithFramework: (NSString *) framework name: (NSString *) name;
+(UIImage *) imageNamed: (NSString *) name framework: (NSString *) framework bundle: (NSString *) bundle;

@end
