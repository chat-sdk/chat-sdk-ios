//
//  NSManagedObject+Meta.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 22/08/2016.
//
//

#import "NSObject+Meta.h"

@protocol PHasMetaObject <NSObject>

-(NSDictionary *) meta;
-(void) setMeta: (NSDictionary *) meta;

@end

@implementation NSObject(Meta)

-(NSDictionary *) impl_meta {
    if ([self respondsToSelector: @selector(meta)]) {
        return [((id<PHasMetaObject>)self) meta];
    }
    return Nil;
}

-(void) impl_setMeta: (NSDictionary *) data {
    if ([self respondsToSelector: @selector(setMeta:)]) {
        [((id<PHasMetaObject>)self) setMeta: data];
    }
}

-(NSDictionary *) metaDictionary {
    return [self impl_meta];
}

-(void) setMetaDictionary: (NSDictionary *) meta {
    [self impl_setMeta: meta];
}

-(NSString *) metaStringForKey: (NSString *) key {
    return [self metaValueForKey:key];
}

-(id) metaValueForKey: (NSString *) key {
    return self.metaDictionary[key];
}

-(void) setMetaValue: (id) value forKey: (NSString *) key {
    NSMutableDictionary * meta = [NSMutableDictionary dictionaryWithDictionary:[self metaDictionary]];
    meta[key] = value;
    [self setMetaDictionary:meta];
}

-(void) setMetaString: (NSString *) value forKey: (NSString *) key {
    [self setMetaValue:value forKey:key];
}

@end
