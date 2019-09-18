//
//  PGeoItem.h
//  Pods
//
//  Created by Benjamin Smiley-Andrews on 08/04/2019.
//

#ifndef PGeoItem_h
#define PGeoItem_h

@class CLLocation;

@protocol PGeoItem <NSObject>

-(NSString *) entityID;
-(NSString *) type;
-(CLLocation *) location;

@end

#endif /* PGeoItem_h */
