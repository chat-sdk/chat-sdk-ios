//
//  BCoreUtilities.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 26/11/2015.
//
//

#import "BCoreUtilities.h"
//#import <DateTools.h>
#import <ChatSDK/ChatCore.h> 

@implementation BCoreUtilities

+(RXPromise *) fetchImageFromURL: (NSString *) url {
    
    RXPromise * promise = [RXPromise new];
    
    NSURL *imageUrl = [NSURL URLWithString:url];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData * imageData = [NSData dataWithContentsOfURL:imageUrl];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (imageData) {
                UIImage * image = [UIImage imageWithData:imageData];
                [promise resolveWithResult:image];
            }
            else {
                [promise resolveWithResult:Nil];
            }
        });
    });
    
    return promise;
}

+(NSString *)getUUID {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *) string;
}

+(MKCoordinateRegion) regionForLongitude: (double) longitude latitude: (double) latitude {
    return [self regionForLongitude:longitude latitude:latitude area:bLocationDefaultArea];
}

+(MKCoordinateRegion) regionForLongitude: (double) longitude latitude: (double) latitude area: (float) area {
    
    CLLocationCoordinate2D location;
    location.longitude = longitude;
    location.latitude = latitude;
    
    return MKCoordinateRegionMakeWithDistance(location, area, area);
}

+(MKPointAnnotation *) annotationForLongitude: (double) longitude latitude: (double) latitude {
    
    CLLocationCoordinate2D location;
    location.longitude = longitude;
    location.latitude = latitude;
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:location];
    return annotation;
}

+(CLLocationCoordinate2D) locationForString: (NSString *) text {
    
    NSArray * coordinates = [text componentsSeparatedByString:@","];
    
    double longitude = 0;
    double latitude = 0;
    
    if (coordinates.count >= 2) {
        
        // Location
        latitude = ((NSString *)coordinates[0]).doubleValue;
        longitude = ((NSString *)coordinates[1]).doubleValue;
        
    }
    else {
        NSLog(@"Error parsing location string: %@", text);
    }
    
    CLLocationCoordinate2D location;
    location.longitude = longitude;
    location.latitude = latitude;
    
    return location;
}

+(NSString *) timeAgo: (NSDate *) date {
    
    NSString * text = Nil;
    
    NSTimeInterval t = fabs([date timeIntervalSinceNow]);
    
    // Seconds
    if (t > 60.0) {
        t /= 60.0;
        // Minutes
        if (t > 60.0) {
            t /= 60.0;
            // Hours
            if (t > 24.0) {
                t /= 24.0;
                // Days
                if (t > 30.0) {
                    t /= 30.0;
                    // Months
                    if (t > 12.0) {
                        t /= 12.0;
                        // Years
                        if (t > 10.0) {
                            t /= 10.0;
                            text = @"decades ago";
                        }
                        else {
                            text = @"years ago";
                        }
                    }
                    else {
                        text = @"months ago";
                    }
                }
                else {
                    text = @"days ago";
                }
            }
            else {
                text = @"hours ago";
            }
        }
        else {
            text = @"minutes ago";
        }
    }
    else {
        text = @"seconds ago";
    }
    
    return [NSString stringWithFormat:@"%i %@", (int) roundf(t), text];
}



+(UIColor*)colorWithHexString:(NSString*)hex {
    return [self colorWithHexString:hex withColorWeight:1.0];
}

+(UIColor*)colorWithHexString:(NSString*)hex withColorWeight: (float) weight {
    
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // Remove starting hash if it exists
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) weight * r / 255.0f)
                           green:((float) weight * g / 255.0f)
                            blue:((float) weight * b / 255.0f)
                           alpha:1.0f];
}

+(NSString *) colorToString: (UIColor *) color {
    return [CIColor colorWithCGColor:color.CGColor].stringRepresentation;
}

+(UIColor *) stringToColor: (NSString *) color {
    
    NSArray * colorParts = [color componentsSeparatedByString: @" "];
    CGFloat red = [[colorParts objectAtIndex:0] floatValue];
    CGFloat green = [[colorParts objectAtIndex:1] floatValue];
    CGFloat blue = [[colorParts objectAtIndex:2] floatValue];
    CGFloat alpha = [[colorParts objectAtIndex:3] floatValue];
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
}

//+(RXPromise *) getWithPath: (NSString *) path parameters: (NSDictionary *) params {
//    
//    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
//    //manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
//    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html"]];
//    
//    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
//    manager.responseSerializer = responseSerializer;
//    
//    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    RXPromise * promise = [RXPromise new];
//    
//    [manager GET:path parameters:params success:^(AFHTTPRequestOperation * operation, id responseObject) {
//        
//        if (![responseObject isEqual: [NSNull null]]) {
//            
//            if(responseObject[@"error"]) {
//                NSError * error = [NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey: responseObject[@"error"]}];
//                [promise rejectWithReason:error];
//            }
//            else {
//                [promise resolveWithResult:responseObject];
//            }
//        }
//        else {
//            [promise resolveWithResult:nil];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [promise rejectWithReason:error];
//    }];
//    
//    return promise;
//}

+(RXPromise *) getWithPath: (NSString *) path parameters: (NSDictionary *) params {
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    //manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html"]];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer = responseSerializer;
    
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    RXPromise * promise = [RXPromise new];
    
    [manager GET:path parameters:params success:^(NSURLSessionTask * task, id responseObject) {
        
        if (![responseObject isEqual: [NSNull null]]) {
            
            if(responseObject[@"error"]) {
                NSError * error = [NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey: responseObject[@"error"]}];
                [promise rejectWithReason:error];
            }
            else {
                [promise resolveWithResult:responseObject];
            }
        }
        else {
            [promise resolveWithResult:nil];
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        [promise rejectWithReason:error];
    }];
    
    return promise;
}



@end
