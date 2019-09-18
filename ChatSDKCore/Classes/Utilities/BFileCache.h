//
//  BFileCache.h
//  ChatSDK
//
//  Created by Pepe Becker on 22.04.18.
//

#import <Foundation/Foundation.h>

@class RXPromise;

@interface BFileCache : NSObject

+ (BOOL)isFileCached:(NSString *)cacheName;
+ (RXPromise *)cacheFileFromURL:(NSURL *)url withFileName:(NSString *)fileName andCacheName:(NSString *)cacheName;
+ (RXPromise *)cacheFileFromURL:(NSURL *)url withFileName:(NSString *)fileName;
+ (RXPromise *)cacheFileFromURL:(NSURL *)url;

@end
