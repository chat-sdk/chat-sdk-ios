//
//  GMSPlaceLikelihoodList.h
//  Google Places API for iOS
//
//  Copyright 2016 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#if __has_feature(modules)
@import GoogleMapsBase;
#else
#import <GoogleMapsBase/GoogleMapsBase.h>
#endif

GMS_ASSUME_NONNULL_BEGIN

@class GMSPlaceLikelihood;

/**
 * Represents a list of places with an associated likelihood for the place being the correct place.
 * For example, the Places service may be uncertain what the true Place is, but think it 55% likely
 * to be PlaceA, and 35% likely to be PlaceB. The corresponding likelihood list has two members, one
 * with likelihood 0.55 and the other with likelihood 0.35. The likelihoods are not guaranteed to be
 * correct, and in a given place likelihood list they may not sum to 1.0.
 */
@interface GMSPlaceLikelihoodList : NSObject

/** An array of likelihoods, sorted in descending order. */
@property(nonatomic, copy) GMS_NSArrayOf(GMSPlaceLikelihood *) *likelihoods;

/**
 * The data provider attribution strings for the likelihood list.
 *
 * These are provided as a NSAttributedString, which may contain hyperlinks to the website of each
 * provider.
 *
 * In general, these must be shown to the user if data from this likelihood list is shown, as
 * described in the Places API Terms of Service.
 */
@property(nonatomic, copy, readonly) NSAttributedString *GMS_NULLABLE_PTR attributions;

@end

GMS_ASSUME_NONNULL_END
