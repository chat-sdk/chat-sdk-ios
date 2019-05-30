//
//  NSString+Safe.h
//  AFNetworking
//
//  Created by ben3 on 29/04/2019.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString(Safe)

+(NSString *) safe: (NSString *) string;

@end

NS_ASSUME_NONNULL_END
