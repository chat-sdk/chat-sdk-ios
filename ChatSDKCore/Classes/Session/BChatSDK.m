//
//  BChatSDK.m
//  AFNetworking
//
//  Created by Ben on 11/7/17.
//

#import "BChatSDK.h"
#import "BConfiguration.h"

@implementation BChatSDK

@synthesize configuration = _configuration;

static BChatSDK * instance;

+(BChatSDK *) shared {
    
    @synchronized(self) {
        
        // If the sharedSoundManager var is nil then we need to allocate it.
        if(instance == nil) {
            // Allocate and initialize an instance of this class
            instance = [[self alloc] init];
        }
    }
    return instance;
}

+(void) initialize: (BConfiguration *) config {
    [self shared]->_configuration = config;
}

// If the configuration isn't set, return a default value
-(BConfiguration *) configuration {
    if(!_configuration) {
        _configuration = [BConfiguration configuration];
    }
    return _configuration;
}

@end
