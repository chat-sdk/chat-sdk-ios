//
//  TWTRAssertionMacros.h
//  TwitterKit
//
//  Created by Kang Chen on 3/5/15.
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <TwitterCore/TWTRConstants.h>

#ifdef __OBJC__

#define TWTRParameterAssertSettingError(condition, errorPointer)                                                                                                                                                 \
    NSParameterAssert((condition));                                                                                                                                                                              \
    if (!(condition)) {                                                                                                                                                                                          \
        NSLog(@"[TwitterKit] %@ Invalid parameter not satisfying: %s", NSStringFromSelector(_cmd), #condition);                                                                                                  \
        if (errorPointer != NULL) {                                                                                                                                                                              \
            *errorPointer = [NSError errorWithDomain:TWTRErrorDomain code:TWTRErrorCodeMissingParameter userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Missing parameter %s", #condition]}]; \
        }                                                                                                                                                                                                        \
    }

#define TWTRParameterAssertOrReturnValue(condition, returnValue)                                                \
    NSParameterAssert((condition));                                                                             \
    if (!(condition)) {                                                                                         \
        NSLog(@"[TwitterKit] %@ Invalid parameter not satisfying: %s", NSStringFromSelector(_cmd), #condition); \
        return returnValue;                                                                                     \
    }

#define TWTRParameterAssertOrReturnNil(condition)                                                               \
    NSParameterAssert((condition));                                                                             \
    if (!(condition)) {                                                                                         \
        NSLog(@"[TwitterKit] %@ Invalid parameter not satisfying: %s", NSStringFromSelector(_cmd), #condition); \
        return nil;                                                                                             \
    }

#define TWTRParameterAssertOrReturn(condition)                                                                  \
    NSParameterAssert((condition));                                                                             \
    if (!(condition)) {                                                                                         \
        NSLog(@"[TwitterKit] %@ Invalid parameter not satisfying: %s", NSStringFromSelector(_cmd), #condition); \
        return;                                                                                                 \
    }

#define TWTRAssertMainThread()                                                                         \
    if (![NSThread isMainThread]) {                                                                    \
        [NSException raise:NSInternalInconsistencyException format:@"Need to be on the main thread."]; \
        return;                                                                                        \
    }

// Check a single argument, and call a completion block if it's missing
#define TWTRCheckArgumentWithCompletion(condition, completion)     \
    TWTRParameterAssertOrReturn(completion);                       \
    NSError *parameterError;                                       \
    TWTRParameterAssertSettingError((condition), &parameterError); \
    if (parameterError) {                                          \
        completion(nil, nil, parameterError);                      \
        return;                                                    \
    }

#define TWTRCheckArgumentWithCompletion2(condition, completion)    \
    TWTRParameterAssertOrReturn(completion);                       \
    NSError *parameterError;                                       \
    TWTRParameterAssertSettingError((condition), &parameterError); \
    if (parameterError) {                                          \
        completion(nil, parameterError);                           \
        return;                                                    \
    }

#endif
