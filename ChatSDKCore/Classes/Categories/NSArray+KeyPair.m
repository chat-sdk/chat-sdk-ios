//
//  BSearchIndex.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 08/08/2016.
//
//

#import "NSArray+KeyPair.h"

@implementation NSArray(KeyPair)

+(id) keyPair:(NSString *)key value:(NSString *)value {
    if (key && value) {
        return @[key, value];
    }
    return Nil;
}

//-(BOOL) isEqual:(NSArray *) array {
//    return [self.firstObject isEqual:array.firstObject];
//}

-(NSString *) key {
    return self.firstObject;
}

-(NSString *) value {
    return self.lastObject;
}

@end
