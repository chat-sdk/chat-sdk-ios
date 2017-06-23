//
//  TWTRNetworking.h
//  TWTRNetworking
//
//  Created by Mustafa Furniturewala on 4/7/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TWTRAuthConfig;
/**
 *  Completion block called when the network request succeeds or fails.
 *
 *  @param response        Metadata associated with the response to a URL load request.
 *  @param data            Content data of the response.
 *  @param connectionError Error object describing the network error that occurred.
 */
typedef void (^TWTRTwitterNetworkCompletion)(NSURLResponse *response, NSData *data, NSError *connectionError);

@interface TwitterNetworking : NSObject

@property (nonatomic, readonly) TWTRAuthConfig *authConfig;

- (instancetype)init __unavailable;
- (instancetype)initWithAuthConfig:(TWTRAuthConfig *)authConfig;

- (NSURLRequest *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters;
- (NSURLRequest *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters;
- (NSURLRequest *)DELETE:(NSString *)URLString parameters:(NSDictionary *)parameters;

- (NSURLRequest *)URLRequestWithMethod:(NSString *)method URL:(NSString *)URLString parameters:(NSDictionary *)parameters;

- (void)sendAsynchronousRequest:(NSURLRequest *)request completion:(TWTRTwitterNetworkCompletion)completion;

@end
