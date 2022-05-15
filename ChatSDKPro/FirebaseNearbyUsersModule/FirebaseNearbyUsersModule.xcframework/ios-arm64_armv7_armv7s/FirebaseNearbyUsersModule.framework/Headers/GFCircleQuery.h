//
//  GFCircleQuery.h
//  GeoFire
//
//  Created by Jonny Dimond on 7/11/14.
//  Copyright (c) 2016 Firebase. All rights reserved.
//

@interface GFCircleQuery : GFQuery

/**
 * The center of the search area. Update this value to update the query. Events are triggered for any keys that move
 * in or out of the search area.
 */
@property (atomic, readwrite) CLLocation *center;

/**
 * The radius of the geo query in kilometers. Update this value to update the query. Events are triggered for any keys
 * that move in or out of the search area.
 */
@property (atomic, readwrite) double radius;

@end
