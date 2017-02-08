//
//  GMSCompatabilityMacros.h
//  Google Maps SDK for iOS
//
//  Copyright 2015 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <Foundation/Foundation.h>

#if !__has_feature(nullability) || !defined(NS_ASSUME_NONNULL_BEGIN) || \
    !defined(NS_ASSUME_NONNULL_END)
#define GMS_ASSUME_NONNULL_BEGIN
#define GMS_ASSUME_NONNULL_END
#define GMS_NULLABLE
#define GMS_NULLABLE_PTR
#define GMS_NULLABLE_INSTANCETYPE instancetype
#else
#define GMS_ASSUME_NONNULL_BEGIN NS_ASSUME_NONNULL_BEGIN
#define GMS_ASSUME_NONNULL_END NS_ASSUME_NONNULL_END
#define GMS_NULLABLE nullable
#define GMS_NULLABLE_PTR __nullable
#define GMS_NULLABLE_INSTANCETYPE nullable instancetype
#endif

#if __has_feature(objc_generics) && defined(__IPHONE_9_0) && \
    __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
#define GMS_DECLARE_GENERICS 1
#else
#define GMS_DECLARE_GENERICS 0
#endif

#if GMS_DECLARE_GENERICS
#define GMS_NSArrayOf(value) NSArray<value>
#define GMS_NSDictionaryOf(key, value) NSDictionary<key, value>
#define GMS_NSSetOf(value) NSSet<value>
#else
#define GMS_NSArrayOf(value) NSArray
#define GMS_NSDictionaryOf(key, value) NSDictionary
#define GMS_NSSetOf(value) NSSet
#endif
