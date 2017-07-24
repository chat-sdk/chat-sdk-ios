//
//  TWTRScribeSerializable.h
//  TwitterKit
//
//  Created by Kang Chen on 11/18/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Protocol for Scribe event objects. Objects that conform to this protocol should easily serialize
 *  itself into an intermediate dictionary that can be further serialized into scribe event JSON.
 */
@protocol TWTRScribeSerializable <NSObject>

/**
 *  Canonical key used to serialize object to Scribe event JSON.
 */
+ (NSString *)scribeKey;
/**
 *  Dictionary used to serialize object to Scribe event JSON.
 */
- (NSDictionary *)dictionaryRepresentation;

@end
