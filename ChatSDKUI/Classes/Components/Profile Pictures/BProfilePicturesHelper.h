//
//  BProfilePicturesHelper.h
//  ChatSDK
//
//  Created by Pepe Becker on 11/02/2019.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BProfilePicturesHelper : NSObject

+ (NSArray<NSString *> *)nonnullPictures:(NSArray<NSString *> *)pictures;
+ (NSArray<NSString *> *)fillPictures:(NSArray<NSString *> *)pictures withCount:(NSUInteger)count;
+ (int)indexForPicture:(NSString *)url inPictures:(NSArray<NSString *> *)pictures;
+ (NSArray<NSString *> *)removePicture:(NSString *)url fromPictures:(NSArray<NSString *> *)pictures;
+ (NSArray<NSString *> *)addPicture:(NSString *)url toPictures:(NSArray<NSString *> *)pictures;
+ (NSArray<NSString *> *)setDefaultPicture:(NSString *)url inPictures:(NSArray<NSString *> *)pictures;

@end

NS_ASSUME_NONNULL_END
