//
//  GMSIndoorLevel.h
//  Google Maps SDK for iOS
//
//  Copyright 2013 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//


#import <Foundation/Foundation.h>

#if __has_feature(modules)
@import GoogleMapsBase;
#else
#import <GoogleMapsBase/GoogleMapsBase.h>
#endif

GMS_ASSUME_NONNULL_BEGIN

/**
 * Describes a single level in a building.
 * Multiple buildings can share a level - in this case the level instances will
 * compare as equal, even though the level numbers/names may be different.
 */
@interface GMSIndoorLevel : NSObject

/** Localized display name for the level, e.g. "Ground floor". */
@property(nonatomic, copy, readonly) NSString *GMS_NULLABLE_PTR name;

/** Localized short display name for the level, e.g. "1". */
@property(nonatomic, copy, readonly) NSString *GMS_NULLABLE_PTR shortName;

@end

GMS_ASSUME_NONNULL_END
