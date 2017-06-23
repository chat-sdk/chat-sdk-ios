//
//  TWTRDictUtil.h
//
//  Created by Jacob Harding on 5/29/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWTRDictUtil : NSObject

+ (CGFloat)CGFloatForKey:(NSString *)key fromDict:(NSDictionary *)dict;
+ (double)doubleForKey:(NSString *)key fromDict:(NSDictionary *)dict;
+ (BOOL)boolForKey:(NSString *)key fromDict:(NSDictionary *)dict;
+ (NSInteger)intForKey:(NSString *)key fromDict:(NSDictionary *)dict;
+ (long long)longlongForKey:(NSString *)key fromDict:(NSDictionary *)dict;
+ (NSUInteger)unsignedIntegerForKey:(NSString *)key fromDict:(NSDictionary *)dict;
+ (NSString *)stringFromNumberForKey:(NSString *)key fromDict:(NSDictionary *)dict;
+ (id)objectForKey:(NSString *)key fromDict:(NSDictionary *)dict;
+ (NSString *)stringForKey:(NSString *)key fromDict:(NSDictionary *)dict;
+ (NSDate *)dateForKey:(NSString *)key fromDict:(NSDictionary *)dict;
+ (NSDictionary *)dictForKey:(NSString *)key fromDict:(NSDictionary *)dict;
+ (NSArray *)arrayForKey:(NSString *)key fromDict:(NSDictionary *)dict;

@end

@interface TWTRArrayUtil : NSObject

/**
 * Returns a CGFloat at the given index. This method does not check bounds.
 */
+ (CGFloat)CGFloatAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
