//
//  BMessageSorter.h
//  AFNetworking
//
//  Created by ben3 on 13/05/2019.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMessageSorter : NSObject

+(NSComparator) newestFirst;
+(NSComparator) oldestFirst;

@end

NS_ASSUME_NONNULL_END
