//
//  GMSPlacePhotoMetadataList.h
//  Google Places API for iOS
//
//  Copyright 2016 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <UIKit/UIKit.h>

#if __has_feature(modules)
@import GoogleMapsBase;
#else
#import <GoogleMapsBase/GoogleMapsBase.h>
#endif
#import <GooglePlaces/GMSPlacePhotoMetadata.h>

GMS_ASSUME_NONNULL_BEGIN

/**
 * A list of |GMSPlacePhotoMetadata| objects.
 */
@interface GMSPlacePhotoMetadataList : NSObject

/**
 * The array of |GMSPlacePhotoMetadata| objects.
 */
@property(nonatomic, readonly, copy) GMS_NSArrayOf(GMSPlacePhotoMetadata *) * results;

@end

GMS_ASSUME_NONNULL_END
