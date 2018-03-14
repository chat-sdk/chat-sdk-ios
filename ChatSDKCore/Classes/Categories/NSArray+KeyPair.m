//
//  BSearchIndex.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 08/08/2016.
//
//

#import "NSArray+KeyPair.h"

@implementation NSArray(KeyPair)

+(instancetype) keyPair:(NSString *)key value:(NSString *)value {
    if (key && value) {
        return @[key, value];
    }
    return Nil;
}

+(instancetype) keyPair:(NSString *)key value:(NSString *)value required: (BOOL) required {
    if (key && value) {
        return @[key, value, @(required)];
    }
    return Nil;
}

-(NSString *) key {
    if(self.count >= 1) {
        return self[0];
    }
    return Nil;
}

-(NSString *) value {
    if(self.count >= 2) {
        return self[1];
    }
    return Nil;
}

-(BOOL) required {
    if(self.count >= 3) {
        return [self[2] boolValue];
    }
    return NO;
}


@end
