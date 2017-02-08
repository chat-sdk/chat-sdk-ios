//
//  GMSSyncTileLayer.h
//  Google Maps SDK for iOS
//
//  Copyright 2013 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <GoogleMaps/GMSTileLayer.h>

#if __has_feature(modules)
@import GoogleMapsBase;
#else
#import <GoogleMapsBase/GoogleMapsBase.h>
#endif

GMS_ASSUME_NONNULL_BEGIN

/**
 * GMSSyncTileLayer is an abstract subclass of GMSTileLayer that provides a sync
 * interface to generate image tile data.
 */
@interface GMSSyncTileLayer : GMSTileLayer

/**
 * As per requestTileForX:y:zoom:receiver: on GMSTileLayer, but provides a
 * synchronous interface to return tiles. This method may block or otherwise
 * perform work, and is not called on the main thread.
 *
 * Calls to this method may also be made from multiple threads so
 * implementations must be threadsafe.
 */
- (UIImage *GMS_NULLABLE_PTR)tileForX:(NSUInteger)x y:(NSUInteger)y zoom:(NSUInteger)zoom;

@end

GMS_ASSUME_NONNULL_END
