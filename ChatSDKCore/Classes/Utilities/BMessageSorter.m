//
//  BMessageSorter.m
//  AFNetworking
//
//  Created by ben3 on 13/05/2019.
//

#import "BMessageSorter.h"
#import <ChatSDK/Core.h>

@implementation BMessageSorter

+(NSComparator) newestFirst {
    return ^NSComparisonResult(id<PMessage> m1, id<PMessage> m2) {
        return [m2.date compare:m1.date];
    };
}

+(NSComparator) oldestFirst {
    return ^NSComparisonResult(id<PMessage> m1, id<PMessage> m2) {
        return [m1.date compare:m2.date];
    };
}

@end
