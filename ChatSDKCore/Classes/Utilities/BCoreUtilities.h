//
//  BCoreUtilities.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 26/11/2015.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class RXPromise;

#define bMinutes 60.0
#define bHours (60.0 * bMinutes)
#define bDays (24.0 * bHours)
#define bMonths (30.0 * bDays)
#define bYears (12.0 * bMonths)

@interface BCoreUtilities : NSObject

+(NSURL *)getDocumentsURL;
+(RXPromise *)fetchImageFromURL:(NSURL *)url;
+(NSString *)getUUID;

+(MKCoordinateRegion) regionForLongitude: (double) longitude latitude: (double) latitude;
+(MKPointAnnotation *) annotationForLongitude: (double) longitude latitude: (double) latitude;

//+(NSString *) timeAgo: (NSDate *) date;

+(UIColor*)colorWithHexString:(NSString*)hex;
+(UIColor*)colorWithHexString:(NSString*)hex withColorWeight: (float) weight;
+(NSString *) colorToString: (UIColor *) color;
+(UIColor *) stringToColor: (NSString *) color;

+(RXPromise *) getWithPath: (NSString *) path parameters: (NSDictionary *) params;

@end
