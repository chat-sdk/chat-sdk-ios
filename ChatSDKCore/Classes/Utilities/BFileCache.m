//
//  BFileCache.m
//  ChatSDK
//
//  Created by Pepe Becker on 22.04.18.
//

#import "BFileCache.h"
#import <ChatSDK/Core.h>

@implementation BFileCache

+ (BOOL)isFileCached:(NSString *)cacheName {
    if (cacheName == nil) return NO;
    return [[NSUserDefaults standardUserDefaults] URLForKey:cacheName] != nil;
}

+ (RXPromise *)cacheFileFromURL:(NSURL *)url withFileName:(NSString *)fileName andCacheName:(NSString *)cacheName {
    RXPromise * promise = [RXPromise new];
    __block NSURL * cacheURL = [[NSUserDefaults standardUserDefaults] URLForKey:cacheName];
    if (cacheURL) {
        [promise resolveWithResult:cacheURL];
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self createDirectoryWthName:cacheName].then(^id(NSURL * dirURL) {
                cacheURL = [dirURL URLByAppendingPathComponent:fileName];
                NSData * data = [NSData dataWithContentsOfURL:url];
                NSError * error = nil;
                BOOL success = [data writeToURL:cacheURL options:NSDataWritingFileProtectionComplete error:&error];
                if (success) {
                    [[NSUserDefaults standardUserDefaults] setURL:cacheURL forKey:cacheName];
                    [promise resolveWithResult:cacheURL];
                } else {
                    [promise rejectWithReason:error];
                }
                return nil;
            }, ^id(NSError *error) {
                [promise rejectWithReason:error];
                return nil;
            });
        });
    }
    return promise;
}

+ (RXPromise *)cacheFileFromURL:(NSURL *)url withFileName:(NSString *)fileName {
    return [self cacheFileFromURL:url withFileName:fileName andCacheName:[BCoreUtilities getUUID]];
}

+ (RXPromise *)cacheFileFromURL:(NSURL *)url {
    return [self cacheFileFromURL:url withFileName:[url.path lastPathComponent]];
}

+ (RXPromise *)createDirectoryWthName:(NSString *)name {
    RXPromise * promise = [RXPromise new];
    NSURL * url = [[BCoreUtilities getDocumentsURL] URLByAppendingPathComponent:name];
    NSError * error = nil;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:[url path] withIntermediateDirectories:YES attributes:nil error:&error];
    if (success) {
        [promise resolveWithResult:url];
    } else {
        [promise rejectWithReason:error];
    }
    return promise;
}

@end
