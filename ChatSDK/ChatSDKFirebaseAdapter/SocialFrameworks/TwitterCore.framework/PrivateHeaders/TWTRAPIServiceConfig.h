//
//  TWTRAPIServiceConfig.h
//  TwitterCore
//
//  Copyright (c) 2015 Twitter Inc. All rights reserved.
//

@protocol TWTRAPIServiceConfig <NSObject>

@property (nonatomic, readonly, copy) NSString *apiHost;
@property (nonatomic, readonly, copy) NSString *apiScheme;

/**
 * A unique name to assign to this service. It is recommended
 * that reverse dns be used to make the name unique.
 */
@property (nonatomic, readonly, copy) NSString *serviceName;

@end

FOUNDATION_EXPORT NSURL *TWTRAPIURLWithPath(id<TWTRAPIServiceConfig> apiServiceConfig, NSString *path);

FOUNDATION_EXPORT NSURL *TWTRAPIURLWithParams(id<TWTRAPIServiceConfig> apiServiceConfig, NSString *path, NSDictionary *params);
