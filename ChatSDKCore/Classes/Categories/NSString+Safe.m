//
//  NSString+Safe.m
//  AFNetworking
//
//  Created by ben3 on 29/04/2019.
//

#import "NSString+Safe.h"

@implementation NSString(Safe)

+(NSString *) safe: (NSString *) string {
    return string ? string : @"";
}

@end
