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

- (void) sortAlphabetical {
    [self sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        id<PUser> u1 = obj1, u2 = obj2;
        if ([obj1 respondsToSelector:@selector(user)]) {
            u1 = [obj1 user];
        }
        if ([obj2 respondsToSelector:@selector(user)]) {
            u2 = [obj2 user];
        }
        return [u1.name caseInsensitiveCompare:u2.name];
    }];
}

-(void) sortOnlineThenAlphabetical {
    [self sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        id<PUser> u1 = obj1, u2 = obj2;
        if ([obj1 respondsToSelector:@selector(user)]) {
            u1 = [obj1 user];
        }
        if ([obj2 respondsToSelector:@selector(user)]) {
            u2 = [obj2 user];
        }
        if (u1.online.boolValue != u2.online.boolValue) {
            return !u1.online.boolValue ? NSOrderedDescending : NSOrderedAscending;
        }
        else {
            return [u1.name compare:u2.name];
        }
    }];
}

@end
