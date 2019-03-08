//
//  BProfilePicturesHelper.m
//  ChatSDK
//
//  Created by Pepe Becker on 11/02/2019.
//

#import "BProfilePicturesHelper.h"

@implementation BProfilePicturesHelper

+ (NSArray<NSString *> *)nonnullPictures:(NSArray<NSString *> *)pictures {
    return [pictures filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString * value, id bindings) {
        return value.length > 0;
    }]];
}

+ (NSArray<NSString *> *)fillPictures:(NSArray<NSString *> *)pictures withCount:(NSUInteger)count {
    NSMutableArray<NSString *> * mutablePictures = [pictures mutableCopy];
    NSUInteger picturesToAdd = MIN(0, count - pictures.count);
    if (picturesToAdd <= 0) return mutablePictures;
    for (int i = 0; i < picturesToAdd; i++) {
        [mutablePictures addObject:@""];
    }
    return mutablePictures;
}

+ (int)indexForPicture:(NSString *)url inPictures:(NSArray<NSString *> *)pictures {
    for (int i = 0; i < pictures.count; i++) {
        if ([[pictures[i] lowercaseString] isEqual:[url lowercaseString]]) {
            return i;
        }
    }
    return -1;
}

+ (NSArray< NSString *> *)removePicture:(NSString *)url fromPictures:(NSArray<NSString *> *)pictures {
    if (!url || url.length == 0) return pictures;
    NSMutableArray<NSString *> * mutablePictures = [pictures mutableCopy];
    int index = [self indexForPicture:url inPictures:mutablePictures];
    if (index < 0) return mutablePictures;
    [mutablePictures removeObjectAtIndex:index];
    [mutablePictures addObject:@""];
    return mutablePictures;
}

+ (NSArray<NSString *> *)addPicture:(NSString *)url toPictures:(NSArray<NSString *> *)pictures {
    if (!url || url.length == 0) return pictures;
    NSUInteger picturesCount = pictures.count;
    NSMutableArray<NSString *> * mutablePictures = [[self nonnullPictures:pictures] mutableCopy];
    int index = [self indexForPicture:url inPictures:mutablePictures];
    if (index >= 0) return mutablePictures;
    [mutablePictures addObject:url];
    return [self fillPictures:mutablePictures withCount:picturesCount];
}

+ (NSArray<NSString *> *)setDefaultPicture:(NSString *)url inPictures:(NSArray<NSString *> *)pictures {
    if (!url || url.length == 0) return pictures;
    NSUInteger picturesCount = pictures.count;
    NSArray<NSString *> * nonnullPictures = [self nonnullPictures:pictures];
    NSMutableArray<NSString *> * mutablePictures = [[self removePicture:url fromPictures:nonnullPictures] mutableCopy];
    [mutablePictures insertObject:url atIndex:0];
    return [self fillPictures:mutablePictures withCount:picturesCount];
}

@end
