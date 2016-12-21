//
//  RXPromise+Additions.m
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 29/07/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import "RXPromise+Additions.h"

@implementation RXPromise(Additions)

+(RXPromise *) rejectWithReasonDomain: (NSString *) domain code: (int) code description: (NSString *) description {
    NSError * error = [NSError errorWithDomain:domain code:code userInfo:@{NSLocalizedDescriptionKey: description}];
    return [self rejectWithReason:error];
}

+(RXPromise *) rejectWithReason: (NSError *) error {
    RXPromise * promise = [RXPromise new];
    [promise rejectWithReason:error];
    return promise;
}

+(RXPromise *) resolveWithResult: (id) result {
    RXPromise * promise = [RXPromise new];
    [promise resolveWithResult:result];
    return promise;
}

@end
