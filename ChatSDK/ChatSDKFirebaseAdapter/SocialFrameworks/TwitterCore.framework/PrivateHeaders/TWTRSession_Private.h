//
//  TWTRSession_Private.h
//  TwitterCore
//
//  Created by Kang Chen on 9/6/15.
//  Copyright (c) 2015 Twitter Inc. All rights reserved.
//

#import <TwitterCore/TWTRSession.h>

@interface TWTRSession ()

/**
 * Returns YES if the dictionary represents a valid dictionary that can
 * safely be used to instantiate the TWTRSession object.
 */
+ (BOOL)isValidSessionDictionary:(NSDictionary *)dictionary;

/**
 *  Returns a new dictionary of the stored tokens and user context.
 */
- (NSDictionary *)dictionaryRepresentation;

@end
