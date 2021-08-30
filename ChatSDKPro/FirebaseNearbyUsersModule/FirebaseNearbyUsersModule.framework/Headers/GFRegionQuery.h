
//
//  GFRegionQuery.h
//  GeoFire
//
//  Created by Jonny Dimond on 7/11/14.
//  Copyright (c) 2016 Firebase. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface GFRegionQuery : GFQuery

/**
 * The region to search for this query. Update this value to update the query. Events are triggered for any keys that
 * move in or out of the search area.
 */
@property (atomic, readwrite) MKCoordinateRegion region;

@end
