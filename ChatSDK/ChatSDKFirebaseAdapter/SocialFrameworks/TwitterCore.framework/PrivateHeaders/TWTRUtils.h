//
//  TWTRUtils.h
//  TWTRAuthentication
//
//  Created by Mustafa Furniturewala on 2/6/14.
//  Copyright (c) 2014 Mustafa Furniturewala. All rights reserved.
//

#if IS_UIKIT_AVAILABLE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

@interface TWTRUtils : NSObject

+ (NSDictionary *)dictionaryWithQueryString:(NSString *)queryString;
+ (NSString *)queryStringFromDictionary:(NSDictionary *)dictionary;
+ (NSString *)urlEncodedStringForString:(NSString *)inputString;
+ (NSString *)urlDecodedStringForString:(NSString *)inputString;
+ (NSString *)base64EncodedStringWithData:(NSData *)data;
#if IS_UIKIT_AVAILABLE
+ (UIViewController *)topViewController;
#endif
+ (NSString *)localizedLongAppName;
+ (NSString *)localizedShortAppName;

/**
 * Returns YES if both objects are nil or if obj.
 */
+ (BOOL)isEqualOrBothNil:(NSObject *)obj other:(NSObject *)otherObj;

@end
