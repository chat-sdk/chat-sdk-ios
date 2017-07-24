//
//  TWTRAPIServiceConfigRegistry.h
//  TwitterCore
//
//  Created by Chase Latta on 8/18/15.
//  Copyright (c) 2015 Twitter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWTRAPIServiceConfig.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TWTRAPIServiceConfigType) { TWTRAPIServiceConfigTypeDefault, TWTRAPIServiceConfigTypeCards, TWTRAPIServiceConfigTypeUpload };

@interface TWTRAPIServiceConfigRegistry : NSObject

/**
 * Returns the default registry instance.
 */
+ (instancetype)defaultRegistry;

/**
 * Registers a service config with the receiver.
 *
 * @param config the config object to register.
 * @param type the type of config object to register.
 */
- (void)registerServiceConfig:(id<TWTRAPIServiceConfig>)config forType:(TWTRAPIServiceConfigType)type;

/**
 * Returns a config object that has been registered for the given type or nil if nothing has been registered.
 */
- (nullable id<TWTRAPIServiceConfig>)configForType:(TWTRAPIServiceConfigType)type;

@end

NS_ASSUME_NONNULL_END
