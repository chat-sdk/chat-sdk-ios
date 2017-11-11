//
//  BChatSDK.h
//  AFNetworking
//
//  Created by Ben on 11/7/17.
//

#import <Foundation/Foundation.h>

@class BConfiguration;

@interface BChatSDK : NSObject {
    BConfiguration * _configuration;
}

@property (nonatomic, readonly) BConfiguration * configuration;

+(BChatSDK *) shared;
+(void) initialize: (BConfiguration *) config;

@end
