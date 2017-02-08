//
//  GMSPanoramaLink.h
//  Google Maps SDK for iOS
//
//  Copyright 2013 Google Inc.
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

/** Links from a GMSPanorama to neighboring panoramas. */
@interface GMSPanoramaLink : NSObject

/** Angle of the neighboring panorama, clockwise from north in degrees. */
@property(nonatomic, assign) CGFloat heading;

/**
 * Panorama ID for the neighboring panorama.
 * Do not store this persistenly, it changes in time.
 */
@property(nonatomic, copy) NSString *panoramaID;

@end

GMS_ASSUME_NONNULL_END
