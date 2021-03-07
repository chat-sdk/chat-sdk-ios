//
//  BCoreUtilities.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 26/11/2015.
//
//

#import "BCoreUtilities.h"
//#import <DateTools.h>
#import <ChatSDK/Core.h>
#import <CommonCrypto/CommonDigest.h>

@implementation BCoreUtilities

+ (NSURL *)getDocumentsURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
//    return [NSURL URLWithString:[NSHomeDirectory() stringByAppendingString:@"/Documents/"]];
}

+(RXPromise *) fetchImageFromURL:(NSURL *)url {
    return [BFileCache cacheFileFromURL:url].then(^id(NSURL * cacheURL) {
        NSData * data = [NSData dataWithContentsOfURL:cacheURL];
        RXPromise * promise = [RXPromise new];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                [promise resolveWithResult:[UIImage imageWithData:data]];
            } else {
                [promise rejectWithReason:nil];
            }
        });
        return promise;
    }, nil);
}

+(nonnull NSString *)getUUID {
    return [[NSUUID UUID] UUIDString];
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

+(UIColor*)colorWithHexString:(NSString*)hex {
    
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
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
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
    
    AFHTTPSessionManager * manager = [self manager];
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

+ (AFHTTPSessionManager*) manager
{
    static dispatch_once_t onceToken;
    static AFHTTPSessionManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
    });
    
    return manager;
}

+(void) checkOnMain {
    if ([[NSThread currentThread] isEqual:[NSThread mainThread]]) {
        [BChatSDK.shared.logger log: @"On Main Thread"];
    } else {
        [BChatSDK.shared.logger log: @"On Background Thread"];
    }
}

+(void) checkDuplicateThread {
    NSArray * threads = [BChatSDK.db fetchEntitiesWithName:bThreadEntity];
    for(id o1 in threads) {
        for(id o2 in threads) {
            if (![o1 isEqual:o2]) {
                id<PThread> t1 = (id<PThread>) o1;
                id<PThread> t2 = (id<PThread>) o2;
                if ([t1.entityID isEqual:t2.entityID]) {
                    [BChatSDK.shared.logger log: @"Duplicate thread"];
                }
            }
        }
    }
}

+(NSString *)md5: (NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );

    return [NSString stringWithFormat:
        @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
        result[0], result[1], result[2], result[3],
        result[4], result[5], result[6], result[7],
        result[8], result[9], result[10], result[11],
        result[12], result[13], result[14], result[15]
    ];
}
@end
