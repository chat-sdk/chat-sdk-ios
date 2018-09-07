//
//  NSDictionary+Meta.m
//  AFNetworking
//
//  Created by Ben on 9/6/18.
//

#import "NSDictionary+Meta.h"

@implementation NSDictionary(Meta)

-(NSString *) metaStringForKey: (NSString *) key {
    return [self metaValueForKey:key];
}

-(id) metaValueForKey: (NSString *) key {
    return self[key];
}

-(NSDictionary *) setMetaDictValue: (id) value forKey: (NSString *) key {
    return [self updateMetaDict:@{key: value}];
}

-(NSDictionary *) updateMetaDict: (NSDictionary *) dict {
    NSMutableDictionary * meta = [NSMutableDictionary dictionaryWithDictionary:self];
    for (NSString * key in [dict allKeys]) {
        meta[key] = dict[key];
    }
    return meta;
}

@end
