//
//  BGoogleUtils.m
//  AFNetworking
//
//  Created by ben3 on 20/05/2019.
//

#import "BGoogleUtils.h"

#import <ChatSDK/Core.h>

@implementation BGoogleUtils

+(NSString *) getMapImageURL: (double) latitude longitude: (double) longitude width: (int) width height: (int) height {
    NSString * googleMapsApiKey = BChatSDK.config.googleMapsApiKey;
    
    NSString * api = @"https://maps.googleapis.com/maps/api/staticmap";
    NSString * markers = [NSString stringWithFormat:@"markers=%f,%f", latitude, longitude];
    NSString * size = [NSString stringWithFormat:@"zoom=18&size=%ix%i", width, height];
    NSString * key = [NSString stringWithFormat:@"key=%@", googleMapsApiKey];
    
    return [NSString stringWithFormat:@"%@?%@&%@&%@", api, markers, size, key];
}

+(NSString *) getMapImageWebLink: (double) latitude longitude: (double) longitude {
    return [NSString stringWithFormat:@"http://maps.google.com/maps?z=12&t=m&q=loc:%f+%f", latitude, longitude];
}

@end
