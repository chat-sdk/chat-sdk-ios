//
//  GFBase32Utils.m
//  GeoFire
//
//  Created by Jonny Dimond on 7/7/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import "GFBase32Utils.h"

static const char BASE_32_CHARS[] = "0123456789bcdefghjkmnpqrstuvwxyz";

@implementation GFBase32Utils

+ (char)valueToBase32Character:(NSUInteger)value
{
    if (value > 31) {
        [NSException raise:NSInvalidArgumentException format:@"Not a valid base32 value: %lu", (unsigned long)value];
    }
    return BASE_32_CHARS[value];
}

+ (NSUInteger)base32CharacterToValue:(char)character
{
    for (NSUInteger i = 0; i < 32; i++) {
        if (BASE_32_CHARS[i] == character) {
            return i;
        }
    }
    [NSException raise:NSInvalidArgumentException format:@"Not a valid base32 character: %c", character];
    return 0;
}

+ (NSString *)base32Characters{
    static dispatch_once_t onceToken;
    static NSString *chars = nil;
    dispatch_once(&onceToken, ^{
        chars = [NSString stringWithUTF8String:BASE_32_CHARS];
    });
    return chars;
}

@end
