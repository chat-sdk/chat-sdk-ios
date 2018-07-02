//
//  NSMutableArray+User.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 30/08/2016.
//
//

#import "NSMutableArray+User.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

@implementation NSMutableArray(User)

- (void) sortUsersInAlphabeticalOrder {
    [self sortUsingComparator:^NSComparisonResult(id<PUser> u1, id<PUser> u2) {
        return [u1.name compare:u2.name];
    }];
}

@end
