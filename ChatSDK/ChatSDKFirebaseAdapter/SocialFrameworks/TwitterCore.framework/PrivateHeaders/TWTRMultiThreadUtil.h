//
//  TWTRMultiThreadUtil.h
//  TwitterKit
//
//  Created by Kang Chen on 3/16/15.
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWTRMultiThreadUtil : NSObject

/**
 *  Checks that this method was called from a main thread.
 *  Call this method from common methods in the public API of this class to catch the most obvious issues.
 */
+ (void)assertMainThread;

/**
 *  Warns the user that a method was invoked from a background thread, which is not supported.
 *  On debug builds this throws an exception, on release builds it logs to the console.
 */
+ (void)warnForBackgroundThreadUsage;

@end
